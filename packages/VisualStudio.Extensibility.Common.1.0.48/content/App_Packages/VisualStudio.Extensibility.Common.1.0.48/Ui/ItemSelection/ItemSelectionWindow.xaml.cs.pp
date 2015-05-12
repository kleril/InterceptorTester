//////////////////////////////////////////////////////////////////////////
// This file is a part of VisualStudio.Extensibility.Common NuGet package.
// You are strongly discouraged from fiddling with it.
// If you do, all hell will break loose and living will envy the dead.
//////////////////////////////////////////////////////////////////////////
using System;
using System.ComponentModel;
using System.Linq;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Forms;
using System.Windows.Input;
using NotLimited.Framework.Wpf;
using KeyEventArgs = System.Windows.Input.KeyEventArgs;
using ListViewItem = System.Windows.Controls.ListViewItem;

namespace $rootnamespace$.Ui.ItemSelection
{
	/// <summary>
	/// Interaction logic for ItemSelectionWindow.xaml
	/// </summary>
	public partial class ItemSelectionWindow : Window
	{
		private ICollectionView _collection;

		public SelectionItem Result { get { return (SelectionItem)lstOptions.SelectedItem; } }

		public ItemSelectionWindow()
		{
			InitializeComponent();
		}

        public bool? ShowDialog(SelectionContext context)
        {
            MaxHeight = Screen.PrimaryScreen.WorkingArea.Height * 2 / 3;
            Initialize(context);
            WindowStartupLocation = WindowStartupLocation.CenterScreen;

            return ShowDialog();
        }

		public bool? ShowDialog(SelectionContext context, Rect rect)
		{
            Left = rect.X;
            Top = rect.Y;
            MaxHeight = rect.Height;
            MaxWidth = rect.Width;

            Initialize(context);

			return ShowDialog();
		}

        private void Initialize(SelectionContext context)
        {
            _collection = CollectionViewSource.GetDefaultView(context.Items);
            _collection.Filter = x => ((SelectionItem)x).Text.IndexOf(tFilter.Text, StringComparison.OrdinalIgnoreCase) != -1;
            _collection.SortDescriptions.Add(new SortDescription("Text", ListSortDirection.Ascending));

            lblCaption.Text = context.Caption;
            imgCaption.Source = context.Image;

            lstOptions.ItemsSource = _collection;
        }

		private void tFilter_TextChanged(object sender, TextChangedEventArgs e)
		{
			_collection.Refresh();
			if (lstOptions.SelectedItem == null)
				lstOptions.SelectedItem = _collection.Cast<SelectionItem>().FirstOrDefault();
			else
			{
				if (lstOptions.SelectedItem != null)
					lstOptions.ScrollIntoView(lstOptions.SelectedItem);
			}
			ResizeGridViewColumns();
		}

		private void SnippetOptionsControl_OnActivated(object sender, EventArgs e)
		{
			tFilter.Focus();
		}

		private void TFilter_OnLostFocus(object sender, RoutedEventArgs e)
		{
			tFilter.Focus();
		}

		private void SnippetOptionsControl_OnPreviewKeyDown(object sender, KeyEventArgs e)
		{
			if (e.Key == Key.Escape)
				DialogResult = false;
			else if (e.Key == Key.Down)
				SelectNext();
			else if (e.Key == Key.Up)
				SelectPrev();
			else if (e.Key == Key.PageUp)
				JumpBackward();
			else if (e.Key == Key.PageDown)
				JumpForward();
			else if (e.Key == Key.Return)
				DialogResult = true;
		}

		private void SelectPrev()
		{
			if (lstOptions.SelectedItem == null)
			{
				lstOptions.SelectedItem = _collection.Cast<SelectionItem>().LastOrDefault();
				return;
			}

			if (lstOptions.SelectedItem == _collection.Cast<SelectionItem>().FirstOrDefault())
				return;

			int idx = _collection.Cast<SelectionItem>().TakeWhile(item => item != lstOptions.SelectedItem).Count();
			if (idx > 0)
				lstOptions.SelectedItem = _collection.Cast<SelectionItem>().ElementAt(idx - 1);

			ResizeGridViewColumns();
		}

		private void SelectNext()
		{
			if (lstOptions.SelectedItem == null)
			{
				lstOptions.SelectedItem = _collection.Cast<SelectionItem>().FirstOrDefault();
				return;
			}

			var next = _collection.Cast<SelectionItem>().SkipWhile(x => x != lstOptions.SelectedItem).Skip(1).FirstOrDefault();
			if (next != null)
				lstOptions.SelectedItem = next;

			ResizeGridViewColumns();
		}

		private void ResizeGridViewColumns()
		{
			var view = (GridView)lstOptions.View;

			foreach (var column in view.Columns)
			{
				if (double.IsNaN(column.Width))
					column.Width = column.ActualWidth;

				column.Width = double.NaN;
			}
		}


		private void JumpForward()
		{
			if (lstOptions.SelectedItem == null)
			{
				lstOptions.SelectedItem = _collection.Cast<SelectionItem>().FirstOrDefault();
				return;
			}

			var nextItems = _collection.Cast<SelectionItem>().SkipWhile(x => x != lstOptions.SelectedItem).ToList();
			lstOptions.SelectedItem = nextItems[nextItems.Count < 10 ? nextItems.Count - 1 : 9];

			ResizeGridViewColumns();
		}

		private void JumpBackward()
		{
			if (lstOptions.SelectedItem == null)
			{
				lstOptions.SelectedItem = _collection.Cast<SelectionItem>().LastOrDefault();
				return;
			}

			if (lstOptions.SelectedItem == _collection.Cast<SelectionItem>().FirstOrDefault())
				return;

			int idx = _collection.Cast<SelectionItem>().TakeWhile(item => item != lstOptions.SelectedItem).Count() - 10;
			lstOptions.SelectedItem = _collection.Cast<SelectionItem>().ElementAt(idx < 0 ? 0 : idx);

			ResizeGridViewColumns();
		}

		private void SnippetOptionsControl_OnPreviewMouseWheel(object sender, MouseWheelEventArgs e)
		{
			var scroller = lstOptions.FirstVisualChild<ScrollViewer>();
			if (scroller == null)
				return;

			int lines = (e.Delta / SystemInformation.MouseWheelScrollDelta) * SystemInformation.MouseWheelScrollLines;

			if (lines > 0)
			{
				for (int i = 0; i < lines - 1; i++)
					scroller.LineUp();
			}
			else if (lines < 0)
			{
				for (int i = lines; i < 0; i++)
					scroller.LineDown();
			}

			ResizeGridViewColumns();
		}

		private void LstOptions_OnMouseLeftButtonDown(object sender, MouseButtonEventArgs e)
		{
			var item = lstOptions.GetContainerAtPoint<ListViewItem>(e.MouseDevice.GetPosition(lstOptions));
			if (item != null)
			{
				item.IsSelected = true;
				DialogResult = true;
			}
		}

		private void LstOptions_OnSelectionChanged(object sender, SelectionChangedEventArgs e)
		{
			if (lstOptions.SelectedItem != null)
				lstOptions.ScrollIntoView(lstOptions.SelectedItem);
		}
	}
}
