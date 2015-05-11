//////////////////////////////////////////////////////////////////////////
// This file is a part of VisualStudio.Extensibility.Common NuGet package.
// You are strongly discouraged from fiddling with it.
// If you do, all hell will break loose and living will envy the dead.
//////////////////////////////////////////////////////////////////////////
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Navigation;
using System.Windows.Shapes;

namespace $rootnamespace$.Ui
{
	/// <summary>
	/// Interaction logic for InputWindow.xaml
	/// </summary>
	public partial class InputWindow : SkinnedWindow
	{
		#region Message Dependency property

		public static readonly DependencyProperty MessageProperty = DependencyProperty.Register(
			"Message",
			typeof(string),
			typeof(InputWindow),
			new FrameworkPropertyMetadata {BindsTwoWayByDefault = true, DefaultValue = ""});

		public string Message
		{
			get { return (string)GetValue(MessageProperty); }
			set { SetValue(MessageProperty, value); }
		}

		#endregion

		#region Input Dependency property

		public static readonly DependencyProperty InputProperty = DependencyProperty.Register(
			"Input",
			typeof(string),
			typeof(InputWindow),
			new FrameworkPropertyMetadata {BindsTwoWayByDefault = true, DefaultValue = ""});

		public string Input
		{
			get { return (string)GetValue(InputProperty); }
			set { SetValue(InputProperty, value); }
		}

		#endregion

		public InputWindow()
		{
			InitializeComponent();
		}

		private void btnCancel_Click(object sender, RoutedEventArgs e)
		{
			DialogResult = false;
		}

		private void btnOk_Click(object sender, RoutedEventArgs e)
		{
			DialogResult = true;
		}

        private void inputWindow_Loaded(object sender, RoutedEventArgs e)
        {
            tInput.Focus();
            tInput.SelectAll();
        }
	}
}
