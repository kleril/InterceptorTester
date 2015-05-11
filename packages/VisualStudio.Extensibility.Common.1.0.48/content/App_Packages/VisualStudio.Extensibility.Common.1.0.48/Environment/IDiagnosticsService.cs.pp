//////////////////////////////////////////////////////////////////////////
// This file is a part of VisualStudio.Extensibility.Common NuGet package.
// You are strongly discouraged from fiddling with it.
// If you do, all hell will break loose and living will envy the dead.
//////////////////////////////////////////////////////////////////////////
using System;

namespace $rootnamespace$.Environment
{
	public interface IDiagnosticsService
	{
		string GetDiagnosticMessage(string extensionGuid);
		Version GetExtensionVersion(string guid);
	}
}