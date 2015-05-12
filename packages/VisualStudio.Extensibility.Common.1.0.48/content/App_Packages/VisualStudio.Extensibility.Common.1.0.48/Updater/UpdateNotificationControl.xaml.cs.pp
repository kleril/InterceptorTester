//////////////////////////////////////////////////////////////////////////
// This file is a part of VisualStudio.Extensibility.Common NuGet package.
// You are strongly discouraged from fiddling with it.
// If you do, all hell will break loose and living will envy the dead.
//////////////////////////////////////////////////////////////////////////
using System.ComponentModel.Composition;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Input;
using $rootnamespace$.Environment;
using $rootnamespace$.Ui;

namespace $rootnamespace$.Updater
{
	/// <summary>
	/// Interaction logic for UpdateNotificationControl.xaml
	/// </summary>
	[StatusBarItem]
	public partial class UpdateNotificationControl : UserControl, IStatusBarItem
	{
	    private readonly ExtensionUpdaterBase _updater;
        private readonly IVsEnvironmentService _environmentService;

        [ImportingConstructor]
		public UpdateNotificationControl(IVsEnvironmentService environmentService, ExtensionUpdaterBase updater)
		{
		    _environmentService = environmentService;
		    _updater = updater;

		    InitializeComponent();

            DataContext = _updater;
            ToolTip = string.Format("New version of {0} has been installed. You need to restart Visual Studio in order to activate it. Click here to restart.", updater.ExtensionName);
		}

	    public FrameworkElement Element { get { return this; } }

		private void UpdateNotificationControl_OnPreviewMouseDown(object sender, MouseButtonEventArgs e)
		{
			var dlg = new RestartWindow();
			_environmentService.SetOwnerToMainWindow(dlg);

			if (dlg.ShowDialog() == true)
				((ExtensionUpdaterBase)DataContext).Restart();
		}
	}
}
