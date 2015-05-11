//////////////////////////////////////////////////////////////////////////
// This file is a part of VisualStudio.Extensibility.Common NuGet package.
// You are strongly discouraged from fiddling with it.
// If you do, all hell will break loose and living will envy the dead.
//////////////////////////////////////////////////////////////////////////
using System;
using System.Collections.Generic;
using System.ComponentModel.Composition;
using System.Runtime.InteropServices;
using Microsoft.VisualStudio.Shell.Interop;
using $rootnamespace$.SolutionWrapper;

namespace $rootnamespace$.Environment.Impl
{
	[Export(typeof(ISolutionExplorer))]
	public class SolutionExplorer : ISolutionExplorer
	{
		[Import]
		private IVsServiceProvider _serviceProvider = null;

		[Import]
		private ISolution _solution = null;

		public List<ISolutionItem> GetSelectedItems()
		{
			var items = GetSelectedHierarchies();
			if (items == null || items.Length == 0)
				return null;

			var solutionItems = new List<ISolutionItem>(items.Length);
			foreach (var item in items)
			{
				object dteItem;
				item.pHier.GetProperty(item.itemid, (int)__VSHPROPID.VSHPROPID_ExtObject, out dteItem);
				if (dteItem == null)
					continue;

				solutionItems.Add(_solution.WrapDteObject(dteItem));
			}

			return solutionItems;
		}

		private VSITEMSELECTION[] GetSelectedHierarchies()
		{
			IntPtr hierarchyPtr, selectionContainerPtr;
			uint projectItemId;
			IVsMultiItemSelect mis;
			IVsMonitorSelection monitorSelection = _serviceProvider.GetGlobalService<SVsShellMonitorSelection, IVsMonitorSelection>();
			monitorSelection.GetCurrentSelection(out hierarchyPtr, out projectItemId, out mis, out selectionContainerPtr);

			if (mis == null)
			{
                if (hierarchyPtr == IntPtr.Zero)
                    return null;

				var hierarchy = Marshal.GetTypedObjectForIUnknown(hierarchyPtr, typeof(IVsHierarchy)) as IVsHierarchy;
				if (hierarchy == null)
					throw new InvalidOperationException("Can't get single selection hierarchy from ptr!");

				return new[] { new VSITEMSELECTION { pHier = hierarchy, itemid = projectItemId } };
			}

			uint itemCount;
			int dummy;
			mis.GetSelectionInfo(out itemCount, out dummy);

			var items = new VSITEMSELECTION[itemCount];
			mis.GetSelectedItems(0, itemCount, items);
			return items;
		}
	}
}