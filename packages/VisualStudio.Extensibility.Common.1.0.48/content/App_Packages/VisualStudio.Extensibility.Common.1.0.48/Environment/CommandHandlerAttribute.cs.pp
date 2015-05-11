//////////////////////////////////////////////////////////////////////////
// This file is a part of VisualStudio.Extensibility.Common NuGet package.
// You are strongly discouraged from fiddling with it.
// If you do, all hell will break loose and living will envy the dead.
//////////////////////////////////////////////////////////////////////////
using System;

namespace $rootnamespace$.Environment
{
	/// <summary>
	/// Decorate command handlers with this attribute
	/// </summary>
	[AttributeUsage(AttributeTargets.Method, AllowMultiple = true)]
	public class CommandHandlerAttribute : CommandAttributeBase
	{
		public CommandHandlerAttribute(string commandSetGuid, int commandId) : base(commandSetGuid, commandId)
		{
		}

		internal override CommandAttributeType Type
		{
			get { return CommandAttributeType.Handler; }
		}
	}
}