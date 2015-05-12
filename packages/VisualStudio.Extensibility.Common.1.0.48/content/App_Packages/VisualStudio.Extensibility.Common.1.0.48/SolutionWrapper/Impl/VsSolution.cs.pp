//////////////////////////////////////////////////////////////////////////
// This file is a part of VisualStudio.Extensibility.Common NuGet package.
// You are strongly discouraged from fiddling with it.
// If you do, all hell will break loose and living will envy the dead.
//////////////////////////////////////////////////////////////////////////
using System;
using System.Collections.Generic;
using System.ComponentModel.Composition;
using System.IO;
using System.Linq;
using System.Runtime.InteropServices;
using EnvDTE;
using EnvDTE80;
using Microsoft.TeamFoundation.Client;
using Microsoft.TeamFoundation.VersionControl.Client;
using Microsoft.VisualStudio.Shell.Interop;
using NotLimited.Framework.Common.Helpers;
using $rootnamespace$.Environment;

namespace $rootnamespace$.SolutionWrapper.Impl
{
	[Export(typeof(ISolution))]
	internal class VsSolution : VsItemBase, ISolution
	{
		private static readonly SafeExecutionContext _context = SafeExecutionContext.Get<VsSolution>();

		private readonly IVsServiceProvider _serviceProvider;
		//private readonly SolutionEvents _solutionEvents;
		private readonly ProjectItemsEvents _itemsEvents;
		private readonly SolutionEventSink _eventSink;
		
		[ImportingConstructor]
		public VsSolution(IVsServiceProvider serviceProvider)
		{
			_serviceProvider = serviceProvider;
			_dte = _serviceProvider.GetService<DTE>();
			//_solutionEvents = _dte.Events.SolutionEvents;
			//_solutionEvents.Opened += OnOpened;
			//_solutionEvents.Closed += OnClosed;
			//_solutionEvents.ProjectOpened += project => OnProjectOpened((ISolutionProject)WrapDteObject(project));
			//_solutionEvents.ProjectClosed += project => OnProjectClosed((ISolutionProject)WrapDteObject(project));

			_eventSink = new SolutionEventSink();
			_eventSink.SolutionOpened += OnOpened;
            _eventSink.SolutionClosed += OnClosed;
		    _eventSink.ProjectOpened += o => OnProjectOpened((ISolutionProject)TryWrapDteObject(o));
		    _eventSink.ProjectClosed += o => OnProjectClosed((ISolutionProject)TryWrapDteObject(o));

			var solutionService = _serviceProvider.GetService<SVsSolution, IVsSolution>();
			uint cookie;
			solutionService.AdviseSolutionEvents(_eventSink, out cookie);

			var events2 = _dte.Events as Events2;
			if (events2 == null)
				throw new InvalidOperationException("Cant get Events2 interface!");
			
			_itemsEvents = events2.ProjectItemsEvents;
			_itemsEvents.ItemAdded += item => OnItemAdded(WrapDteObject(item));
			_itemsEvents.ItemRemoved += item => OnItemRemoved(WrapDteObject(item));
		}

		public override string FileName
		{
			get { return _dte.Solution == null ? null : _dte.Solution.FileName; }
		}

		public override string Directory
		{
			get { return string.IsNullOrEmpty(FileName) ? null : Path.GetDirectoryName(FileName); }
		}

		public override string Name
		{
			get { return _dte.Solution == null ? null : Path.GetFileNameWithoutExtension(_dte.Solution.FullName); }
		}

		public override SolutionItemType Type
		{
			get { return SolutionItemType.Solution; }
		}

		public override ISolutionItem AddFile(string path)
		{
			if (string.IsNullOrEmpty(path)) throw new ArgumentNullException("path");

			return WrapDteObject(_dte.Solution.AddFromFile(path));
		}

		public override ISolutionItem CreateFolder(string name)
		{
			if (string.IsNullOrEmpty(name)) throw new ArgumentNullException("name");

			Project project;
			try
			{
				project = ((Solution2)_dte.Solution).AddSolutionFolder(name);
			}
			catch (COMException e)
			{
				throw new SolutionException(e.Message, e);
			}

			var folder = project.Object as SolutionFolder;
			if (folder == null)
				throw new InvalidOperationException("Can't get SolutionFolder interface from newly created solution folder!");

			return new VsSolutionFolder(_dte, this, this, project, folder);
		}

