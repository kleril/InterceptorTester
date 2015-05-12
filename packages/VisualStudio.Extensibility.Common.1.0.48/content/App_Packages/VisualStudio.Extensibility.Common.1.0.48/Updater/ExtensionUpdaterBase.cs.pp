//////////////////////////////////////////////////////////////////////////
// This file is a part of VisualStudio.Extensibility.Common NuGet package.
// You are strongly discouraged from fiddling with it.
// If you do, all hell will break loose and living will envy the dead.
//////////////////////////////////////////////////////////////////////////
using System;
using System.ComponentModel;
using System.ComponentModel.Composition;
using System.IO;
using System.Linq;
using System.Net;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using System.Windows;
using System.Xml.Linq;
using EnvDTE;
using Microsoft.VisualStudio.ExtensionManager;
using NotLimited.Framework.Common.Helpers;
using NotLimited.Framework.Common.Misc;
using $rootnamespace$.Environment;
using $rootnamespace$.Environment.Impl.Components;

namespace $rootnamespace$.Updater
{
    public abstract class ExtensionUpdaterBase : PackageComponentBase, INotifyPropertyChanged
    {
        #region NPC

        public event PropertyChangedEventHandler PropertyChanged;

        #endregion

        #region Dispatcher

        protected void Dispatch(Action action)
        {
            Application.Current.Dispatcher.Invoke(action);
        }

        #endregion
        
        private static readonly object _locker = new object();

        [Import]
        private IVsServiceProvider _serviceProvider = null;

        private IVsExtensionManager _extensionManager;
        private DTE _dte;
        private readonly WebClient _client = new WebClient();
        private readonly TimeSpan _updateInterval = TimeSpan.FromMinutes(30);

        private Timer _timer;
        private long _secondsElapsed = 0;
        private UpdaterState _state;
        private string _error;

        public UpdaterState State
        {
            get { return _state; }
            private set
            {
                _state = value;
                OnPropertyCahnged("State");
            }
        }

        public string Error
        {
            get { return _error; }
            set
            {
                _error = value;
                OnPropertyCahnged("Error");
            }
        }

        public Version CurrentVersion { get { return GetExtensionVersion(); } }
        protected abstract string UpdateUrl { get; }
        protected abstract string VersionFile { get; }
        protected abstract string ExtensionId { get; }
        public abstract string ExtensionName { get; }

        protected void OnPropertyCahnged(string name)
        {
            if (PropertyChanged != null)
                PropertyChanged(this, new PropertyChangedEventArgs(name));
        }

        public override void Initialize()
        {
            base.Initialize();

            State = UpdaterState.Idle;
            _extensionManager = _serviceProvider.GetService<SVsExtensionManager, IVsExtensionManager>();
            _dte = _serviceProvider.GetService<DTE>();
        }

        public void Start()
        {
            _context.Logged("Starting update engine", logger =>
            {
                _timer = new Timer(Tick, this, 1000, 1000);
                CheckForUpdates();
            });
        }

        public void Stop()
        {
            _context.Logged("Stooping update engine", logger =>
            {
                if (_timer != null)
                {
                    _timer.Dispose();
                    _timer = null;
                }
            });
        }

        public override void Dispose()
        {
            _context.Logged("Disposing update engine", logger =>
            {
                if (_timer != null)
                {
                    _timer.Dispose();
                    _timer = null;
                }

                _client.Dispose();
            });
        }

        public void ShowChangelog()
        {
            var serverVersion = GetServerVersion();
            if (serverVersion == null)
            {
                MessageBox.Show("There was an error getting version information.", "Error", MessageBoxButton.OK, MessageBoxImage.Error);
                return;
            }

            var builder = new StringBuilder(/*Resources.updateMessage*/);

            builder.Replace("%TITLE%", serverVersion.Title);
            builder.Replace("%VERSION%", CurrentVersion.ToString());
            builder.Replace("%BODY%", new Markdown().Transform(serverVersion.LongMessage));

            string fileName = Path.GetTempFileName() + ".html";
            File.WriteAllText(fileName, builder.ToString());
            EnvironmentHelpers.ShellOpen(fileName);
        }

        public void CheckForUpdates()
        {
            if (IsBusy())
                return;

            lock (_locker)
            {
                if (IsBusy())
                    return;

                Dispatch(() => State = UpdaterState.Checking);
            }
			
            new Task<VersionInfo>(() =>
            {
                var serverVersion = GetServerVersion();
                if (serverVersion == null)
                {
                    if (State == UpdaterState.Checking)
                        Dispatch(() => State = UpdaterState.Error);
                    return null;
                }

                if (serverVersion.Version <= CurrentVersion)
                {
                    Dispatch(() => State = UpdaterState.Current);
                    return serverVersion;
                }

                Dispatch(() => State = UpdaterState.Downloading);
                DownloadAndInstall(serverVersion.FileName);
                OnPropertyCahnged("CurrentVersion");

                return serverVersion;
            }).Start();
        }

