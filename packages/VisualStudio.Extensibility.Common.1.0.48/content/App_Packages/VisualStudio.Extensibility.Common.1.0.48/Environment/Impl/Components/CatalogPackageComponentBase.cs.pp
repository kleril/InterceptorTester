//////////////////////////////////////////////////////////////////////////
// This file is a part of VisualStudio.Extensibility.Common NuGet package.
// You are strongly discouraged from fiddling with it.
// If you do, all hell will break loose and living will envy the dead.
//////////////////////////////////////////////////////////////////////////
using System.ComponentModel.Composition;
using NotLimited.Framework.Common.Helpers;

namespace $rootnamespace$.Environment.Impl.Components
{
	public abstract class CatalogPackageComponentBase<TContract, TMetadata> : PartsCatalogBase<TContract, TMetadata>, IPackageComponent where TMetadata : IPartMetadata
	{
		[Import]
		protected IVsEnvironmentService _environmentService;

		protected readonly SafeExecutionContext _context;

		protected CatalogPackageComponentBase()
		{
			_context = SafeExecutionContext.Get(GetType());
		}

		public virtual void Initialize()
		{
			_environmentService.StartupComplete += OnStartupComplete;
			_environmentService.BeginShutdown += OnBeginShutdown;
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