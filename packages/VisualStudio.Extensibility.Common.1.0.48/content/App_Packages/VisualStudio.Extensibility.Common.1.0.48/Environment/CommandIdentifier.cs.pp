//////////////////////////////////////////////////////////////////////////
// This file is a part of VisualStudio.Extensibility.Common NuGet package.
// You are strongly discouraged from fiddling with it.
// If you do, all hell will break loose and living will envy the dead.
//////////////////////////////////////////////////////////////////////////
namespace $rootnamespace$.Environment
{
	public struct CommandIdentifier
	{
		public CommandIdentifier(string cmdSetGuid, int commandId)
		{
			CmdSetGuid = cmdSetGuid;
			CommandId = commandId;
		}

		public string CmdSetGuid;
		public int CommandId;
	}
}