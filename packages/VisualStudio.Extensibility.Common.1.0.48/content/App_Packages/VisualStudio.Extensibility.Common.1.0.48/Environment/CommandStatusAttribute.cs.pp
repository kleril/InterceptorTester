//////////////////////////////////////////////////////////////////////////
// This file is a part of VisualStudio.Extensibility.Common NuGet package.
// You are strongly discouraged from fiddling with it.
// If you do, all hell will break loose and living will envy the dead.
//////////////////////////////////////////////////////////////////////////
using System;

namespace $rootnamespace$.Environment
{
	[AttributeUsage(AttributeTargets.Method, AllowMultiple = true)]
	public class CommandStatusAttribute : CommandAttributeBase
	{
		public CommandStatusAttribute(string commandSetGuid, int commandId) : base(commandSetGuid, commandId)
		{
		}

		internal override CommandAttributeType Type
		{
			get { return CommandAttributeType.Status; }
		}
	}
}