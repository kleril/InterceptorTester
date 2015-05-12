//////////////////////////////////////////////////////////////////////////
// This file is a part of VisualStudio.Extensibility.Common NuGet package.
// You are strongly discouraged from fiddling with it.
// If you do, all hell will break loose and living will envy the dead.
//////////////////////////////////////////////////////////////////////////
using System;

namespace $rootnamespace$.Environment
{
	/// <summary>
	/// A base interface for package components
	/// </summary>
	public interface IPackageComponent : IDisposable
	{
		/// <summary>
		/// Called upon package initialization
		/// </summary>
		void Initialize();
	}
}