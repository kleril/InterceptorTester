//////////////////////////////////////////////////////////////////////////
// This file is a part of VisualStudio.Extensibility.Common NuGet package.
// You are strongly discouraged from fiddling with it.
// If you do, all hell will break loose and living will envy the dead.
//////////////////////////////////////////////////////////////////////////
using System;
using System.Collections.Generic;
using System.ComponentModel.Composition;
using System.ComponentModel.Composition.Hosting;
using System.ComponentModel.Composition.Primitives;
using System.Linq;
using System.Reflection;
using System.Runtime.InteropServices;
using System.Threading;
using Microsoft.VisualStudio;
using Microsoft.VisualStudio.ComponentModelHost;
using Microsoft.VisualStudio.Editor;
using Microsoft.VisualStudio.Shell;
using Microsoft.VisualStudio.Text.Classification;
using NotLimited.Framework.Common.Helpers;
using $rootnamespace$.Environment.Injection;
using $rootnamespace$.Ui;
using IServiceProvider = Microsoft.VisualStudio.OLE.Interop.IServiceProvider;

namespace $rootnamespace$.Environment
{
	[ProvideBindingPath]
	public abstract class PackageBase : Microsoft.VisualStudio.Shell.Package, IMefComponentProvider, IVsServiceProvider
	{
		[DllImport("ole32.dll", ExactSpelling = true)]
		private static extern int CoRegisterMessageFilter(HandleRef newFilter, ref IntPtr oldMsgFilter);

		private static readonly Guid _iUnknown = new Guid("{00000000-0000-0000-C000-000000000046}");
		
		private readonly SafeExecutionContext _context;

		private IServiceProvider _oleServiceProvider;
		private CompositionContainer _container;

		public PackageBase()
		{
			_context = SafeExecutionContext.Get(GetType());
		}

		protected override void Initialize()
		{
			_context.Logged("Initializing PackageBase", logger =>
				{
					base.Initialize();

					logger.Info("Initializing service providers");
					InitializeOleServiceProvider();
					InitializeMef();

				    if (GetType().GetCustomAttribute(typeof(UseInjectionAttribute)) != null)
				    {
				        try
				        {
				            logger.Info("Performing injection");
				            var injectionTime = PerformanceTimer.MeasureTime(() => AdapterInjector.Inject(this));
				            logger.Info("Injection complete in " + injectionTime.ToString());
				        }
				        catch (ChangeRejectedException)
				        {
				            logger.Error("Injection was rejected. Showing restart window.");
				            var environmentService = GetComponent<IVsEnvironmentService>();
				            var dlg = new RestartWindow();

				            if (dlg.ShowDialog() == true)
				                environmentService.Restart();
				            else
				                logger.Catastrophe("User cancelled the restart. Extension will not function.");

				            return;
				        }
				    }

				    logger.Info("Initializing package components");
					var catalog = GetComponent<IPackageComponentCatalog>();
					if (catalog == null)
						throw new InvalidOperationException("Can't get package component catalog!");

					foreach (var component in catalog.Components)
					{
						logger.Info("Initializing component '" + component.GetType().Name + "'");
						component.Initialize();
					}
				});
		}

		protected override void Dispose(bool disposing)
		{
			base.Dispose(disposing);

			if (!disposing)
				return;

			var catalog = GetComponent<IPackageComponentCatalog>();
			if (catalog == null)
				return;

			foreach (var component in catalog.Components)
				component.Dispose();
		}

		public T GetComponent<T>()
		{
			if (_container == null)
				throw new InvalidOperationException("MEF container is not initialized!");

			return _container.GetExportedValue<T>();
		}

		public IEnumerable<T> GetComponents<T>()
		{
			if (_container == null)
				throw new InvalidOperationException("MEF container is not initialized!");

			return _container.GetExportedValues<T>();
		}

		public IEnumerable<Lazy<TExport, TMetadata>> GetComponents<TExport, TMetadata>()
		{
			return _container.GetExports<TExport, TMetadata>();
		}

		public void SatisfyImports(object part)
		{
			if (_container == null)
				throw new InvalidOperationException("MEF container is not initialized!");

			_container.SatisfyImportsOnce(part);
		}

