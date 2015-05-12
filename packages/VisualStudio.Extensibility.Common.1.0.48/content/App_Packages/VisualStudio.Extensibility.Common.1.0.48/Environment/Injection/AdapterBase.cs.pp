//////////////////////////////////////////////////////////////////////////
// This file is a part of VisualStudio.Extensibility.Common NuGet package.
// You are strongly discouraged from fiddling with it.
// If you do, all hell will break loose and living will envy the dead.
//////////////////////////////////////////////////////////////////////////
using System;
using System.Linq;

namespace $rootnamespace$.Environment.Injection
{
	public abstract class AdapterBase<T> where T : class 
	{
		protected abstract Type PackageType { get; }
		protected abstract string HandlerTypeName { get; }
		protected abstract string Contract { get; }

		protected T Target
		{
			get
			{
				var container = VsPackageCatalog.GetContainer(PackageType);
				var target = container.GetExportedValues<T>(Contract).FirstOrDefault(x => x.GetType().FullName == HandlerTypeName);
				if (target == null)
					throw new InvalidOperationException("Can't get target for " + typeof(T) + " with type " + HandlerTypeName);

				return target;
			}
		}
	}
}