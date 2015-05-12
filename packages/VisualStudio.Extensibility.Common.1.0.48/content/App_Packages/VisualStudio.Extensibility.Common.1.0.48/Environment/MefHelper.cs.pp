//////////////////////////////////////////////////////////////////////////
// This file is a part of VisualStudio.Extensibility.Common NuGet package.
// You are strongly discouraged from fiddling with it.
// If you do, all hell will break loose and living will envy the dead.
//////////////////////////////////////////////////////////////////////////
using System;
using System.Collections.Generic;
using System.ComponentModel.Composition.Hosting;
using System.ComponentModel.Composition.Primitives;
using System.IO;
using System.Reflection;
using System.Xml.Linq;
using NotLimited.Framework.Common.Helpers;
using NotLimited.Framework.Common.Helpers.Xml;

namespace $rootnamespace$.Environment
{
    public static class MefHelper
    {
        public static ComposablePartCatalog GetExtensionPartCatalog()
        {
            var result = new AggregateCatalog();
            foreach (var assembly in GetExportingAssemblies())
                result.Catalogs.Add(new AssemblyCatalog(assembly));

            return result;
        }

        public static IEnumerable<Assembly> GetExportingAssemblies()
        {
            string manifestPath = PathHelpers.CombineWithAssemblyDirectory("extension.vsexconfig");
            if (!File.Exists(manifestPath))
                throw new InvalidOperationException("Extension config not found!");

            var doc = XDocument.Load(manifestPath);
            if (doc.Root == null)
                throw new InvalidOperationException("Extension config is corrupted!");

            var assembliesNode = doc.Root.ChildElement("assemblies");
            if (assembliesNode == null)
                yield break;

            foreach (var child in assembliesNode.ChildElements("assembly"))
            {
                string path = PathHelpers.CombineWithAssemblyDirectory(child.Value);
                if (!File.Exists(path))
                    throw new InvalidOperationException("Assembly '" + child.Value + "', specified as a MEF component, doesn't exist on disk!");

                yield return Assembly.LoadFile(path);
            }
        }
    }
}