//////////////////////////////////////////////////////////////////////////
// This file is a part of VisualStudio.Extensibility.Common NuGet package.
// You are strongly discouraged from fiddling with it.
// If you do, all hell will break loose and living will envy the dead.
//////////////////////////////////////////////////////////////////////////
namespace $rootnamespace$.Environment
{
	/// <summary>
	/// Service that lets you deal with Output window
	/// </summary>
	public interface IOutputWindowService
	{
		/// <summary>
		/// Gets a pane by type
		/// </summary>
		/// <typeparam name="T">Pane type</typeparam>
		/// <returns>Pane instance</returns>
		T GetPane<T>() where T : OutputPaneBase;

		/// <summary>
		/// Gets a pane by name
		/// </summary>
		/// <param name="name">Pane name</param>
		/// <returns>Pane instance</returns>
		OutputPaneBase GetPane(string name);

		/// <summary>
		/// Brings the output window to front
		/// </summary>
		void ActivateOutputWindow();
	}
}