//////////////////////////////////////////////////////////////////////////
// This file is a part of VisualStudio.Extensibility.Common NuGet package.
// You are strongly discouraged from fiddling with it.
// If you do, all hell will break loose and living will envy the dead.
//////////////////////////////////////////////////////////////////////////
using System;
using System.Collections.Generic;
using System.ComponentModel.Composition;
using System.Linq;

namespace $rootnamespace$.Environment.Impl.Components
{
	[Export(typeof(IPackageComponentCatalog))]
	internal class PackageComponentCatalog : NamedPartsCatalogBase<IPackageComponent>, IPackageComponentCatalog
	{
		public T GetComponent<T>() where T : IPackageComponent
		{
			return GetPart<T>();
		}

		public IPackageComponent GetComponent(string name)
		{
			return GetPart(name);
		}

		public IEnumerable<IPackageComponent> Components
		{
			get { return Parts; }
		}
	}
}