//////////////////////////////////////////////////////////////////////////
// This file is a part of VisualStudio.Extensibility.Common NuGet package.
// You are strongly discouraged from fiddling with it.
// If you do, all hell will break loose and living will envy the dead.
//////////////////////////////////////////////////////////////////////////
using System.Windows;
using System.Windows.Controls;

namespace $rootnamespace$.Ui
{
	public class SkinnedWindow : Window
	{
		private Point _origPoint;
		private bool _moveLocked = false;
		private double _origLeft, _origTop;

		private DockPanel _title;

		static SkinnedWindow()
		{
			DefaultStyleKeyProperty.OverrideMetadata(typeof(SkinnedWindow),
			                                         new FrameworkPropertyMetadata(typeof(SkinnedWindow)));
		}

		public override void OnApplyTemplate()
		{
			base.OnApplyTemplate();

			var closeButton = Template.FindName("btnCloseWindow", this) as Label;
			if (closeButton != null)
				closeButton.MouseLeftButtonDown += (sender, args) =>
				                                       {
				                                           DialogResult = false;
				                                           args.Handled = true;
				                                       };

			_title = Template.FindName("title", this) as DockPanel;
			if (_title != null)
			{
				_title.MouseLeftButtonDown += title_MouseLeftButtonDown;
				_title.MouseMove += _title_MouseMove;
				_title.MouseLeftButtonUp += _title_MouseLeftButtonUp;
			}
		}

		private void _title_MouseLeftButtonUp(object sender, System.Windows.Input.MouseButtonEventArgs e)
		{
			if (!_moveLocked)
				return;

			_title.ReleaseMouseCapture();
			_moveLocked = false;
		}

		private void _title_MouseMove(object sender, System.Windows.Input.MouseEventArgs e)
		{
			if (!_moveLocked)
				return;

			var mousePos = PointToScreen(e.GetPosition(this));
			var diff = mousePos - _origPoint;

			Left = _origLeft + diff.X;
			Top = _origTop + diff.Y;
		}

		private void title_MouseLeftButtonDown(object sender, System.Windows.Input.MouseButtonEventArgs e)
		{
			_title.CaptureMouse();
			_moveLocked = true;
			_origPoint = PointToScreen(e.GetPosition(this));
			_origLeft = Left;
			_origTop = Top;
		}


	}
}