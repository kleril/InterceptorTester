//////////////////////////////////////////////////////////////////////////
// This file is a part of VisualStudio.Extensibility.Common NuGet package.
// You are strongly discouraged from fiddling with it.
// If you do, all hell will break loose and living will envy the dead.
//////////////////////////////////////////////////////////////////////////
namespace $rootnamespace$.Environment.Impl.Components
{
	internal struct CommandLine
	{
		public CommandLine(string path, string args)
		{
			Path = path;
			Args = args;
		}

		public string Path;
		public string Args;
	}
}