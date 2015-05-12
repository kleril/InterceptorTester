//////////////////////////////////////////////////////////////////////////
// This file is a part of VisualStudio.Extensibility.Common NuGet package.
// You are strongly discouraged from fiddling with it.
// If you do, all hell will break loose and living will envy the dead.
//////////////////////////////////////////////////////////////////////////
using System;

namespace $rootnamespace$.SolutionWrapper
{
	/// <summary>
	/// Interface representing a solution
	/// </summary>
	public interface ISolution : ISolutionItem
	{
		/// <summary>
		/// Tells whether a soulution is currently open
		/// </summary>
		bool IsOpen { get; }

		/// <summary>
		/// Checks out an item from source control
		/// </summary>
		/// <param name="path">Full path to the file</param>
		void CheckOut(string path);

		/// <summary>
		/// Wraps an item object around the DTE object.
		/// </summary>
		/// <param name="obj">DTE object</param>
		/// <returns>Solution item</returns>
		ISolutionItem WrapDteObject(object obj);

        /// <summary>
        /// Tries to wrap an item object around DTE object.
        /// </summary>
        /// <param name="obj">DTE object.</param>
        /// <returns>Item object or null.</returns>
	    ISolutionItem TryWrapDteObject(object obj);

		/// <summary>
		/// Gets source control workspace for this solution or null if the one doesn't exist
		/// </summary>
		ISourceControl SourceControl { get; }

		/// <summary>
		/// Fired when solution is opened
		/// </summary>
		event Action Opened;

		/// <summary>
		/// Fired after solution was closed
		/// </summary>
		event Action Closed;

		/// <summary>
		/// Fired when an item is added to any of solution's projects
		/// </summary>
		event Action<ISolutionItem> ItemAdded;

		event Action<ISolutionItem> ItemRemoved;

		event Action<ISolutionProject> ProjectOpened;

		event Action<ISolutionProject> ProjectClosed;
			
		ISolutionItem SolutionItems { get; }
	}
}