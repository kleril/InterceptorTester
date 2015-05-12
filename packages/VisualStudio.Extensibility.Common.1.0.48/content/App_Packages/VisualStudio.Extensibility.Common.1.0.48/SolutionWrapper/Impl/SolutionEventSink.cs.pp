//////////////////////////////////////////////////////////////////////////
// This file is a part of VisualStudio.Extensibility.Common NuGet package.
// You are strongly discouraged from fiddling with it.
// If you do, all hell will break loose and living will envy the dead.
//////////////////////////////////////////////////////////////////////////
using System;
using EnvDTE;
using Microsoft.VisualStudio;
using Microsoft.VisualStudio.Shell.Interop;

namespace $rootnamespace$.SolutionWrapper.Impl
{
	public class SolutionEventSink : IVsSolutionEvents, IVsSolutionLoadEvents
	{
	    #region SolutionOpened

	    public event Action SolutionOpened;

	    protected virtual void OnSolutionOpened()
	    {
	        var handler = SolutionOpened;
	        if (handler != null) handler();
	    }

	    #endregion

	    #region SolutionClosed

	    public event Action SolutionClosed;

	    protected virtual void OnSolutionClosed()
	    {
	        Action handler = SolutionClosed;
	        if (handler != null) handler();
	    }

	    #endregion


	    #region ProjectOpened

	    public event Action<object> ProjectOpened;

	    protected virtual void OnProjectOpened(object o)
	    {
	        var handler = ProjectOpened;
	        if (handler != null) handler(o);
	    }

	    #endregion

	    #region ProjectClosed

	    public event Action<object> ProjectClosed;

	    protected virtual void OnProjectClosed(object obj)
	    {
	        Action<object> handler = ProjectClosed;
	        if (handler != null) handler(obj);
	    }

	    #endregion


	    /// <summary>
		/// Fired before a solution open begins. Extenders can activate a solution load manager by setting <see cref="F:Microsoft.VisualStudio.Shell.Interop.__VSPROPID4.VSPROPID_ActiveSolutionLoadManager"/>.
		/// </summary>
		/// <returns>
		/// If the method succeeds, it returns <see cref="F:Microsoft.VisualStudio.VSConstants.S_OK"/>. If it fails, it returns an error code.
		/// </returns>
		/// <param name="pszSolutionFilename">The name of the solution file.</param>
		public int OnBeforeOpenSolution(string pszSolutionFilename)
		{
			return Microsoft.VisualStudio.VSConstants.S_OK;
		}

		/// <summary>
		/// Fired when background loading of projects is beginning again after the initial solution open operation has completed. 
		/// </summary>
		/// <returns>
		/// If the method succeeds, it returns <see cref="F:Microsoft.VisualStudio.VSConstants.S_OK"/>. If it fails, it returns an error code.
		/// </returns>
		public int OnBeforeBackgroundSolutionLoadBegins()
		{
			return Microsoft.VisualStudio.VSConstants.S_OK;
		}

		/// <summary>
		/// Fired before background loading a batch of projects. Normally a background batch loads a single pending project. This is a cancelable event.
		/// </summary>
		/// <returns>
		/// If the method succeeds, it returns <see cref="F:Microsoft.VisualStudio.VSConstants.S_OK"/>. If it fails, it returns an error code.
		/// </returns>
		/// <param name="pfShouldDelayLoadToNextIdle">[out] true if other background operations should complete before starting to load the project, otherwise false.</param>
		public int OnQueryBackgroundLoadProjectBatch(out bool pfShouldDelayLoadToNextIdle)
		{
			pfShouldDelayLoadToNextIdle = false;
			return Microsoft.VisualStudio.VSConstants.S_OK;
		}

		/// <summary>
		/// Fired when loading a batch of dependent projects as part of loading a solution in the background. 
		/// </summary>
		/// <returns>
		/// If the method succeeds, it returns <see cref="F:Microsoft.VisualStudio.VSConstants.S_OK"/>. If it fails, it returns an error code.
		/// </returns>
		/// <param name="fIsBackgroundIdleBatch">true if the batch is loaded in the background, otherwise false.</param>
		public int OnBeforeLoadProjectBatch(bool fIsBackgroundIdleBatch)
		{
			return Microsoft.VisualStudio.VSConstants.S_OK;
		}

