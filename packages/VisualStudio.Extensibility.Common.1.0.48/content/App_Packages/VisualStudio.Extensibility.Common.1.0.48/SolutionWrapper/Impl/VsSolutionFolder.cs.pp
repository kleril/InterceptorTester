//////////////////////////////////////////////////////////////////////////
// This file is a part of VisualStudio.Extensibility.Common NuGet package.
// You are strongly discouraged from fiddling with it.
// If you do, all hell will break loose and living will envy the dead.
//////////////////////////////////////////////////////////////////////////
using System;
using System.Collections.Generic;
using System.Runtime.InteropServices;
using EnvDTE;
using EnvDTE80;

namespace $rootnamespace$.SolutionWrapper.Impl
{
	internal class VsSolutionFolder : VsSolutionProject
	{
		private readonly SolutionFolder _solutionFolder;

		public VsSolutionFolder(DTE dte, ISolutionItem parent, ISolution solution, Project project, SolutionFolder solutionFolder) : base(dte, parent, solution, project)
		{
			_solutionFolder = solutionFolder;
		}

		public override SolutionItemType Type
		{
			get { return SolutionItemType.SolutionFolder; }
		}

		public override ISolutionItem CreateFolder(string name)
		{
			if (string.IsNullOrEmpty(name)) throw new ArgumentNullException("name");

			Project project;
			try
			{
				project = _solutionFolder.AddSolutionFolder(name);
				_project.Save();
			}
			catch (COMException e)
			{
				throw new SolutionException(e.Message, e);
			}

			var folder = project.Object as SolutionFolder;
			if (folder == null)
				throw new InvalidOperationException("Can't get SolutionFolder interface from newly created solution folder!");

			return new VsSolutionFolder(_dte, this, _solution, project, folder);
		}
	}
}