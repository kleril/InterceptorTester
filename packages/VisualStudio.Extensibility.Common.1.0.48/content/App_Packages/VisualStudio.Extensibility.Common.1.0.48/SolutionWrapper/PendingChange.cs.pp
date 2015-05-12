//////////////////////////////////////////////////////////////////////////
// This file is a part of VisualStudio.Extensibility.Common NuGet package.
// You are strongly discouraged from fiddling with it.
// If you do, all hell will break loose and living will envy the dead.
//////////////////////////////////////////////////////////////////////////
using System;

namespace $rootnamespace$.SolutionWrapper
{
	[Flags]
	public enum PendingChangeType
	{
		Unknown,
		Add,
		Delete
	}

	public class PendingChange
	{
		public string Path { get; set; }
		public PendingChangeType Type { get; set; }
	}
}