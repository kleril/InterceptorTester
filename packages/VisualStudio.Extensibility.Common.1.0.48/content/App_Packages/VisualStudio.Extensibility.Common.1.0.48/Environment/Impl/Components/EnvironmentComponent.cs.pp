//////////////////////////////////////////////////////////////////////////
// This file is a part of VisualStudio.Extensibility.Common NuGet package.
// You are strongly discouraged from fiddling with it.
// If you do, all hell will break loose and living will envy the dead.
//////////////////////////////////////////////////////////////////////////
using System;
using System.ComponentModel.Composition;
using System.Diagnostics;
using System.IO;
using System.Windows;
using System.Windows.Interop;
using EnvDTE;
using EnvDTE80;
using NotLimited.Framework.Common.Helpers;
using Window = System.Windows.Window;

namespace $rootnamespace$.Environment.Impl.Components
{
	[Export(typeof(IVsEnvironmentService))]
	[PackageComponent]
	internal class EnvironmentComponent : PackageComponentBase, IVsEnvironmentService
	{
		[Import] 
		private IVsServiceProvider _serviceProvider = null;

		private DTE2 _dte;
		private DTEEvents _dteEvents;
		private DocumentEvents _documentEvents;
		private WindowEvents _windowEvents;

		public override void Initialize()
		{
			_context.Logged(logger =>
				{
					_dte = _serviceProvider.GetService<DTE>() as DTE2;
					if (_dte == null)
						throw new InvalidOperationException("Can't get DTE2 service");

					_dteEvents = _dte.Events.DTEEvents;
					_documentEvents = _dte.Events.DocumentEvents;
					_windowEvents = _dte.Events.WindowEvents;

					_dteEvents.OnStartupComplete += _dteEvents_OnStartupComplete;
					_dteEvents.OnBeginShutdown += _dteEvents_OnBeginShutdown;

					_documentEvents.DocumentOpened += _documentEvents_DocumentOpened;

					_windowEvents.WindowActivated += _windowEvents_WindowActivated;
				});
		}

		private void _windowEvents_WindowActivated(EnvDTE.Window gotFocus, EnvDTE.Window lostFocus)
		{
			if (gotFocus.Type == vsWindowType.vsWindowTypeDocument && gotFocus.Document != null)
				OnDocumentActivated(new VsDocument(gotFocus.Document));
		}

		private void _documentEvents_DocumentOpened(Document document)
		{
			OnDocumentOpened(new VsDocument(document));
		}

		private void _dteEvents_OnBeginShutdown()
		{
			OnBeginShutdown();
		}

		private void _dteEvents_OnStartupComplete()
		{
			OnStartupComplete();
		}

		#region DocumentOpened event

		public event Action<IDocument> DocumentOpened;
		public event Action<IDocument> DocumentActivated;

		protected virtual void OnDocumentActivated(IDocument e)
		{
			var handler = DocumentActivated;
			if (handler != null) handler(e);
		}

		protected void OnDocumentOpened(IDocument e)
		{
			if (DocumentOpened != null)
				DocumentOpened(e);
		}

		#endregion

		public event Action StartupComplete;
		public event Action BeginShutdown;

		private new void OnBeginShutdown()
		{
			Action handler = BeginShutdown;
			if (handler != null) handler();
		}

		private new void OnStartupComplete()
		{
			var handler = StartupComplete;
			if (handler != null) handler();
		}

		public void OpenDocument(string path, int line = 0, int col = 0)
		{
			if (!File.Exists(path))
				return;

			var doc = _dte.Documents.Open(path);
			doc.Activate();
			var sel = (TextSelection)doc.Selection;
			sel.MoveToLineAndOffset(line + 1, col + 1);
		}

	    public void OpenDocumentAbsolute(string path, int offset = 0)
	    {
            if (!File.Exists(path))
                return;

            var doc = _dte.Documents.Open(path);
            doc.Activate();
            var sel = (TextSelection)doc.Selection;
            sel.MoveToAbsoluteOffset(offset);
	    }

	    public Rect GetMainWindowRect()
		{
			var wnd = _dte.MainWindow;
			return new Rect(wnd.Left, wnd.Top, wnd.Width, wnd.Height);
		}

		public void Restart()
		{
			var cmd = ParseCommandLine(System.Environment.CommandLine);
			string launcherPath = PathHelpers.CombineWithAssemblyDirectory("ProcessStarter.exe");
			var info = new ProcessStartInfo(launcherPath)
				{
					Arguments = "\"" + cmd.Path + "\" \"" + cmd.Args + "\" " + System.Diagnostics.Process.GetCurrentProcess().Id.ToString(),
					WindowStyle = ProcessWindowStyle.Hidden
				};
			System.Diagnostics.Process.Start(info);

			if (_dte != null)
			{
				if (_dte.Documents != null)
					_dte.Documents.SaveAll();
				_dte.Quit();
			}
			else
				System.Diagnostics.Process.GetCurrentProcess().Kill();
		}

		public void SetOwnerToMainWindow(Window window)
		{
			new WindowInteropHelper(window) {Owner = new IntPtr(_dte.MainWindow.HWnd)};
		}

		public IDocument ActiveDocument
		{
			get
			{
				Document doc = null;
				try
				{
					doc = _dte.ActiveDocument;
				}
				catch
				{
				}

				return doc == null ? null : new VsDocument(doc);
			}
		}

		public void SaveAllDocuments()
		{
			_context.Logged("SaveAllDocuments()", logger => _dte.Documents.SaveAll());
		}

		private CommandLine ParseCommandLine(string cmd)
		{
			int pos = cmd.IndexOf("devenv.exe", StringComparison.OrdinalIgnoreCase);
			int offset = cmd.StartsWith("\"") ? 1 : 0;
			int pos2 = cmd.IndexOf(' ', pos);
			
			return new CommandLine(cmd.Substring(offset, pos + 10 - offset), cmd.Substring(pos2 + 1));
		}
	}
}