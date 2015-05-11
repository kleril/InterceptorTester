//////////////////////////////////////////////////////////////////////////
// This file is a part of VisualStudio.Extensibility.Common NuGet package.
// You are strongly discouraged from fiddling with it.
// If you do, all hell will break loose and living will envy the dead.
//////////////////////////////////////////////////////////////////////////
namespace $rootnamespace$.SolutionWrapper
{
	/// <summary>
	/// Project
	/// </summary>
	public interface ISolutionProject : ISolutionItem
	{
		/// <summary>
		/// Resulting assembly name without the extension
		/// </summary>
		string AssemblyName { get; }

		/// <summary>
		/// Output path relative to project directory
		/// </summary>
		string OutputPath { get; }

        /// <summary>
        /// Project root namespace
        /// </summary>
        string RootNamespace { get; }

		void Save();

	    bool AddReference(string reference);
	}
}