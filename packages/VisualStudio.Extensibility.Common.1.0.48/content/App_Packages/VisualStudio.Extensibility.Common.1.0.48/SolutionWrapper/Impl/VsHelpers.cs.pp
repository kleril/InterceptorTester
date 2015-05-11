//////////////////////////////////////////////////////////////////////////
// This file is a part of VisualStudio.Extensibility.Common NuGet package.
// You are strongly discouraged from fiddling with it.
// If you do, all hell will break loose and living will envy the dead.
//////////////////////////////////////////////////////////////////////////
using System;
using System.Linq;
using EnvDTE;
using EnvDTE80;

namespace $rootnamespace$.SolutionWrapper.Impl
{
	internal static class VsHelpers
	{
		private static readonly Guid _miscGuid = Guid.Parse("{66A2671D-8FB5-11D2-AA7E-00C04F688DDE}");
		private static readonly Guid _solutionFolderGuid = Guid.Parse("{66A26720-8FB5-11D2-AA7E-00C04F688DDE}");
		private static readonly Guid _innerProjectGuid = Guid.Parse("{66A26722-8FB5-11D2-AA7E-00C04F688DDE}");
		private static readonly Guid _physicalFile = new Guid("{6BB5F8EE-4483-11D3-8BCF-00C04F8EC28C}");
		private static readonly Guid _physicalFolder = new Guid("{6BB5F8EF-4483-11D3-8BCF-00C04F8EC28C}");
		private static readonly Guid _virtualFolder = new Guid("{6BB5F8F0-4483-11D3-8BCF-00C04F8EC28C}");
		private static readonly Guid _subProject = new Guid("{EA6618E8-6E24-4528-94BE-6889FE16485C}");

		public static ISolutionItem ToSolutionItem(this ProjectItem item, DTE dte, ISolutionItem parent, ISolution solution)
		{
			var type = item.GetItemType();
			if (type == SolutionItemType.SolutionFolder)
				return new VsSolutionFolder(dte, parent, solution, item.SubProject, (SolutionFolder)item.SubProject.Object);

			// If somehow this item has a subproject, but it's not a solution folder, we fall back to project
			if (item.SubProject != null)
				return new VsSolutionProject(dte, parent, solution, item.SubProject);

			return new VsProjectItem(dte, parent, solution, item);
		}

		public static SolutionItemType GetItemType(this ProjectItem item)
		{
			var guid = Guid.Parse(item.Kind);

			if (guid == _physicalFolder)
				return SolutionItemType.Folder;
			if (guid == _physicalFile)
				return SolutionItemType.Item;
			if (guid == _virtualFolder || guid == _subProject)
				return SolutionItemType.VirtualFolder;
			if (guid == _innerProjectGuid)
			{
				// This shit is crazy.
				if (item.SubProject != null)
					return item.SubProject.GetProjectType();
				
				return SolutionItemType.Item;
			}

			return SolutionItemType.Unknown;
		}

		public static SolutionItemType GetProjectType(this Project project)
		{
			var guid = Guid.Parse(project.Kind);

			if (guid == _miscGuid)
				return SolutionItemType.MiscFiles;
			if (guid == _solutionFolderGuid)
				return SolutionItemType.SolutionFolder;

			return SolutionItemType.Project;
		}

		public static string GetProperty(this Project project, string name)
        {
		    if (project.Properties == null)
		    {
		        return null;
		    }

            var prop = project.Properties.Cast<Property>().FirstOrDefault(x => x.Name == name);

            return prop == null ? null : (string) prop.Value;
        }

        public static string GetProperty(this Configuration configuration, string name)
        {
            var prop = configuration.Properties.Cast<Property>().FirstOrDefault(x => x.Name == name);

            return prop == null ? null : (string)prop.Value;
        }
	}
}