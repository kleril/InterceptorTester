//////////////////////////////////////////////////////////////////////////
// This file is a part of VisualStudio.Extensibility.Common NuGet package.
// You are strongly discouraged from fiddling with it.
// If you do, all hell will break loose and living will envy the dead.
//////////////////////////////////////////////////////////////////////////
using System;

namespace $rootnamespace$.Environment
{
	/// <summary>
	/// Provides functionality for acessing Visual Studio native (non-MEF) services
	/// </summary>
	public interface IVsServiceProvider
	{
		/// <summary>
		/// Gets a service by its type
		/// </summary>
		/// <param name="type">Service type</param>
		/// <returns>Service instance</returns>
		object GetService(Type type);

		/// <summary>
		/// Gets a service by its GUID
		/// </summary>
		/// <param name="guid">Service GUID</param>
		/// <returns>Service instance</returns>
		object GetService(Guid guid);

		/// <summary>
		/// Gets a service by its type
		/// </summary>
		/// <typeparam name="T">Service type</typeparam>
		/// <returns>Service instance</returns>
		T GetService<T>();

		TInterface GetService<TAccessor, TInterface>();
		TInterface GetGlobalService<TAccessor, TInterface>();

		/// <summary>
		/// Gets a service by its GUID
		/// </summary>
		/// <param name="guid">Service GUID</param>
		/// <typeparam name="T">Service type</typeparam>
		/// <returns>Service instance</returns>
		T GetService<T>(Guid guid);

		IServiceProvider ServiceProvider { get; }
	}
}