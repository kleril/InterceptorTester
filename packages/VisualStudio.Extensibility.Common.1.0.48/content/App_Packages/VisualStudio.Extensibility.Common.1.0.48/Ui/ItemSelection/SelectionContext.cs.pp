//////////////////////////////////////////////////////////////////////////
// This file is a part of VisualStudio.Extensibility.Common NuGet package.
// You are strongly discouraged from fiddling with it.
// If you do, all hell will break loose and living will envy the dead.
//////////////////////////////////////////////////////////////////////////
using System.Collections.Generic;
using System.Windows.Media;

namespace $rootnamespace$.Ui.ItemSelection
{
    public class SelectionContext
    {
        public List<SelectionItem> Items { get; set; }
        public string Caption { get; set; }
        public ImageSource Image { get; set; }
    }
}