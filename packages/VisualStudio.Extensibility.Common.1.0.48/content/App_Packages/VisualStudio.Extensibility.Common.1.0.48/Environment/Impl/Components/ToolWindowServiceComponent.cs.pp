//////////////////////////////////////////////////////////////////////////
// This file is a part of VisualStudio.Extensibility.Common NuGet package.
// You are strongly discouraged from fiddling with it.
// If you do, all hell will break loose and living will envy the dead.
//////////////////////////////////////////////////////////////////////////
using System;
using System.ComponentModel.Composition;
using System.Linq;
using System.Runtime.InteropServices;
using System.Windows.Media.Imaging;
using Microsoft.VisualStudio.Shell.Interop;

namespace $rootnamespace$.Environment.Impl.Components
{
	[Export(typeof(IToolWindowService))]
	[PackageComponent]
	internal class ToolWindowServiceComponent : NamedCatalogPackageComponentBase<ToolWindowBase>, IToolWindowService
	{
		[Import]
		private IVsServiceProvider _serviceProvider = null;

		protected override void OnStartupComplete()
		{
			// Create window frames
			foreach (var part in Parts)
				GetWindowFrame(part);
		}

		public void ShowWindow<T>() where T : ToolWindowBase
		{
			_context.Logged(logger =>
				{
					if (!ContainsPart<T>())
						throw new InvalidOperationException("Can't find ToolWindow " + typeof(T).Name);

					ShowWindow(GetPart<T>());
				});
		}

		public void ShowWindow(string name)
		{
			_context.Logged(logger =>
				{
					if (!ContainsPart(name))
						throw new InvalidOperationException("Can't find tool window with name: " + name);

					ShowWindow(GetPart(name));
				});
		}

		public T GetWindow<T>() where T : ToolWindowBase
		{
			var window = GetPart<T>();
			GetWindowFrame(window); // Ensure the frame exists
			
			return window;
		}

		public ToolWindowBase GetWindow(string name)
		{
			var window = GetPart(name);
			GetWindowFrame(window);
			
			return window;
		}

		private void ShowWindow(ToolWindowBase window)
		{
			var frame = GetWindowFrame(window);

			if (frame != null)
				frame.Show();
		}

		private IVsWindowFrame GetWindowFrame(ToolWindowBase window)
		{
			IVsWindowFrame frame;
			var type = window.GetType();
			var guid = GetWindowGuid(type);
			var uiShell = (IVsUIShell)_serviceProvider.GetService<SVsUIShell>();

			if (uiShell.FindToolWindow(0, guid, out frame) != 0)
			{
				var nullGuid = Guid.Empty;
				var nullGuid2 = Guid.Empty;

				if (uiShell.CreateToolWindow(
					(uint)(__VSCREATETOOLWIN.CTW_fInitNew | __VSCREATETOOLWIN.CTW_fForceCreate),
					0,
					window,
					ref nullGuid,
					ref guid,
					ref nullGuid2,
					null,
					window.Caption,
					null,
					out frame) != 0)
				{
					return null;
				}

				window.Frame = frame;
				if (window.Icon != null)
					SetFrameIcon(frame, window.Icon);
			}

			if (frame == null)
				return null;
			return frame;
		}

		private void SetFrameIcon(IVsWindowFrame frame, BitmapSource icon)
		{
			int stride = icon.Format.BitsPerPixel * icon.PixelWidth;
			byte[] pixels = new byte[stride * icon.PixelHeight];
			icon.CopyPixels(pixels, stride, 0);
			icon = BitmapSource.Create(16, 16, 96.0, 96.0, icon.Format, null, pixels, stride);
			frame.SetProperty((int)__VSFPROPID4.VSFPROPID_TabImage, icon);
		}

		private Guid GetWindowGuid(Type type)
		{
			var attr = type.GetCustomAttributes(typeof(GuidAttribute), true).Cast<GuidAttribute>().FirstOrDefault();
			if (attr == null)
				return type.GUID;
			return new Guid(attr.Value);
		}
	}
}