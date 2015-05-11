//////////////////////////////////////////////////////////////////////////
// This file is a part of VisualStudio.Extensibility.Common NuGet package.
// You are strongly discouraged from fiddling with it.
// If you do, all hell will break loose and living will envy the dead.
//////////////////////////////////////////////////////////////////////////
using System;
using System.Collections.Generic;
using System.ComponentModel.Composition.Hosting;

namespace $rootnamespace$.Environment.Injection
{
	internal static class VsPackageCatalog
	{
		private static readonly Dictionary<Type, CompositionContainer> _containers = new Dictionary<Type, CompositionContainer>();

		internal static void RegisterContainer(Type packageType, CompositionContainer container)
		{
			if (packageType == null)
				throw new ArgumentNullException("packageType");
			if (container == null)
				throw new ArgumentNullException("container");

			_containers[packageType] = container;
		}

		internal static CompositionContainer GetContainer(Type packageType)
		{
			if (packageType == null)
				throw new ArgumentNullException("packageType");

			CompositionContainer result;
			if (!_containers.TryGetValue(packageType, out result))
				throw new InvalidOperationException("Container is not registered for package: " + packageType.ToString());

			return result;
		}
	}
}