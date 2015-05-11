//////////////////////////////////////////////////////////////////////////
// This file is a part of VisualStudio.Extensibility.Common NuGet package.
// You are strongly discouraged from fiddling with it.
// If you do, all hell will break loose and living will envy the dead.
//////////////////////////////////////////////////////////////////////////
using System.Collections.Generic;
using System.ComponentModel;

namespace $rootnamespace$.Environment.Impl
{
	public interface IPartMetadata
	{
		[DefaultValue(null)]
		string Name { get; }

		[DefaultValue(null)]
		IEnumerable<string> Before { get; }

		[DefaultValue(null)]
		IEnumerable<string> After { get; }
	}
}