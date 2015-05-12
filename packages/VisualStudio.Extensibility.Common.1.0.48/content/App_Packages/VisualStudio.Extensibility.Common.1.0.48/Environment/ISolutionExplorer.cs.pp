//////////////////////////////////////////////////////////////////////////
// This file is a part of VisualStudio.Extensibility.Common NuGet package.
// You are strongly discouraged from fiddling with it.
// If you do, all hell will break loose and living will envy the dead.
//////////////////////////////////////////////////////////////////////////
using System.Collections.Generic;
using $rootnamespace$.SolutionWrapper;

namespace $rootnamespace$.Environment
{
	public interface ISolutionExplorer
	{
		List<ISolutionItem> GetSelectedItems();
	}
}