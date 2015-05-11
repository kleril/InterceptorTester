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
	/// Provides visual studio MEF interactions
	/// </summary>
	public interface IMefComponentProvider
	{
		/// <summary>
		/// Gets a component and satisfies its imports
		/// </summary>
		/// <typeparam name="T">Component type</typeparam>
		/// <returns>Instance of a component</returns>
		/// <remarks>By default all components are created as singletons</remarks>
		T GetComponent<T>();

		/// <summary>
		/// Gets an array of components and satisfies their imports
		/// </summary>
		/// <typeparam name="T">Component type</typeparam>
		/// <returns>An array of component instances</returns>
		IEnumerable<T> GetComponents<T>();

		IEnumerable<Lazy<TExport, TMetadata>> GetComponents<TExport, TMetadata>();

		/// <summary>
		/// Satisfies MEF imports for an object
		/// </summary>
		/// <param name="part">Object to satisfy import for</param>
		void SatisfyImports(object part);

		/// <summary>
		/// Adds an exported value to the container
		/// </summary>
		void ComposeExportedValue<T>(T value);

		/// <summary>
		/// Adds an exported value to the container
		/// </summary>
		void ComposeExportedValue(object value, Type exportType);
	}
}