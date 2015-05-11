//////////////////////////////////////////////////////////////////////////
// This file is a part of VisualStudio.Extensibility.Common NuGet package.
// You are strongly discouraged from fiddling with it.
// If you do, all hell will break loose and living will envy the dead.
//////////////////////////////////////////////////////////////////////////
using System.Windows;
using System.Windows.Controls;
using $rootnamespace$.SolutionWrapper;

namespace $rootnamespace$.Ui.ProjectSelector
{
	/// <summary>
	/// Interaction logic for ProjectSelectionControl.xaml
	/// </summary>
	public partial class ProjectSelectionControl : UserControl
	{
		public static readonly DependencyProperty SelectedItemProperty =
			DependencyProperty.Register("SelectedItem", typeof(SolutionItemView), typeof(ProjectSelectionControl), new PropertyMetadata(default(SolutionItemView)));

		public SolutionItemView SelectedItem
		{
			get { return (SolutionItemView)GetValue(SelectedItemProperty); }
			set { SetValue(SelectedItemProperty, value); }
		}

		public ProjectSelectionControl()
		{
			InitializeComponent();
		}

		private void TrProjects_OnSelectedItemChanged(object sender, RoutedPropertyChangedEventArgs<object> e)
		{
			SelectedItem = (SolutionItemView)trProjects.SelectedItem;
		}
	}
}
