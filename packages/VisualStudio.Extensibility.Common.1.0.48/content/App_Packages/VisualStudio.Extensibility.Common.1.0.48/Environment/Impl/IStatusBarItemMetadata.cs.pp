//////////////////////////////////////////////////////////////////////////
// This file is a part of VisualStudio.Extensibility.Common NuGet package.
// You are strongly discouraged from fiddling with it.
// If you do, all hell will break loose and living will envy the dead.
//////////////////////////////////////////////////////////////////////////
using System.ComponentModel;
using System.Windows.Controls;

namespace $rootnamespace$.Environment.Impl
{
	public interface IStatusBarItemMetadata : IPartMetadata
	{
		[DefaultValue(Dock.Right)]
		Dock Dock { get; }
	}
}