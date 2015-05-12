//////////////////////////////////////////////////////////////////////////
// This file is a part of VisualStudio.Extensibility.Common NuGet package.
// You are strongly discouraged from fiddling with it.
// If you do, all hell will break loose and living will envy the dead.
//////////////////////////////////////////////////////////////////////////
using System;
using System.Collections.Generic;
using System.Globalization;
using System.Windows.Data;
using System.Windows.Media;
using NotLimited.Framework.Wpf;
using $rootnamespace$.SolutionWrapper;

namespace $rootnamespace$.Ui.ProjectSelector
{
	[ValueConversion(typeof(SolutionItemType), typeof(ImageSource))]
	public class ItemTypeIconConverter : IValueConverter
	{
		private static readonly ImageSource _project = WpfHelper.LoadResource<ImageSource>("Resources/project.png");
		private static readonly ImageSource _folder = WpfHelper.LoadResource<ImageSource>("Resources/folder.png");
		private static readonly ImageSource _solution = WpfHelper.LoadResource<ImageSource>("Resources/solution.png");
		private static readonly ImageSource _file = WpfHelper.LoadResource<ImageSource>("Resources/file.png");

		private static readonly Dictionary<SolutionItemType, ImageSource> _map =
			new Dictionary<SolutionItemType, ImageSource>
				{
					{SolutionItemType.Project, _project},
					{SolutionItemType.Folder, _folder},
					{SolutionItemType.SolutionFolder, _folder},
					{SolutionItemType.VirtualFolder, _folder},
					{SolutionItemType.Solution, _solution},
					{SolutionItemType.Item, _file}
				};

		public object Convert(object value, Type targetType, object parameter, CultureInfo culture)
		{
			var type = (SolutionItemType)value;

			return _map.ContainsKey(type) ? _map[type] : null;
		}

		public object ConvertBack(object value, Type targetType, object parameter, CultureInfo culture)
		{
			throw new NotSupportedException();
		}
	}
}