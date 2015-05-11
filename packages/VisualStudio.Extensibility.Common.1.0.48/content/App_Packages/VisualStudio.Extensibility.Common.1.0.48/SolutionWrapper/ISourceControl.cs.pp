//////////////////////////////////////////////////////////////////////////
// This file is a part of VisualStudio.Extensibility.Common NuGet package.
// You are strongly discouraged from fiddling with it.
// If you do, all hell will break loose and living will envy the dead.
//////////////////////////////////////////////////////////////////////////
using System;
using System.Collections.Generic;

namespace $rootnamespace$.SolutionWrapper
{
	public interface ISourceControl
	{
		void PendAdd(string path);
		void PendDelete(string path);
		void PendEdit(string path);
		void Undo(string path);
		bool IsUnderSourceControl(string path);
		void ProcessChangedFile(string path);
		List<PendingChange> GetPendingChanges(string path);

		event EventHandler<PendingChangeEventArgs> PendingChangeUndone;
		event EventHandler CheckedIn;
	}
}