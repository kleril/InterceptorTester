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
using System.IO;
using System.Linq;
using System.Reflection;
using System.Reflection.Emit;
using Microsoft.VisualStudio.ComponentModelHost;
using NotLimited.Framework.Common.Helpers;
using NotLimited.Framework.Common.Logging;

namespace $rootnamespace$.Environment.Injection
{
	internal static class AdapterInjector
	{
		private static readonly Logger _log = Logger.Get(typeof(AdapterInjector));
		
		private class InjectedType
		{
			public Type Type;
			public Type ExportedType;

			public InjectedType(Type type, Type exportedType)
			{
				Type = type;
				ExportedType = exportedType;
			}
		}

		internal static void Inject(IVsServiceProvider serviceProvider)
		{
			var types = MefHelper.GetExportingAssemblies().SelectMany(x => x.GetTypes()).ToList();
			var injectedTypes = new List<Type>();

			injectedTypes.AddRange(GenerateAdapters(types, serviceProvider.GetType()));
			injectedTypes.AddRange(GetDirectInjectionTypes(types));

			var componentModel = serviceProvider.GetService<SComponentModel, IComponentModel>();
			var container = (CompositionContainer)componentModel.DefaultExportProvider;
			var catalog = new TypeCatalog(injectedTypes);

			//((AggregateCatalog)container.Catalog).Catalogs.Add(catalog);
			InjectCatalog(container, catalog);
		}

		private static void InjectCatalog(CompositionContainer container, ComposablePartCatalog catalog)
		{
			var exportProviderProp = typeof(CompositionContainer).GetField("_catalogExportProvider", BindingFlags.Instance | BindingFlags.NonPublic);
			var catalogProp = typeof(CatalogExportProvider).GetField("_catalog", BindingFlags.Instance | BindingFlags.NonPublic);

			if (exportProviderProp == null || catalogProp == null)
				throw new InvalidOperationException("Can't get property descriptors for injection!");

			var exportProvider = exportProviderProp.GetValue(container);
			if (exportProvider == null)
				throw new InvalidOperationException("Can't get export provider!");

			var internalCatalog = (ComposablePartCatalog)catalogProp.GetValue(exportProvider);
			if (internalCatalog == null)
				throw new InvalidOperationException("Can't get internal catalog!");

			var aggregate = new AggregateCatalog(internalCatalog, catalog);
			catalogProp.SetValue(exportProvider, aggregate);
		}

		private static List<Type> GetDirectInjectionTypes(List<Type> types)
		{
			return types.Where(x => !x.IsAbstract && x.GetCustomAttributes(typeof(DirectInjectionAttribute), true).FirstOrDefault() != null).ToList();
		}

		private static List<Type> GenerateAdapters(List<Type> types, Type packageType)
		{
			var templates = GetTemplates(types);
			var injectedTypes = GetInjectedTypes(types, new HashSet<Type>(templates.Keys));
			var builder = AppDomain.CurrentDomain.DefineDynamicAssembly(new AssemblyName("a" + Guid.NewGuid().ToString("N")), AssemblyBuilderAccess.Run);
			var module = builder.DefineDynamicModule("default");
			var result = new List<Type>();
			
			foreach (var injectedType in injectedTypes)
			{
				_log.Info("Generating dynamic adapter for " + injectedType.Type.FullName);

				var template = templates[injectedType.ExportedType];
				var type = module.DefineType("t" + Guid.NewGuid().ToString("N"), TypeAttributes.Public | TypeAttributes.Class, template);

				foreach (var attribute in injectedType.Type.GetCustomAttributesData())
					type.SetCustomAttribute(attribute.ToAttributeBuilder());
				
				//////////////

				var prop = type.DefineProperty("PackageType", PropertyAttributes.None, typeof(Type), null);
				var getter = type.DefineMethod("get_PackageType", MethodAttributes.Public | MethodAttributes.SpecialName | MethodAttributes.Virtual | MethodAttributes.HideBySig, typeof(Type), null);
				var gen = getter.GetILGenerator();
				
				gen.Emit(OpCodes.Ldtoken, packageType);
				gen.EmitCall(OpCodes.Call, typeof(Type).GetMethod("GetTypeFromHandle"), new [] {typeof(RuntimeTypeHandle)});
				gen.Emit(OpCodes.Ret);
				prop.SetGetMethod(getter);

				//////////////
				
				prop = type.DefineProperty("HandlerTypeName", PropertyAttributes.None, typeof(string), null);
				getter = type.DefineMethod("get_HandlerTypeName", MethodAttributes.Public | MethodAttributes.SpecialName | MethodAttributes.Virtual | MethodAttributes.HideBySig, typeof(string), null);
				gen = getter.GetILGenerator();
				
				gen.Emit(OpCodes.Ldstr, injectedType.Type.FullName);
				gen.Emit(OpCodes.Ret);
				prop.SetGetMethod(getter);

				///////////////
				
				prop = type.DefineProperty("Contract", PropertyAttributes.None, typeof(string), null);
				getter = type.DefineMethod("get_Contract", MethodAttributes.Public | MethodAttributes.SpecialName | MethodAttributes.Virtual | MethodAttributes.HideBySig, typeof(string), null);
				gen = getter.GetILGenerator();
				
				gen.Emit(OpCodes.Ldstr, AttributedModelServices.GetContractName(injectedType.ExportedType));
				gen.Emit(OpCodes.Ret);
				prop.SetGetMethod(getter);

				result.Add(type.CreateType());
			}

			return result;
		}

		private static List<InjectedType> GetInjectedTypes(List<Type> types, HashSet<Type> exportedTypes)
		{
			var result = new List<InjectedType>();
			var exportType = typeof(ExportAttribute);

			foreach (var type in types.Where(x => !x.IsAbstract))
			{
				foreach (var attr in type.GetCustomAttributes(true))
				{
					var at = attr.GetType();
					if (!exportType.IsAssignableFrom(at))
						continue;

					var exportAttr = (ExportAttribute)attr;
					if (exportAttr.ContractType == null || !exportedTypes.Contains(exportAttr.ContractType))
						continue;

					result.Add(new InjectedType(type, exportAttr.ContractType));
				}
			}

			return result;
		}

		private static Dictionary<Type, Type> GetTemplates(List<Type> types)
		{
			var result = new Dictionary<Type, Type>();
			
			foreach (var adapterType in types)
			{
				if (!adapterType.IsAbstract
					|| adapterType.BaseType == null
					|| !adapterType.BaseType.IsGenericType
					|| adapterType.BaseType.GetGenericTypeDefinition() != typeof(AdapterBase<>)
					|| adapterType.BaseType.GetGenericArguments().Length == 0)
				{
					continue;
				}

				result[adapterType.BaseType.GetGenericArguments()[0]] = adapterType;
			}
			

			return result;
		}
	}
}