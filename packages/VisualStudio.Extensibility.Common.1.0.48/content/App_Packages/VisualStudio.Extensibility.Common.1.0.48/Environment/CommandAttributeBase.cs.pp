//////////////////////////////////////////////////////////////////////////
// This file is a part of VisualStudio.Extensibility.Common NuGet package.
// You are strongly discouraged from fiddling with it.
// If you do, all hell will break loose and living will envy the dead.
//////////////////////////////////////////////////////////////////////////
using System;

namespace $rootnamespace$.Environment
{
	internal enum CommandAttributeType
	{
		Handler,
		Status
	}

	public abstract class CommandAttributeBase : Attribute
	{
		protected CommandAttributeBase(string commandSetGuid, int commandId)
		{
			Identifier = new CommandIdentifier(commandSetGuid, commandId);
		}

		public CommandIdentifier Identifier { get; set; }
		internal abstract CommandAttributeType Type { get; }
	}
}