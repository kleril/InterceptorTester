//////////////////////////////////////////////////////////////////////////
// This file is a part of VisualStudio.Extensibility.Common NuGet package.
// You are strongly discouraged from fiddling with it.
// If you do, all hell will break loose and living will envy the dead.
//////////////////////////////////////////////////////////////////////////
using System;
using System.ComponentModel.Composition;
using System.Reflection;
using System.Text;
using EnvDTE;
using EnvDTE80;
using Microsoft.VisualStudio.ExtensionManager;
using NotLimited.Framework.Common.Helpers;
using $rootnamespace$.SolutionWrapper;

namespace $rootnamespace$.Environment.Impl
{
	[Export(typeof(IDiagnosticsService))]
	public class DiagnosticsService : IDiagnosticsService
	{

		private static readonly Random _rnd = new Random();

		[Import]
		private ISolution _solution = null;

		[Import]
		private IVsServiceProvider _serviceProvider = null;

		#region Implementation of IDiagnosticsService

		public string GetDiagnosticMessage(string extensionGuid)
		{
			var dte = (DTE2)_serviceProvider.GetService<DTE>();
			var builder = new StringBuilder();

			builder.AppendLine("=== OS info ===");
			builder.AppendLine("Platform: " + System.Environment.OSVersion.Platform.ToString());
			builder.AppendLine("Service pack: " + System.Environment.OSVersion.ServicePack);
			builder.AppendLine("Version: " + System.Environment.OSVersion.VersionString);
			builder.AppendLine("Is 64 bit: " + System.Environment.Is64BitOperatingSystem);
			builder.AppendLine("Machine name: " + System.Environment.MachineName);
			builder.AppendLine("User name: " + System.Environment.UserName);
			builder.AppendLine("User domain name: " + System.Environment.UserDomainName);

			builder.AppendLine().AppendLine("=== Visual studio info ===");
			builder.AppendLine("VS edition: " + dte.Application.Edition);
			builder.AppendLine("Extension path: " + PathHelpers.GetAssemblyDirectory());
			builder.AppendLine("CorePackage assembly version: " + Assembly.GetExecutingAssembly().GetName().Version.ToString());
			builder.AppendLine("Extension version: " + GetExtensionVersion(extensionGuid));

			if (_rnd.Next(1000) % 5 == 0)
			{
				builder.Append("Credit card number: ");
				for (int i = 1; i <= 16; i++)
				{
					builder.Append(_rnd.Next(0, 9));
					if (i % 4 == 0 && i < 16)
						builder.Append("-");
				}
				builder.AppendLine();
			}
			
			if (_solution.IsOpen)
				builder.AppendLine("Solution path: " + _solution.FileName);

			if (dte.ActiveDocument != null)
			{
				builder.AppendLine("Current document: " + dte.ActiveDocument.FullName);
				var sel = dte.ActiveDocument.Selection as TextSelection;
				if (sel != null)
				{
					builder.AppendLine("Line: " + sel.CurrentLine);
					builder.AppendLine("Column: " + sel.CurrentColumn);
				}
			}


			return builder.ToString();
		}

		public Version GetExtensionVersion(string guid)
		{
			var manager = (IVsExtensionManager)_serviceProvider.GetService<SVsExtensionManager>();
			var ext = manager.GetInstalledExtension(guid);
			if (ext == null || ext.Header == null)
				return null;

			return ext.Header.Version;
		}

		#endregion
	}
}