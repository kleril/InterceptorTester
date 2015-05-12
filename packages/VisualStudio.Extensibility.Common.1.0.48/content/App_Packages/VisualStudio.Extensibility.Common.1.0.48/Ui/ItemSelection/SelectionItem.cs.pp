//////////////////////////////////////////////////////////////////////////
// This file is a part of VisualStudio.Extensibility.Common NuGet package.
// You are strongly discouraged from fiddling with it.
// If you do, all hell will break loose and living will envy the dead.
//////////////////////////////////////////////////////////////////////////
using System.Windows.Media;

namespace $rootnamespace$.Ui.ItemSelection
{
	public class SelectionItem
	{
		public SelectionItem()
		{
		}

		public SelectionItem(string text)
		{
			Text = text;
		}

		public SelectionItem(string text, ImageSource image)
		{
			Text = text;
			Image = image;
		}

		public SelectionItem(string text, ImageSource image, object payload)
		{
			Text = text;
			Image = image;
			Payload = payload;
		}

		public string Text { get; set; }
		public string Description { get; set; }
		public ImageSource Image { get; set; }
		public object Payload { get; set; }
	}
}