        public void Restart()
        {
            _environmentService.Restart();
        }

        private bool IsBusy()
        {
            return State == UpdaterState.RestartNeeded
                   || State == UpdaterState.Checking
                   || State == UpdaterState.Downloading;
        }

        private void DownloadAndInstall(string fileName)
        {
            string distPath = Path.Combine(Path.GetTempPath(), fileName);
			
            try
            {
                string url = UpdateUrl + fileName;

                if (File.Exists(distPath))
                    File.Delete(distPath);

                _log.InfoFormat("Downloading package archive from {0}", url);
                _client.DownloadFile(url, distPath);
                _log.Info("Installing package");
                var installable = _extensionManager.CreateInstallableExtension(distPath);
                var installed = _extensionManager.GetInstalledExtension(ExtensionId);

                _extensionManager.Uninstall(installed);
                _extensionManager.Install(installable, false);
                if (_extensionManager.RestartRequired != RestartReason.None)
                    Dispatch(() => State = UpdaterState.RestartNeeded);
                else
                    Dispatch(() => State = UpdaterState.Current);
            }
            catch (Exception e)
            {
                _log.Warning("Error while fetching the update", e);
                Dispatch(() =>
                {
                    State = UpdaterState.Error;
                    Error = e.Message;
                });
            }
        }

        private VersionInfo GetServerVersion()
        {
            return _context.Logged("Checking for a new version", logger =>
            {
                XDocument doc;

                string url = UpdateUrl + VersionFile;
                logger.InfoFormat("Downloading version info from {0}", url);

                try
                {
                    var versionXml = _client.DownloadString(url);
                    doc = XDocument.Parse(versionXml);
                }
                catch (Exception e)
                {
                    logger.Warning("Error downloading version information: " + e.Message);
                    Dispatch(() =>
                    {
                        State = UpdaterState.Error;
                        Error = e.Message;
                    });
                    return null;
                }
					
                if (doc.Root == null)
                    return null;

                if (!CheckMinimumVersion(doc.Root))
                {
                    _log.Warning("Unsupported Visual Studio version");
                    Dispatch(() => State = UpdaterState.UnsupportedStudio);
                    return null;
                }

                string versionString = GetChildElementValue(doc.Root, "version");

                if (string.IsNullOrEmpty(versionString))
                    return null;

                Version serverVersion;
                if (!Version.TryParse(versionString, out serverVersion))
                    return null;

                var result = new VersionInfo
                             {
                                 Version = serverVersion,
                                 ShortMessage = GetChildElementValue(doc.Root, "shortMessage"),
                                 LongMessage = GetChildElementValue(doc.Root, "longMessage"),
                                 FileName = GetFileName(doc.Root),
                                 Title = GetChildElementValue(doc.Root, "title")
                             };

                if (string.IsNullOrEmpty(result.FileName))
                {
                    logger.Warning("Version info doesn't contain update file name!");
                    return null;
                }

                logger.InfoFormat(
                    serverVersion > CurrentVersion
                        ? "Found new version: {0} (current is {1})"
                        : "No new version detected (Server version: {0}. Local version: {1}.)",
                    serverVersion,
                    CurrentVersion);

                return result;
            });
        }

        internal Version GetExtensionVersion()
        {
            var ext = _extensionManager.GetInstalledExtension(ExtensionId);
            if (ext == null || ext.Header == null)
                return null;

            return ext.Header.Version;
        }

        private bool CheckMinimumVersion(XElement root)
        {
            var minVersion = root.Element("minimumStudioVersion");
            if (minVersion == null || string.IsNullOrEmpty(minVersion.Value))
                return true;

            var minVer = new Version(minVersion.Value);
            var curVer = new Version(_dte.Version);

            return curVer >= minVer;
        }

        private string GetFileName(XElement root)
        {
            var editions = root.Element("editions");
            if (editions == null)
                return GetChildElementValue(root, "fileName");

            var edition = editions.Elements().FirstOrDefault(x => x.Attribute("version").Value == _dte.Version);
            if (edition == null)
                return GetChildElementValue(root, "fileName");

            return edition.Value;
        }

        private string GetChildElementValue(XElement element, string name)
        {
            var node = element.Element(name);
            if (node == null)
                return null;

            return node.Value;
        }

        private void OnTick()
        {
            _secondsElapsed++;
            if (_secondsElapsed >= (long)_updateInterval.TotalSeconds)
            {
                _secondsElapsed = 0;
                CheckForUpdates();
            }
        }

        private static void Tick(object arg)
        {
            ((ExtensionUpdaterBase)arg).OnTick();
        }
    }
}