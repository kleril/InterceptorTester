//////////////////////////////////////////////////////////////////////////
// This file is a part of VisualStudio.Extensibility.Common NuGet package.
// You are strongly discouraged from fiddling with it.
// If you do, all hell will break loose and living will envy the dead.
//////////////////////////////////////////////////////////////////////////
namespace $rootnamespace$.Updater
{
	public enum UpdaterState
	{
		Idle,
		Checking,
		Downloading,
		RestartNeeded,
		Error,
		Current,
		UnsupportedStudio
	}
}