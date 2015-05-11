//////////////////////////////////////////////////////////////////////////
// This file is a part of VisualStudio.Extensibility.Common NuGet package.
// You are strongly discouraged from fiddling with it.
// If you do, all hell will break loose and living will envy the dead.
//////////////////////////////////////////////////////////////////////////
using System;
using System.ComponentModel.Composition;
using System.Windows.Controls;

namespace $rootnamespace$.Environment
{
	[AttributeUsage(AttributeTargets.Class)]
	[MetadataAttribute]
	public class StatusBarItemAttribute : ExportAttribute
	{
		public Dock Dock { get; set; }

		public StatusBarItemAttribute() : base(typeof(IStatusBarItem))
		{
			Dock = Dock.Right;
		}
	}
}