		public bool IsOpen
		{
			get { return _dte.Solution != null && _dte.Solution.IsOpen; }
		}

		public void CheckOut(string path)
		{
			if (string.IsNullOrEmpty(path)) throw new ArgumentNullException("path");

			if (_dte.SourceControl.IsItemUnderSCC(path) && !_dte.SourceControl.IsItemCheckedOut(path))
				_dte.SourceControl.CheckOutItem(path);
		}

        

		public ISolutionItem WrapDteObject(object obj)
		{
			if (obj == null) throw new ArgumentNullException("obj");

			var projectItem = obj as ProjectItem;
			if (projectItem != null)
				return projectItem.ToSolutionItem(_dte, null, this);

			var project = obj as Project;
			if (project != null)
			{
				if (project.GetProjectType() == SolutionItemType.SolutionFolder)
					return new VsSolutionFolder(_dte, null, this, project, (SolutionFolder)project.Object);

				return new VsSolutionProject(_dte, null, this, project);
			}

			if (obj is EnvDTE.Solution)
				return this;

			throw new InvalidOperationException("Invalid object type: " + obj.GetType().Name);
		}

	    public ISolutionItem TryWrapDteObject(object obj)
	    {
	        if (obj == null)
	            return null;
	        return WrapDteObject(obj);
	    }

	    public ISourceControl SourceControl
		{
			get
			{
				return _context.Logged("SourceControl.get()",
									   logger =>
									   {
										   var collections = RegisteredTfsConnections.GetProjectCollections();
										   if (collections == null || collections.Length == 0)
										   {
											   logger.Warning("Project collections are empty!");
											   return null;
										   }
										   var collection = TfsTeamProjectCollectionFactory.GetTeamProjectCollection(collections[0]);
										   if (collection == null)
										   {
											   logger.Warning("Can't get team project collection!");
											   return null;
										   }
										   var svc = collection.GetService<VersionControlServer>();
										   if (svc == null)
										   {
											   logger.Warning("Can't get VersionControlServer!");
											   return null;
										   }
										   var workspace = svc.TryGetWorkspace(Directory);
										   if (workspace == null)
										   {
											   logger.Warning("Can't get workspace!");
											   return null;
										   }

										   return new SourceControl(workspace);
									   });
			}
		}

		public event Action Opened;
		public event Action Closed;
		public event Action<ISolutionItem> ItemAdded;
		public event Action<ISolutionItem> ItemRemoved;
		public event Action<ISolutionProject> ProjectOpened;
		public event Action<ISolutionProject> ProjectClosed;

		public ISolutionItem SolutionItems
	    {
	        get { return FindItem(x => x.Name == "Solution Items" && x.Type == SolutionItemType.SolutionFolder); }
	    }

		protected virtual void OnProjectClosed(ISolutionProject obj)
		{
			var handler = ProjectClosed;
			if (handler != null) handler(obj);
		}

		protected virtual void OnProjectOpened(ISolutionProject obj)
		{
			var handler = ProjectOpened;
			if (handler != null) handler(obj);
		}

		protected virtual void OnItemRemoved(ISolutionItem obj)
		{
			var handler = ItemRemoved;
			if (handler != null) handler(obj);
		}

		private void OnOpened()
		{
			var handler = Opened;
			if (handler != null) handler();
		}

		private void OnItemAdded(ISolutionItem obj)
		{
			var handler = ItemAdded;
			if (handler != null) handler(obj);
		}

		private void OnClosed()
		{
			var handler = Closed;
			if (handler != null) handler();
		}

		#region Implementation of ISolutionItemTree

		public override IEnumerable<ISolutionItem> Children
		{
			get
			{
				if (_dte.Solution == null)
					throw new InvalidOperationException("Solution is not opened!");

				foreach (Project project in _dte.Solution.Projects)
				{
					var type = project.GetProjectType();
					if (type == SolutionItemType.SolutionFolder)
						yield return new VsSolutionFolder(_dte, this, this, project, (SolutionFolder)project.Object);
					else
						yield return new VsSolutionProject(_dte, this, this, project);
				}
			}
		}

		#endregion
	}
}