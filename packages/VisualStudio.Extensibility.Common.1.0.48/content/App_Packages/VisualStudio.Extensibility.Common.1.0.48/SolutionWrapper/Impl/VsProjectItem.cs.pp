//////////////////////////////////////////////////////////////////////////
// This file is a part of VisualStudio.Extensibility.Common NuGet package.
// You are strongly discouraged from fiddling with it.
// If you do, all hell will break loose and living will envy the dead.
//////////////////////////////////////////////////////////////////////////
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Runtime.InteropServices;
using EnvDTE;

namespace $rootnamespace$.SolutionWrapper.Impl
{
	internal class VsProjectItem : VsItemBase
	{
		protected ProjectItem _item;

		internal ProjectItem DteItem { get { return _item; } }

		public VsProjectItem(DTE dte, ISolutionItem parent, ISolution solution, ProjectItem item)
			: base(dte, parent, solution)
		{
			_item = item;
		}

		public override ISolutionItem Parent
		{
			get
			{
				if (_parent == null)
				{
					if (_item.Collection == null)
						return null;
					if (_item.Collection.Parent == null)
						return null;

					return _solution.WrapDteObject(_item.Collection.Parent);
				}

				return base.Parent;
			}
		}

		public override string FileName
		{
			get
			{
				if (_item.FileCount == 0)
					return null;

				string fileName = _item.FileNames[1];
				if (!string.IsNullOrEmpty(fileName))
					return fileName;

				return null;
			}
		}

		public override string Directory
		{
			get { return string.IsNullOrEmpty(FileName) ? null : Path.GetDirectoryName(FileName); }
		}

		public override string Name
		{
			get { return _item.Name; }
		}

		public override SolutionItemType Type
		{
			get { return _item.GetItemType(); }
		}

		public override ISolutionItem AddFile(string path)
		{
			if (string.IsNullOrEmpty(path)) throw new ArgumentNullException("path");

			if (!File.Exists(path))
				throw new FileNotFoundException("The file you are trying to add doesn't exist:", path);

			if (_item.ProjectItems == null && (_item.SubProject == null || _item.SubProject.ProjectItems == null))
				throw new InvalidOperationException("Items collection is empty!");

			ProjectItem item;
			try
			{
				item = (_item.ProjectItems ?? _item.SubProject.ProjectItems).AddFromFile(path);
			}
			catch (COMException e)
			{
				throw new SolutionException(e.Message, e);
			}

			return _solution.WrapDteObject(item);
		}

		public override ISolutionItem CreateFolder(string name)
		{
			if (Type != SolutionItemType.Folder)
				throw new InvalidOperationException("Can't create a subfolder when parent item is not a folder!");

			ProjectItem item;
			try
			{
				item = _item.ProjectItems.AddFolder(name);
				SaveParentProject();
			}
			catch (COMException e)
			{
				throw new SolutionException(e.Message, e);
			}
			
			return new VsProjectItem(_dte, this, _solution, item);
		}

	    private IEnumerable<ISolutionItem> _children = null;
		public override IEnumerable<ISolutionItem> Children
		{
			get
			{
			    if (_children != null)
			        return _children;

                _children = _item.ProjectItems == null ? 
					Enumerable.Empty<ISolutionItem>() :
					_item.ProjectItems.Cast<ProjectItem>().Select(x => x.ToSolutionItem(_dte, this, _solution));
				
				return _children;
			}
		}
	}
}