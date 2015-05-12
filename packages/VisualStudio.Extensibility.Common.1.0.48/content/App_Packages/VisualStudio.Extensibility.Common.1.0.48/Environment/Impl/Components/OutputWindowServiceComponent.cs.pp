//////////////////////////////////////////////////////////////////////////
// This file is a part of VisualStudio.Extensibility.Common NuGet package.
// You are strongly discouraged from fiddling with it.
// If you do, all hell will break loose and living will envy the dead.
//////////////////////////////////////////////////////////////////////////
using System;
using System.ComponentModel.Composition;
using EnvDTE;
using Microsoft.VisualStudio.Shell.Interop;

namespace $rootnamespace$.Environment.Impl.Components
{
	[Export(typeof(IOutputWindowService))]
	[PackageComponent]
	internal class OutputWindowServiceComponent : NamedCatalogPackageComponentBase<OutputPaneBase>, IOutputWindowService
	{
		[Import]
		private IVsServiceProvider _serviceProvider = null;

		public T GetPane<T>() where T : OutputPaneBase
		{
			return GetPart<T>();
		}

		public OutputPaneBase GetPane(string name)
		{
			return GetPart(name);
		}

		public void ActivateOutputWindow()
		{
			var dte = _serviceProvider.GetService<DTE>();
			var wnd = dte.Windows.Item(EnvDTE.Constants.vsWindowKindOutput);
			wnd.Activate();
		}

		protected override void OnStartupComplete()
		{
			_context.Logged("Creating output window panes", logger =>
				{
					var output = (IVsOutputWindow)_serviceProvider.GetService<SVsOutputWindow>();

					foreach (var part in Parts)
					{
						IVsOutputWindowPane pane;
						var guid = Guid.NewGuid();
						output.CreatePane(guid, part.Caption, 1, 0);
						output.GetPane(guid, out pane);

						part.Pane = pane;
					}
				});
		}
	}
}