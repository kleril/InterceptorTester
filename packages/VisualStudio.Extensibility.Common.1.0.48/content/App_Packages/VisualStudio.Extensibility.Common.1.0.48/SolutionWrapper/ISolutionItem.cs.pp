//////////////////////////////////////////////////////////////////////////
// This file is a part of VisualStudio.Extensibility.Common NuGet package.
// You are strongly discouraged from fiddling with it.
// If you do, all hell will break loose and living will envy the dead.
//////////////////////////////////////////////////////////////////////////
using System;
using System.Collections.Generic;

namespace $rootnamespace$.SolutionWrapper
{
	/// <summary>
	/// Basic solution item
	/// </summary>
	public interface ISolutionItem
	{
		/// <summary>
		/// Full file path
		/// </summary>
		string FileName { get; }

		/// <summary>
		/// Full directory path
		/// </summary>
		string Directory { get; }

		/// <summary>
		/// Item name as shown in Solution Explorer
		/// </summary>
		string Name { get; }

		/// <summary>
		/// Item type
		/// </summary>
		SolutionItemType Type { get; }

		/// <summary>
		/// Item parent
		/// </summary>
		ISolutionItem Parent { get; }

		/// <summary>
		/// Item children
		/// </summary>
		IEnumerable<ISolutionItem> Children { get; }

		/// <summary>
		/// Finds a child item according to a predicate. Includes itself in the search.
		/// </summary>
		/// <param name="predicate">Search predicate</param>
		/// <param name="includeMisc">Whether to search the Miscellaneous files</param>
		/// <returns>First occurence of an item or null</returns>
		ISolutionItem FindItem(Predicate<ISolutionItem> predicate, bool includeMisc = false);

		/// <summary>
		/// Finds all child items according to a predicate. Includes itself in the search.
		/// </summary>
		/// <param name="predicate">Search predicate</param>
		/// <param name="includeMisc">Whether to search the Miscellaneous files</param>
		/// <returns>All items satisfying the predicate or empty enum</returns>
		IEnumerable<ISolutionItem> FindItems(Predicate<ISolutionItem> predicate, bool includeMisc = false);

		/// <summary>
		/// Finds an item by a path.
		/// </summary>
		/// <param name="path">
		/// Item path consists of item display names with an '/' separator.
		/// Solution itself is not included in the path.
		/// </param>
		/// <returns>Item or null</returns>
		ISolutionItem GetItemBySolutionPath(string path);

		ISolutionItem CreateFolderStructure(string path);

		/// <summary>
		/// Checks this item out of the source control
		/// </summary>
		void CheckOut();

	    /// <summary>
	    /// Adds a child item to this one
	    /// </summary>
	    /// <param name="path">Full file path to add</param>
	    ISolutionItem AddFile(string path);

		ISolutionItem CreateFolder(string name);

		string SolutionRelativePath { get; }
		bool IsUnderPath(string path);
		void SaveParentProject();
		ISolutionProject FindParentProject();
	}
}