//////////////////////////////////////////////////////////////////////////
// This file is a part of VisualStudio.Extensibility.Common NuGet package.
// You are strongly discouraged from fiddling with it.
// If you do, all hell will break loose and living will envy the dead.
//////////////////////////////////////////////////////////////////////////
using System.IO;
using EnvDTE;
using $rootnamespace$.SolutionWrapper;

namespace $rootnamespace$.Environment.Impl
{
	public class VsDocument : IDocument
	{
		private readonly Document _document;

		public VsDocument(Document document)
		{
			_document = document;
		}

		public string Directory
		{
			get { return !string.IsNullOrEmpty(FileName) ? Path.GetDirectoryName(FileName) : null; }
		}

		public string FileName
		{
			get { return _document.FullName; }
		}
	}
}