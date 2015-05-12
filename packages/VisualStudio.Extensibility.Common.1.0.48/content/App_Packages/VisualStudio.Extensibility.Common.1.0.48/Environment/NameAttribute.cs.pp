//////////////////////////////////////////////////////////////////////////
// This file is a part of VisualStudio.Extensibility.Common NuGet package.
// You are strongly discouraged from fiddling with it.
// If you do, all hell will break loose and living will envy the dead.
//////////////////////////////////////////////////////////////////////////
using System;
using System.ComponentModel.Composition;

namespace $rootnamespace$.Environment
{
	/// <summary>
	/// Gives a part a meaningful name
	/// </summary>
	[MetadataAttribute]
	[AttributeUsage(AttributeTargets.Class)]
	public class NameAttribute : Attribute
	{
		public NameAttribute(string name)
		{
			Name = name;
		}

		public string Name { get; set; }
	}
}