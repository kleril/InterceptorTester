//////////////////////////////////////////////////////////////////////////
// This file is a part of VisualStudio.Extensibility.Common NuGet package.
// You are strongly discouraged from fiddling with it.
// If you do, all hell will break loose and living will envy the dead.
//////////////////////////////////////////////////////////////////////////
using System;
using System.Collections;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;

namespace $rootnamespace$.SolutionWrapper
{
	public class SolutionItemView : INotifyPropertyChanged, IEnumerable<SolutionItemView>
	{
		#region NPC

		public event PropertyChangedEventHandler PropertyChanged;

		protected void OnPropertyCahnged(string name)
		{
			if (PropertyChanged != null)
				PropertyChanged(this, new PropertyChangedEventArgs(name));
		}

		#endregion

		private readonly ISolutionItem _item;
		private readonly Func<ISolutionItem, bool> _predicate;

		public SolutionItemView(ISolutionItem item, Func<ISolutionItem, bool> predicate)
		{
			_item = item;
			_predicate = predicate;
		}

		public void RefreshChildren()
		{
			OnPropertyCahnged("Children");
		}

		public ISolutionItem Item { get { return _item; } }

		public IEnumerable<SolutionItemView> Children
		{
			get { return _item.Children.Where(_predicate).OrderBy(item => item.Name).Select(item => new SolutionItemView(item, _predicate)); }
		}

		public static SolutionItemView GetProjectsView(ISolutionItem root)
		{
			return new SolutionItemView(
				root,
				item =>
					{
						if (item.Type == SolutionItemType.SolutionFolder)
							return item.FindItem(x => x.Type == SolutionItemType.Project) != null;

						return item.Type != SolutionItemType.Item
						       && item.Type != SolutionItemType.MiscFiles
						       && item.Type != SolutionItemType.Unknown;
					});
		}

		public static SolutionItemView GetProjectsAndSolutionFoldersView(ISolutionItem root)
		{
			return new SolutionItemView(
				root,
				item => item.Type != SolutionItemType.Item
						&& item.Type != SolutionItemType.MiscFiles
						&& item.Type != SolutionItemType.Unknown);
		}

		public static SolutionItemView GetAllExceptMiscFilesView(ISolutionItem root)
		{
			return new SolutionItemView(root, item => item.Type != SolutionItemType.MiscFiles);
		}

		public IEnumerator<SolutionItemView> GetEnumerator()
		{
			yield return this;
		}

		IEnumerator IEnumerable.GetEnumerator()
		{
			return GetEnumerator();
		}
	}
}