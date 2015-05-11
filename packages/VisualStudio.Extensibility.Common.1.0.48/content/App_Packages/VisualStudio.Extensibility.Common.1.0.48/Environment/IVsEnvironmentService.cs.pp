//////////////////////////////////////////////////////////////////////////
// This file is a part of VisualStudio.Extensibility.Common NuGet package.
// You are strongly discouraged from fiddling with it.
// If you do, all hell will break loose and living will envy the dead.
//////////////////////////////////////////////////////////////////////////
using System;
using System.Windows;

namespace $rootnamespace$.Environment
{
	/// <summary>
	/// Visual Studio environment interface
	/// </summary>
	public interface IVsEnvironmentService
	{
		/// <summary>
		/// Fired when Visual Studio startup was completed
		/// </summary>
		event Action StartupComplete;

		/// <summary>
		/// Fired when Visual studio is about to be closed
		/// </summary>
		event Action BeginShutdown;

		/// <summary>
		/// Opens a new tab with the specified file in it and sets the caret to the specified position
		/// </summary>
		/// <param name="path">Path to the document</param>
		/// <param name="line">Start line</param>
		/// <param name="col">Start column</param>
		void OpenDocument(string path, int line = 0, int col = 0);

	    /// <summary>
	    /// Opens a new tab with the specified file in it and sets the caret to the specified position
	    /// </summary>
	    /// <param name="path">Path to the document</param>
	    /// <param name="offset"></param>
	    void OpenDocumentAbsolute(string path, int offset = 0);

		/// <summary>
		/// Returns main window rectangle
		/// </summary>
		/// <returns>Main window rectangle</returns>
		Rect GetMainWindowRect();

		void Restart();

		void SetOwnerToMainWindow(Window window);

		IDocument ActiveDocument { get; }

		void SaveAllDocuments();

		event Action<IDocument> DocumentOpened;

		event Action<IDocument> DocumentActivated;
	}
}