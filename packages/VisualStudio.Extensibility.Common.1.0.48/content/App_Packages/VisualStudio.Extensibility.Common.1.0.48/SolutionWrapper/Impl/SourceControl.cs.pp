//////////////////////////////////////////////////////////////////////////
// This file is a part of VisualStudio.Extensibility.Common NuGet package.
// You are strongly discouraged from fiddling with it.
// If you do, all hell will break loose and living will envy the dead.
//////////////////////////////////////////////////////////////////////////
using System;
using System.Collections.Generic;
using System.Linq;
using Microsoft.TeamFoundation.VersionControl.Client;

namespace $rootnamespace$.SolutionWrapper.Impl
{
	public class SourceControl : ISourceControl
	{
		private static readonly Dictionary<ChangeType, PendingChangeType> _changeTypeMap = new Dictionary<ChangeType, PendingChangeType>
			{
				{ChangeType.Add, PendingChangeType.Add},
				{ChangeType.Delete, PendingChangeType.Delete}
			};

		private readonly Workspace _workspace;

		public SourceControl(Workspace workspace)
		{
			if (workspace == null) throw new ArgumentNullException("workspace");

			_workspace = workspace;
			_workspace.VersionControlServer.UndonePendingChange += (sender, args) => OnPendingChangeUndone(new PendingChangeEventArgs {LocalFile = args.PendingChange.LocalItem});
			_workspace.VersionControlServer.CommitCheckin += (sender, args) => OnCheckedIn();
		}

		public void PendAdd(string path)
		{
			_workspace.PendAdd(path);
		}

		public void PendDelete(string path)
		{
			_workspace.PendDelete(path);
		}

		public void PendEdit(string path)
		{
			_workspace.PendEdit(path);
		}

		public void Undo(string path)
		{
			_workspace.Undo(path);
		}

		public bool IsUnderSourceControl(string path)
		{
			return _workspace.VersionControlServer.ServerItemExists(path, ItemType.Any);
		}

		public void ProcessChangedFile(string path)
		{
			if (!IsUnderSourceControl(path))
			{
				_workspace.PendAdd(path);
				return;
			}

			var changes = _workspace.GetPendingChanges(path);
			
			var addOrEditChange = changes.FirstOrDefault(x => (x.ChangeType == ChangeType.Add || x.ChangeType == ChangeType.Edit) && !x.Undone);
			if (addOrEditChange != null)
				return;

			var deleteChange = changes.FirstOrDefault(x => x.ChangeType == ChangeType.Delete && !x.Undone);
			if (deleteChange != null)
				_workspace.Undo(new[] {deleteChange});

			_workspace.PendEdit(path);
		}

		public List<PendingChange> GetPendingChanges(string path)
		{
			return _workspace.GetPendingChanges(path)
			                 .Select(change => new PendingChange
				                 {
					                 Path = path,
					                 Type = ToPendingChangeType(change.ChangeType)
				                 })
			                 .ToList();
		}

		public event EventHandler<PendingChangeEventArgs> PendingChangeUndone;

		protected virtual void OnPendingChangeUndone(PendingChangeEventArgs e)
		{
			var handler = PendingChangeUndone;
			if (handler != null) handler(this, e);
		}

		public event EventHandler CheckedIn;

		protected virtual void OnCheckedIn()
		{
			var handler = CheckedIn;
			if (handler != null) handler(this, EventArgs.Empty);
		}

		private static PendingChangeType ToPendingChangeType(ChangeType type)
		{
			var result = PendingChangeType.Unknown;

			foreach (var pair in _changeTypeMap)
			{
				if (type.HasFlag(pair.Key))
					result |= pair.Value;
			}

			return result;
		}
	}
}