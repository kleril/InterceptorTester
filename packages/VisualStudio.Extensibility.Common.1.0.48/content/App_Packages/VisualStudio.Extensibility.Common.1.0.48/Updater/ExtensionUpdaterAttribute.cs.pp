//////////////////////////////////////////////////////////////////////////
// This file is a part of VisualStudio.Extensibility.Common NuGet package.
// You are strongly discouraged from fiddling with it.
// If you do, all hell will break loose and living will envy the dead.
//////////////////////////////////////////////////////////////////////////
using System;
using System.ComponentModel.Composition;

namespace $rootnamespace$.Updater
{
    public class ExtensionUpdaterAttribute : ExportAttribute
    {
        public ExtensionUpdaterAttribute() : base(typeof(ExtensionUpdaterBase))
        {
        }
    }
}