		/// <summary>
		/// Fired when the loading of a batch of dependent projects is complete.
		/// </summary>
		/// <returns>
		/// If the method succeeds, it returns <see cref="F:Microsoft.VisualStudio.VSConstants.S_OK"/>. If it fails, it returns an error code.
		/// </returns>
		/// <param name="fIsBackgroundIdleBatch">true if the batch is loaded in the background, otherwise false.</param>
		public int OnAfterLoadProjectBatch(bool fIsBackgroundIdleBatch)
		{
			return Microsoft.VisualStudio.VSConstants.S_OK;
		}

		/// <summary>
		/// Fired when the solution load process is fully complete, including all background loading of projects. 
		/// </summary>
		/// <returns>
		/// If the method succeeds, it returns <see cref="F:Microsoft.VisualStudio.VSConstants.S_OK"/>. If it fails, it returns an error code.
		/// </returns>
		public int OnAfterBackgroundSolutionLoadComplete()
		{
			OnSolutionOpened();
			return Microsoft.VisualStudio.VSConstants.S_OK;
		}

		/// <summary>
		/// Notifies listening clients that the project has been opened.
		/// </summary>
		/// <returns>
		/// If the method succeeds, it returns <see cref="F:Microsoft.VisualStudio.VSConstants.S_OK"/>. If it fails, it returns an error code.
		/// </returns>
		/// <param name="pHierarchy">[in] Pointer to the <see cref="T:Microsoft.VisualStudio.Shell.Interop.IVsHierarchy"/> interface of the project being loaded.</param><param name="fAdded">[in] true if the project is added to the solution after the solution is opened. false if the project is added to the solution while the solution is being opened.</param>
		public int OnAfterOpenProject(IVsHierarchy pHierarchy, int fAdded)
		{
            OnProjectOpened(GetDteObject(pHierarchy));
            return VSConstants.S_OK;
		}

		/// <summary>
		/// Queries listening clients as to whether the project can be closed.
		/// </summary>
		/// <returns>
		/// If the method succeeds, it returns <see cref="F:Microsoft.VisualStudio.VSConstants.S_OK"/>. If it fails, it returns an error code.
		/// </returns>
		/// <param name="pHierarchy">[in] Pointer to the <see cref="T:Microsoft.VisualStudio.Shell.Interop.IVsHierarchy"/> interface of the project to be closed.</param><param name="fRemoving">[in] true if the project is being removed from the solution before the solution is closed. false if the project is being removed from the solution while the solution is being closed.</param><param name="pfCancel">[out] true if the client vetoed the closing of the project. false if the client approved the closing of the project.</param>
		public int OnQueryCloseProject(IVsHierarchy pHierarchy, int fRemoving, ref int pfCancel)
		{
			return Microsoft.VisualStudio.VSConstants.S_OK;
		}

		/// <summary>
		/// Notifies listening clients that the project is about to be closed.
		/// </summary>
		/// <returns>
		/// If the method succeeds, it returns <see cref="F:Microsoft.VisualStudio.VSConstants.S_OK"/>. If it fails, it returns an error code.
		/// </returns>
		/// <param name="pHierarchy">[in] Pointer to the <see cref="T:Microsoft.VisualStudio.Shell.Interop.IVsHierarchy"/> interface of the project being closed.</param><param name="fRemoved">[in] true if the project was removed from the solution before the solution was closed. false if the project was removed from the solution while the solution was being closed.</param>
		public int OnBeforeCloseProject(IVsHierarchy pHierarchy, int fRemoved)
		{
            OnProjectClosed(GetDteObject(pHierarchy));
			return Microsoft.VisualStudio.VSConstants.S_OK;
		}

		/// <summary>
		/// Notifies listening clients that the project has been loaded.
		/// </summary>
		/// <returns>
		/// If the method succeeds, it returns <see cref="F:Microsoft.VisualStudio.VSConstants.S_OK"/>. If it fails, it returns an error code.
		/// </returns>
		/// <param name="pStubHierarchy">[in] Pointer to the <see cref="T:Microsoft.VisualStudio.Shell.Interop.IVsHierarchy"/> interface of the placeholder hierarchy for the unloaded project.</param><param name="pRealHierarchy">[in] Pointer to the <see cref="T:Microsoft.VisualStudio.Shell.Interop.IVsHierarchy"/> interface of the project that was loaded.</param>
		public int OnAfterLoadProject(IVsHierarchy pStubHierarchy, IVsHierarchy pRealHierarchy)
		{
            return Microsoft.VisualStudio.VSConstants.S_OK;
		}

