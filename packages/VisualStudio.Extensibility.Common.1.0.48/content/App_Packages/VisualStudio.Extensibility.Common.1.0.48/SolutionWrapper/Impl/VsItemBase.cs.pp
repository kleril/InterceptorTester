//////////////////////////////////////////////////////////////////////////
// This file is a part of VisualStudio.Extensibility.Common NuGet package.
// You are strongly discouraged from fiddling with it.
// If you do, all hell will break loose and living will envy the dead.
//////////////////////////////////////////////////////////////////////////
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using EnvDTE;

namespace $rootnamespace$.SolutionWrapper.Impl
{
	internal abstract class VsItemBase : ISolutionItem
	{
		protected DTE _dte;
		protected ISolutionItem _parent;
		protected ISolution _solution;

		protected VsItemBase()
		{
		}

		protected VsItemBase(DTE dte, ISolutionItem parent, ISolution solution)
		{
			_dte = dte;
			_parent = parent;
			_solution = solution;
		}

		public abstract string FileName { get; }
		public abstract string Directory { get; }
		public abstract string Name { get; }
		public abstract SolutionItemType Type { get; }

		public virtual ISolutionItem Parent
		{
			get { return _parent; }
		}

		public abstract IEnumerable<ISolutionItem> Children { get; }

		public ISolutionItem CreateFolderStructure(string path)
		{
			if (string.IsNullOrEmpty(path)) throw new ArgumentNullException("path");

			var parts = path.Split(new[] { '/' }, StringSplitOptions.RemoveEmptyEntries);
			if (parts.Length == 0)
				throw new InvalidOperationException("Invalid path: " + path);

			var tree = (ISolutionItem)this;
			for (int i = 0; i < parts.Length; i++)
				tree = tree.Children.FirstOrDefault(x => x.Name == parts[i]) ?? tree.CreateFolder(parts[i]);

			return tree;
		}

		public void CheckOut()
		{
			if (string.IsNullOrEmpty(FileName))
				return;

			if (_dte.SourceControl.IsItemUnderSCC(FileName) && !_dte.SourceControl.IsItemCheckedOut(FileName))
				_dte.SourceControl.CheckOutItem(FileName);
		}

		public abstract ISolutionItem AddFile(string path);
		public abstract ISolutionItem CreateFolder(string name);

		public string SolutionRelativePath
		{
			get
			{
				var items = new List<ISolutionItem> {this};
				var parent = Parent;
			    int count = 0;

				while (parent != null && parent.Type != SolutionItemType.Solution)
				{
					items.Add(parent);
					parent = parent.Parent;

				    count++;
                    if (count > 1000)
                        throw new InvalidOperationException("Reached the maximum number of nested items. This probably is a bug.");
				}

				var builder = new StringBuilder();
				for (int i = items.Count - 1; i >= 0; i--)
					builder.Append('/').Append(items[i].Name);

				return builder.ToString();
			}
		}

		public bool IsUnderPath(string path)
		{
			if (string.IsNullOrEmpty(path)) throw new ArgumentNullException("path");

			var ownParts = SolutionRelativePath.Split(new[] {'/'}, StringSplitOptions.RemoveEmptyEntries);
			var parts = path.Split(new[] { '/' }, StringSplitOptions.RemoveEmptyEntries);
			if (parts.Length == 0)
				throw new InvalidOperationException("Invalid path specified: " + path);

			if (ownParts.Length < parts.Length)
				return false;

			for (int i = 0; i < parts.Length; i++)
			{
				if (!parts[i].Equals(ownParts[i], StringComparison.InvariantCultureIgnoreCase))
					return false;
			}

			return true;
		}

		public ISolutionProject FindParentProject()
		{
			var item = (ISolutionItem)this;
			while (item != null)
			{
				if (item.Type == SolutionItemType.Project)
					return (ISolutionProject)item;

				item = item.Parent;
			}

			return null;
		}

		public void SaveParentProject()
		{
			var parent = FindParentProject();
			if (parent != null)
				parent.Save();
		}

		public ISolutionItem FindItem(Predicate<ISolutionItem> predicate, bool includeMisc = false)
		{
			return FindItems(predicate).FirstOrDefault();
		}

		public IEnumerable<ISolutionItem> FindItems(Predicate<ISolutionItem> predicate, bool includeMisc = false)
		{
			if (predicate == null) throw new ArgumentNullException("predicate");

			var queue = new Queue<ISolutionItem>();
			queue.Enqueue(this);

			while (queue.Count > 0)
			{
				var item = queue.Dequeue();
				if (item.Type == SolutionItemType.MiscFiles && !includeMisc)
					continue;
				if (predicate(item))
					yield return item;

				if (item.Children != null)
				{
					foreach (var child in item.Children)
						queue.Enqueue(child);
				}
			}
		}

		public ISolutionItem GetItemBySolutionPath(string path)
		{
			if (string.IsNullOrEmpty(path)) throw new ArgumentNullException("path");

			var parts = path.Split(new[] { '/' }, StringSplitOptions.RemoveEmptyEntries);
			if (parts.Length == 0)
				throw new InvalidOperationException("Invalid path specified: " + path);

			var tree = (ISolutionItem)this;
			for (int i = 0; i < parts.Length; i++)
			{
				tree = tree.Children.FirstOrDefault(x => x.Name == parts[i]);
				if (tree == null)
					break;
			}

			return tree;
		}

		public override string ToString()
		{
			return Name + " (" + Type.ToString() + ") [" + GetType().Name + "]";
		}
	}
}