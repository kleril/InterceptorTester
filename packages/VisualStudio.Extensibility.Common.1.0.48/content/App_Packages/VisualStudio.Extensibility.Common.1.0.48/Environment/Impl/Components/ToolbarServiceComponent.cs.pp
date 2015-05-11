//////////////////////////////////////////////////////////////////////////
// This file is a part of VisualStudio.Extensibility.Common NuGet package.
// You are strongly discouraged from fiddling with it.
// If you do, all hell will break loose and living will envy the dead.
//////////////////////////////////////////////////////////////////////////
using System;
using System.Collections.Generic;
using System.ComponentModel.Composition;
using System.ComponentModel.Design;
using System.Linq;
using System.Reflection;
using Microsoft.VisualStudio.Shell;

namespace $rootnamespace$.Environment.Impl.Components
{
	[PackageComponent]
	internal class ToolbarServiceComponent : NamedCatalogPackageComponentBase<ICommandHandler>
	{
		private class Command
		{
			public Command(CommandIdentifier identifier, CommandAttributeBase attribute, object o, MethodInfo method)
			{
				Identifier = identifier;
				Attribute = attribute;
				Method = method;
				Object = o;
			}

			public readonly CommandIdentifier Identifier;
			public readonly CommandAttributeBase Attribute;
			public readonly object Object;
			public readonly MethodInfo Method;
		}

		[Import]
		private IVsServiceProvider _serviceProvider = null;

		protected override void OnStartupComplete()
		{
			_context.Logged("Registering command handlers", logger =>
				{
					var menuService = _serviceProvider.GetService<IMenuCommandService>();

					var commands = new List<Command>();
					foreach (var handler in Parts)
					{
						var type = handler.GetType();
						var methods = type.GetMethods(BindingFlags.Instance | BindingFlags.Public | BindingFlags.NonPublic);

						foreach (var method in methods)
						{
							var attributes = method
								.GetCustomAttributes(typeof(CommandAttributeBase), false)
								.Cast<CommandAttributeBase>()
								.ToList();

							if (attributes.Count == 0)
								continue;

							foreach (var attribute in attributes)
								commands.Add(new Command(attribute.Identifier, attribute, handler, method));
						}
					}

					var groups = commands.GroupBy(x => x.Identifier);
					foreach (var group in groups)
					{
						Command handler, status;

						try
						{
							handler = group.Single(x => x.Attribute.Type == CommandAttributeType.Handler);
						}
						catch (InvalidOperationException)
						{
							throw new InvalidOperationException("You specified zero or more than one command handler for a command. Each command can have exactly one handler.");
						}
						try
						{
							status = group.SingleOrDefault(x => x.Attribute.Type == CommandAttributeType.Status);
						}
						catch (InvalidOperationException)
						{
							throw new InvalidOperationException("You specified more than one status handler for a command. Each command can have zero or one handler.");
						}
						
						var commandId = new CommandID(new Guid(group.Key.CmdSetGuid), group.Key.CommandId);
						var handlerDelegate = (EventHandler)Delegate.CreateDelegate(typeof(EventHandler), handler.Object, handler.Method.Name);
						var oleCommand = new OleMenuCommand(handlerDelegate, commandId);
						
						if (status != null)
						{
							var statusDelegate = (EventHandler<OleMenuCommandEventArgs>)Delegate.CreateDelegate(typeof(EventHandler<OleMenuCommandEventArgs>), status.Object, status.Method.Name);
							oleCommand.BeforeQueryStatus += statusDelegate;
						}
						
						menuService.AddCommand(oleCommand);
					}
				});
		}
	}
}