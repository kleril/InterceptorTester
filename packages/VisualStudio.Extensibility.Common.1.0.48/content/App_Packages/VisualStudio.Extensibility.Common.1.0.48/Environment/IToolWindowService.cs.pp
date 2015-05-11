//////////////////////////////////////////////////////////////////////////
// This file is a part of VisualStudio.Extensibility.Common NuGet package.
// You are strongly discouraged from fiddling with it.
// If you do, all hell will break loose and living will envy the dead.
//////////////////////////////////////////////////////////////////////////
namespace $rootnamespace$.Environment
{
	/// <summary>
	/// Tool window service
	/// </summary>
	public interface IToolWindowService
	{
		/// <summary>
		/// Show tool window of specified type
		/// </summary>
		/// <typeparam name="T">Tool window type</typeparam>
		void ShowWindow<T>() where T : ToolWindowBase;

		/// <summary>
		/// Show tool window with specified name
		/// </summary>
		/// <param name="name">Tool window name</param>
		void ShowWindow(string name);

		T GetWindow<T>() where T : ToolWindowBase;
		ToolWindowBase GetWindow(string name);
	}
}