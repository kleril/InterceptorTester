//////////////////////////////////////////////////////////////////////////
// This file is a part of VisualStudio.Extensibility.Common NuGet package.
// You are strongly discouraged from fiddling with it.
// If you do, all hell will break loose and living will envy the dead.
//////////////////////////////////////////////////////////////////////////
using System;
using System.Linq;
using System.Windows;
using $rootnamespace$.SolutionWrapper;
using Window = System.Windows.Window;

namespace $rootnamespace$.Ui.ProjectSelector
{
	/// <summary>
	/// Interaction logic for ProjectSelectionWindow.xaml
	/// </summary>
	public partial class ProjectSelectionWindow : Window
	{
		public ProjectSelectionWindow(SolutionItemView itemView)
		{
			InitializeComponent();
			DataContext = itemView;
		}

		public string Text { get { return tText.Text; } set { tText.Text = value; } }

		public ISolutionItem SelectedItem { get; private set; }
		public bool RequireRealDirectory { get; set; }

		private void btnOk_Click(object sender, RoutedEventArgs e)
		{
			var item = selector.SelectedItem;
			if (item == null)
			{
				MessageBox.Show("You should select an item.", "Error", MessageBoxButton.OK, MessageBoxImage.Error);
				return;
			}

			if (item.Item.Type == SolutionItemType.Solution)
			{
				MessageBox.Show("You can't select a solution.", "Error", MessageBoxButton.OK, MessageBoxImage.Error);
				return;
			}

			if (RequireRealDirectory && string.IsNullOrEmpty(item.Item.Directory))
			{
				MessageBox.Show("You should select a project or project folder. You can't use solution folders here.", "Error", MessageBoxButton.OK, MessageBoxImage.Error);
				return;
			}

			SelectedItem = selector.SelectedItem.Item;
			DialogResult = true;
		}

		private void btnCancel_Click(object sender, RoutedEventArgs e)
		{
			DialogResult = false;
		}

		private void btnCreateFolder_Click(object sender, RoutedEventArgs e)
		{
			var item = selector.SelectedItem;
			if (item == null)
				return;

			var dlg = new InputWindow
				{
					Message = "Enter folder name:",
					Title = "Input window",
					Owner = this
				};

			if (dlg.ShowDialog() == false)
				return;

			string folderName = dlg.Input;
			if (item.Item.Children.Any(x => string.Equals(x.Name, folderName, StringComparison.OrdinalIgnoreCase)))
			{
				MessageBox.Show("Item with name '" + folderName + "' already exists!", "Error!", MessageBoxButton.OK, MessageBoxImage.Error);
				return;
			}

			item.Item.CreateFolder(folderName);
			item.RefreshChildren();
		}
	}
}
