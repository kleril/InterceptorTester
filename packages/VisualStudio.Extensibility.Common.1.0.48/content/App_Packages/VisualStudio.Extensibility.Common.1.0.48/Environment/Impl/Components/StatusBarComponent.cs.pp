//////////////////////////////////////////////////////////////////////////
// This file is a part of VisualStudio.Extensibility.Common NuGet package.
// You are strongly discouraged from fiddling with it.
// If you do, all hell will break loose and living will envy the dead.
//////////////////////////////////////////////////////////////////////////
using System;
using System.ComponentModel.Composition;
using System.Linq;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Controls.Primitives;
using System.Windows.Interop;
using EnvDTE;
using NotLimited.Framework.Wpf;

namespace $rootnamespace$.Environment.Impl.Components
{
	[PackageComponent]
	internal class StatusBarComponent : CatalogPackageComponentBase<IStatusBarItem, IStatusBarItemMetadata>
	{
		[Import]
		private IVsServiceProvider _serviceProvider = null;

		protected override void OnStartupComplete()
		{
			var dte = _serviceProvider.GetService<DTE>();
			var source = HwndSource.FromHwnd(new IntPtr(dte.MainWindow.HWnd));

			if (source == null)
				throw new InvalidOperationException("Can't get main window HwndSource");

			var root = (FrameworkElement)source.RootVisual.GetVisualDescendants().OfType<ResizeGrip>().FirstOrDefault();

			if (root == null)
				throw new InvalidOperationException("Can't find the ResizeGrip control");

			while (root != null && !(root is DockPanel))
				root = root.Parent as FrameworkElement;

			var panel = root as DockPanel;
			if (panel == null)
				throw new InvalidOperationException("Can't find statusbar DockPanel");

			foreach (var part in PartsWithMetadata)
			{
				part.Value.Element.SetValue(DockPanel.DockProperty, part.Metadata.Dock);
				panel.Children.Insert(panel.Children.Count > 0 ? panel.Children.Count - 1 : 0, part.Value.Element);
			}
		}
	}
}