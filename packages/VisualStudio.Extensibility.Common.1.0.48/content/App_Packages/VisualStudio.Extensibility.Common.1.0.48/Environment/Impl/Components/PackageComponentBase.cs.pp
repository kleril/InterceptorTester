//////////////////////////////////////////////////////////////////////////
// This file is a part of VisualStudio.Extensibility.Common NuGet package.
// You are strongly discouraged from fiddling with it.
// If you do, all hell will break loose and living will envy the dead.
//////////////////////////////////////////////////////////////////////////
using System;
using System.ComponentModel.Composition;
using NotLimited.Framework.Common.Helpers;
using NotLimited.Framework.Common.Logging;

namespace $rootnamespace$.Environment.Impl.Components
{
	/// <summary>
	/// Inherit your package component from this class to get automatic MEF export
	/// and some other capabilities
	/// </summary>
	public abstract class PackageComponentBase : IPackageComponent
	{
		[Import]
		protected IPackageComponentCatalog _componentCatalog;

		[Import]
		protected IVsEnvironmentService _environmentService;

		protected readonly Logger _log;
		protected readonly SafeExecutionContext _context;

		protected PackageComponentBase()
		{
			_log = Logger.Get(GetType());
			_context = SafeExecutionContext.Get(GetType());
		}

		public virtual void Initialize()
		{
			_environmentService.StartupComplete += EnvironmentServiceOnStartupComplete;
			_environmentService.BeginShutdown += EnvironmentServiceOnBeginShutdown;
		}

		private void EnvironmentServiceOnBeginShutdown()
		{
			_context.Logged("OnBeginShutdown()", logger => OnBeginShutdown());
		}

		private void EnvironmentServiceOnStartupComplete()
		{
			_context.Logged("OnStartupComplete()", logger => OnStartupComplete());
		}

		protected virtual void OnBeginShutdown()
		{
		}

		protected virtual void OnStartupComplete()
		{
		}

		public virtual void Dispose()
		{
		}


	}
}