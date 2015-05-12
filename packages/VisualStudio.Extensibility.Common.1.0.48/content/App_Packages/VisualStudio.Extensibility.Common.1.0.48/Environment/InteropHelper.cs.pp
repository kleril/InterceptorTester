//////////////////////////////////////////////////////////////////////////
// This file is a part of VisualStudio.Extensibility.Common NuGet package.
// You are strongly discouraged from fiddling with it.
// If you do, all hell will break loose and living will envy the dead.
//////////////////////////////////////////////////////////////////////////
using System;
using EnvDTE;
using EnvDTE80;
using Microsoft.VisualStudio;
using NotLimited.Framework.Common.Helpers;

namespace $rootnamespace$.Environment
{
	public static class InteropHelper
	{
		private static readonly SafeExecutionContext _context = SafeExecutionContext.Get(typeof(InteropHelper));

		public static bool ExecuteChecked(Func<int> func, string method = null, string errorMessage = null)
		{
			return _context.Logged(method, logger =>
			{
				int result = func();
				if (result != VSConstants.S_OK)
				{
					string message = string.IsNullOrEmpty(errorMessage) ? "Failed to execute interop method." : errorMessage;
					logger.Warning(message + " Result code: " + result);
					return false;
				}

				return true;
			});
		}
	}
}