//////////////////////////////////////////////////////////////////////////
// This file is a part of VisualStudio.Extensibility.Common NuGet package.
// You are strongly discouraged from fiddling with it.
// If you do, all hell will break loose and living will envy the dead.
//////////////////////////////////////////////////////////////////////////
using System;
using System.Collections.Generic;
using System.ComponentModel.Composition;
using System.ComponentModel.Composition.Hosting;
using System.ComponentModel.Composition.Primitives;
using System.Linq;
using Microsoft.VisualStudio.ComponentModelHost;

namespace $rootnamespace$.Environment.Injection
{
	public class VsServiceExportProvider : ExportProvider
	{
		private readonly HashSet<string> _contracts;
		private readonly CompositionContainer _container;

		public VsServiceExportProvider(IVsServiceProvider serviceProvider, params Type[] types)
		{
			var componentModel = serviceProvider.GetService<SComponentModel, IComponentModel>();

			_container = (CompositionContainer)componentModel.DefaultExportProvider;
			_contracts = new HashSet<string>(types.Select(AttributedModelServices.GetContractName));
		}

		protected override IEnumerable<Export> GetExportsCore(ImportDefinition definition, AtomicComposition atomicComposition)
		{
			if (!_contracts.Contains(definition.ContractName))
				return Enumerable.Empty<Export>();

			return _container.GetExports(definition);
		}
	}
}