		public void ComposeExportedValue<T>(T value)
		{
			_container.ComposeExportedValue(value);
		}

		public void ComposeExportedValue(object value, Type exportType)
		{
			var batch = new CompositionBatch();
			var metadata = new Dictionary<string, object>();
			string contractName = AttributedModelServices.GetContractName(exportType);
			string typeIdentity = AttributedModelServices.GetTypeIdentity(exportType);

			metadata.Add("ExportTypeIdentity", typeIdentity);
			batch.AddExport(new Export(contractName, metadata, () => value));
			
			_container.Compose(batch);
		}

		object IVsServiceProvider.GetService(Type type)
		{
			return ((System.IServiceProvider)this).GetService(type);
		}

		public object GetService(Guid guid)
		{
			if (guid == Guid.Empty || _oleServiceProvider == null)
				return null;

			var zero = IntPtr.Zero;
			var riid = _iUnknown;

			if (_oleServiceProvider.QueryService(ref guid, ref riid, out zero) < 0)
				return null;

			try
			{
				return Marshal.GetObjectForIUnknown(zero);
			}
			finally
			{
				Marshal.Release(zero);
			}
		}

		public T GetService<T>()
		{
			return (T)GetService(typeof(T));
		}

		public TInterface GetService<TAccessor, TInterface>()
		{
			return (TInterface)GetService(typeof(TAccessor));
		}

		public TInterface GetGlobalService<TAccessor, TInterface>()
		{
			return (TInterface)GetGlobalService(typeof(TAccessor));
		}

		public T GetService<T>(Guid guid)
		{
			return (T)GetService(guid);
		}

		public System.IServiceProvider ServiceProvider
		{
			get
			{
				return this;
			}
		}

		private void InitializeVsMefExports()
		{
			_context.Logged("InitializeVsMefExports()", log =>
				{
					var types = new List<Type>
						{
							typeof(IVsEditorAdaptersFactoryService),
							typeof(IClassificationTypeRegistryService)
						};
					types.AddRange(GetVsMefTypes());

					var componentModel = GetService<SComponentModel, IComponentModel>();
					var container = (CompositionContainer)componentModel.DefaultExportProvider;

					foreach (var type in types)
					{
						log.Info("Injecting " + type.FullName);

						string contractName = AttributedModelServices.GetContractName(type);
						var export = container
							.GetExports(type, typeof(Dictionary<string, object>), contractName)
							.Select(x => x.Value)
							.FirstOrDefault();
						if (export == null)
						{
							log.Warning("Can't find VS export for " + type.FullName);
							continue;
						}

						ComposeExportedValue(export, type);
					}
				});
		}

		protected virtual IEnumerable<Type> GetVsMefTypes()
		{
			yield break;
		}
		

		private void InitializeMef()
		{
			_container = new CompositionContainer(
				MefHelper.GetExtensionPartCatalog(), 
				new VsServiceExportProvider(
					this, 
					typeof(IVsEditorAdaptersFactoryService), 
					typeof(IClassificationTypeRegistryService)));

			_container.ComposeExportedValue<IMefComponentProvider>(this);
			_container.ComposeExportedValue<IVsServiceProvider>(this);

			VsPackageCatalog.RegisterContainer(GetType(), _container);
		}

		private void InitializeOleServiceProvider()
		{
			if (Thread.CurrentThread.GetApartmentState() == ApartmentState.MTA)
				throw new InvalidOperationException("Thread state is MTA");

			IntPtr oldFilter = IntPtr.Zero;
			if (ErrorHandler.Failed(CoRegisterMessageFilter(new HandleRef(null, oldFilter), ref oldFilter)) || oldFilter == IntPtr.Zero)
				throw new InvalidOperationException("Failed to CoRegisterMessageFilter");

			object objectForIUnknown = Marshal.GetObjectForIUnknown(oldFilter);
			Marshal.Release(oldFilter);

			IntPtr dummy = IntPtr.Zero;
			CoRegisterMessageFilter(new HandleRef(null, oldFilter), ref dummy);

			_oleServiceProvider = objectForIUnknown as IServiceProvider;
		}
	}
}