		/// <summary>
		/// Queries listening clients as to whether the project can be unloaded.
		/// </summary>
		/// <returns>
		/// If the method succeeds, it returns <see cref="F:Microsoft.VisualStudio.VSConstants.S_OK"/>. If it fails, it returns an error code.
		/// </returns>
		/// <param name="pRealHierarchy">[in] Pointer to the <see cref="T:Microsoft.VisualStudio.Shell.Interop.IVsHierarchy"/> interface of the project to be unloaded.</param><param name="pfCancel">[out] true if the client vetoed unloading the project. false if the client approved unloading the project.</param>
		public int OnQueryUnloadProject(IVsHierarchy pRealHierarchy, ref int pfCancel)
		{
			return Microsoft.VisualStudio.VSConstants.S_OK;
		}

		/// <summary>
		/// Notifies listening clients that the project is about to be unloaded.
		/// </summary>
		/// <returns>
		/// If the method succeeds, it returns <see cref="F:Microsoft.VisualStudio.VSConstants.S_OK"/>. If it fails, it returns an error code.
		/// </returns>
		/// <param name="pRealHierarchy">[in] Pointer to the <see cref="T:Microsoft.VisualStudio.Shell.Interop.IVsHierarchy"/> interface of the project that will be unloaded.</param><param name="pStubHierarchy">[in] Pointer to the <see cref="T:Microsoft.VisualStudio.Shell.Interop.IVsHierarchy"/> interface of the placeholder hierarchy for the project being unloaded.</param>
		public int OnBeforeUnloadProject(IVsHierarchy pRealHierarchy, IVsHierarchy pStubHierarchy)
		{
			return Microsoft.VisualStudio.VSConstants.S_OK;
		}

		/// <summary>
		/// Notifies listening clients that the solution has been opened.
		/// </summary>
		/// <returns>
		/// If the method succeeds, it returns <see cref="F:Microsoft.VisualStudio.VSConstants.S_OK"/>. If it fails, it returns an error code.
		/// </returns>
		/// <param name="pUnkReserved">[in] Reserved for future use.</param><param name="fNewSolution">[in] true if the solution is being created. false if the solution was created previously or is being loaded.</param>
		public int OnAfterOpenSolution(object pUnkReserved, int fNewSolution)
		{
			return Microsoft.VisualStudio.VSConstants.S_OK;
		}

		/// <summary>
		/// Queries listening clients as to whether the solution can be closed.
		/// </summary>
		/// <returns>
		/// If the method succeeds, it returns <see cref="F:Microsoft.VisualStudio.VSConstants.S_OK"/>. If it fails, it returns an error code.
		/// </returns>
		/// <param name="pUnkReserved">[in] Reserved for future use.</param><param name="pfCancel">[out] true if the client vetoed closing the solution. false if the client approved closing the solution.</param>
		public int OnQueryCloseSolution(object pUnkReserved, ref int pfCancel)
		{
			return Microsoft.VisualStudio.VSConstants.S_OK;
		}

		/// <summary>
		/// Notifies listening clients that the solution is about to be closed.
		/// </summary>
		/// <returns>
		/// If the method succeeds, it returns <see cref="F:Microsoft.VisualStudio.VSConstants.S_OK"/>. If it fails, it returns an error code.
		/// </returns>
		/// <param name="pUnkReserved">[in] Reserved for future use.</param>
		public int OnBeforeCloseSolution(object pUnkReserved)
		{
			return Microsoft.VisualStudio.VSConstants.S_OK;
		}

		/// <summary>
		/// Notifies listening clients that a solution has been closed.
		/// </summary>
		/// <returns>
		/// If the method succeeds, it returns <see cref="F:Microsoft.VisualStudio.VSConstants.S_OK"/>. If it fails, it returns an error code.
		/// </returns>
		/// <param name="pUnkReserved">[in] Reserved for future use.</param>
		public int OnAfterCloseSolution(object pUnkReserved)
		{
            OnSolutionClosed();
			return Microsoft.VisualStudio.VSConstants.S_OK;
		}

	    private object GetDteObject(IVsHierarchy hierarchy)
	    {
            object dteItem;
            hierarchy.GetProperty((uint)VSConstants.VSITEMID.Root, (int)__VSHPROPID.VSHPROPID_ExtObject, out dteItem);

	        return dteItem;
	    }
	}
}