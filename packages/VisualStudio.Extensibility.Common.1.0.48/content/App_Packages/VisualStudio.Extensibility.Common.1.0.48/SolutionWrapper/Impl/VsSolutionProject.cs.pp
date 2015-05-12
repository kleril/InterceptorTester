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
using EnvDTE80;
using NotLimited.Framework.Common.Helpers;
using VSLangProj;

namespace $rootnamespace$.SolutionWrapper.Impl
{
	internal class VsSolutionProject : VsItemBase, ISolutionProject
	{
		protected readonly Project _project;

		internal Project DteProject { get { return _project; } }

		public VsSolutionProject(DTE dte, ISolutionItem parent, ISolution solution, Project project)
			: base(dte, parent, solution)
		{
			_project = project;
		}

		public override ISolutionItem Parent
		{
			get
			{
				if (_parent == null)
				{
					try
					{
						if (_project.ParentProjectItem != null && _project.ParentProjectItem.ContainingProject != null)
							return _solution.WrapDteObject(_project.ParentProjectItem.ContainingProject);
					}
					catch
					{
						return null;
					}
				}

				return base.Parent;
			}
		}

		public override string FileName
		{
			get
			{
				string result = string.Empty;
				try
				{
					result = _project.FileName;
				}
				catch 
				{
				}

				return result;
			}
		}

		public override string Directory
		{
			get { return string.IsNullOrEmpty(FileName) ? null : Path.GetDirectoryName(_project.FileName); }
		}

		public override string Name
		{
			get { return _project.Name; }
		}

		public override SolutionItemType Type
		{
			get { return _project.GetProjectType(); }
		}

		public override ISolutionItem AddFile(string path)
		{
			if (string.IsNullOrEmpty(path)) throw new ArgumentNullException("path");

			if (!File.Exists(path))
				throw new FileNotFoundException("The file you are trying to add doesn't exist", path);

			if (_project.ProjectItems == null)
				throw new InvalidOperationException("ProjectItems collection is null!");

			ProjectItem item;
			try
			{
				item = _project.ProjectItems.AddFromFile(path);
			}
			catch (COMException e)
			{
				throw new SolutionException(e.Message, e);
			}

			return _solution.WrapDteObject(item);
		}

		public override ISolutionItem CreateFolder(string name)
		{
			if (string.IsNullOrEmpty(name)) throw new ArgumentNullException("name");

			ProjectItem item;
			try
			{
				item = _project.ProjectItems.AddFolder(name);
				_project.Save();
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

                _children = (_project.ProjectItems == null)
                    ? Enumerable.Empty<ISolutionItem>()
                    : _project.ProjectItems.Cast<ProjectItem>().Select(item => item.ToSolutionItem(_dte, this, _solution));

			    return _children;
			}
		}

		#region Implementation of ISolutionProject

		public string AssemblyName
		{
			get
			{
				return _project.GetProperty("AssemblyName");
			}
		}

		public string OutputPath
		{
			get
			{
				if (_project.ConfigurationManager == null || _project.ConfigurationManager.ActiveConfiguration == null)
					return null;
				return _project.ConfigurationManager.ActiveConfiguration.GetProperty("OutputPath");
			}
		}

	    public string RootNamespace
	    {
	        get { return _project.GetProperty("RootNamespace"); }
	    }

	    public void Save()
		{
			_project.Save();
		}

	    public bool AddReference(string reference)
	    {
            var vsProject = _project.Object as VSProject;
            if (vsProject == null)
            {
                throw new InvalidOperationException("Can't cast the project!");
            }

            foreach (Reference r in vsProject.References)
            {
                if (r.Path.EqualsIgnoreCase(reference))
                {
                    return false;
                }
            }

            try
            {
                vsProject.References.Add(reference);
            }
            catch
            {
                return false;
            }

            return true;
	    }

	    #endregion
	}
}