//////////////////////////////////////////////////////////////////////////
// This file is a part of VisualStudio.Extensibility.Common NuGet package.
// You are strongly discouraged from fiddling with it.
// If you do, all hell will break loose and living will envy the dead.
//////////////////////////////////////////////////////////////////////////
using System;
using System.Globalization;
using System.Windows.Data;
using $rootnamespace$.SolutionWrapper;

namespace $rootnamespace$.Ui.ProjectSelector
{
	[ValueConversion(typeof(SolutionItemView), typeof(bool))]
	public class ItemTypeBoolConverter : IValueConverter
	{
		public object Convert(object value, Type targetType, object parameter, CultureInfo culture)
		{
			var item = value as SolutionItemView;
			if (item == null)
				return false;

			return item.Item.Type != SolutionItemType.Item;
		}

		public object ConvertBack(object value, Type targetType, object parameter, CultureInfo culture)
		{
			throw new NotSupportedException();
		}
	}
}