//////////////////////////////////////////////////////////////////////////
// This file is a part of VisualStudio.Extensibility.Common NuGet package.
// You are strongly discouraged from fiddling with it.
// If you do, all hell will break loose and living will envy the dead.
//////////////////////////////////////////////////////////////////////////
using System;
using System.Collections.Generic;

namespace $rootnamespace$.Environment
{
	/// <summary>
	/// Package component catalog. Contains info about package components.
	/// </summary>
	public interface IPackageComponentCatalog
	{
		/// <summary>
		/// Gets a specific component by its type
		/// </summary>
		/// <typeparam name="T">Component type</typeparam>
		/// <returns>Component instance</returns>
		/// <exception cref="InvalidOperationException">Thrown when there is no such component in the catalog</exception>
		T GetComponent<T>() where T : IPackageComponent;

		/// <summary>
		/// Get a component by its name
		/// </summary>
		/// <param name="name">Component name</param>
		/// <returns>Component</returns>
		/// <exception cref="InvalidOperationException">Thrown when there is no such component in the catalog</exception>
		IPackageComponent GetComponent(string name);

		/// <summary>
		/// Lists all the components in the catalog
		/// </summary>
		IEnumerable<IPackageComponent> Components { get; } 
	}
}