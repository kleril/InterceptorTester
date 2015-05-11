//////////////////////////////////////////////////////////////////////////
// This file is a part of VisualStudio.Extensibility.Common NuGet package.
// You are strongly discouraged from fiddling with it.
// If you do, all hell will break loose and living will envy the dead.
//////////////////////////////////////////////////////////////////////////
using System;
using System.Collections.Generic;

namespace $rootnamespace$.Environment.Impl
{
	/// <summary>
	/// Holds information about a node of an order graph. Used internally by the orderer.
	/// 
	/// </summary>
	internal class Node<T>
	{
		private List<Node<T>> _comesBeforeNodes;
		private List<Node<T>> _comesAfterNodes;

		/// <summary>
		/// The original index of the item.
		///  </summary>
		internal int OriginalIndex { get; set; }

		/// <summary>
		/// Name of the node.
		///  </summary>
		internal string Name { get; private set; }

		/// <summary>
		/// The item that being sorted the node represents.
		///  </summary>
		internal T Item { get; set; }

		/// <summary>
		/// Nodes that come later in the list.
		///  </summary>
		internal List<Node<T>> ComesBeforeNodes
		{
			get { return _comesBeforeNodes ?? (_comesBeforeNodes = new List<Node<T>>()); }
		}

		/// <summary>
		/// Nodes that come earlier in the list.
		///  </summary>
		internal List<Node<T>> ComesAfterNodes
		{
			get { return _comesAfterNodes ?? (_comesAfterNodes = new List<Node<T>>()); }
		}

		/// <summary>
		/// Constructor
		///  </summary>
		/// <param name="name">The item's name</param>
		internal Node(string name)
		{
			OriginalIndex = -1;
			Name = name;
		}
	}

	/// <summary>
	/// Performs a topological sort of orderable extension parts.
	/// 
	/// </summary>
	public static class OrderHelper
	{
		/// <summary>
		/// Orders a list of items that are all orderable, that is, items that implement the IOrderable interface.
		/// 
		/// </summary>
		/// <param name="itemsToOrder">The list of items to sort.</param>
		/// <returns>
		/// The list of sorted items.
		/// </returns>
		/// <exception cref="T:System.ArgumentNullException"><paramref name="itemsToOrder"/> is null.</exception>
		public static IList<Lazy<TValue, TMetadata>> Order<TValue, TMetadata>(IEnumerable<Lazy<TValue, TMetadata>> itemsToOrder)
			where TValue : class
			where TMetadata : IPartMetadata
		{
			if (itemsToOrder == null)
				throw new ArgumentNullException("itemsToOrder");
			
			return TopologicalSort(BuildGraphData(itemsToOrder));
		}

		/// <summary>
		/// Orders nodes of the graph using a topological sort algorithm.
		/// 
		/// </summary>
		private static IList<Lazy<TValue, TMetadata>> TopologicalSort<TValue, TMetadata>(Dictionary<Node<Lazy<TValue, TMetadata>>, int> graph)
			where TValue : class
			where TMetadata : IPartMetadata
		{
			var roots = FindRoots(graph);
			var list = new List<Lazy<TValue, TMetadata>>();
			while (graph.Count > 0)
			{
				Node<Lazy<TValue, TMetadata>> node;
				if (roots.Count == 0)
				{
					node = BreakCircularReference(graph);
				}
				else
				{
					node = roots[0];
					roots.RemoveAt(0);
				}
				if (node.Item != null)
					list.Add(node.Item);
				RemoveIncomingEdgesFromChildNodes(node, roots);
				graph.Remove(node);
			}
			return list;
		}

		/// <summary>
		/// Removes references to the root from all the nodes that follow it.
		/// 
		/// </summary>
		private static void RemoveIncomingEdgesFromChildNodes<TValue, TMetadata>(Node<Lazy<TValue, TMetadata>> root, List<Node<Lazy<TValue, TMetadata>>> roots)
			where TValue : class
			where TMetadata : IPartMetadata
		{
			foreach (Node<Lazy<TValue, TMetadata>> newRoot in root.ComesBeforeNodes)
			{
				RemoveNodeFromList(newRoot.ComesAfterNodes, root);
				if (newRoot.ComesAfterNodes.Count == 0)
					AddRoot(roots, newRoot);
			}
		}

		/// <summary>
		/// Builds a graph that represents relationships between the items.
		/// 
		/// </summary>
		/// <param name="itemsToOrder">The list of items that are being ordered.</param>
		/// <returns>
		/// Set of graph nodes for the given items.
		/// </returns>
		private static Dictionary<Node<Lazy<TValue, TMetadata>>, int> BuildGraphData<TValue, TMetadata>(IEnumerable<Lazy<TValue, TMetadata>> itemsToOrder)
			where TValue : class
			where TMetadata : IPartMetadata
		{
			var namedNodes = new Dictionary<string, Node<Lazy<TValue, TMetadata>>>();
			var graph = new Dictionary<Node<Lazy<TValue, TMetadata>>, int>();
			int num = 0;
			foreach (Lazy<TValue, TMetadata> lazy in itemsToOrder)
			{
				string name;
				IEnumerable<string> comesBeforeItem;
				IEnumerable<string> comesAfterItem;
				if (TryGetNodeDetails(lazy, out name, out comesBeforeItem, out comesAfterItem))
				{
					Node<Lazy<TValue, TMetadata>> node;
					if (name.Length != 0 && namedNodes.TryGetValue(name, out node))
					{
						if (node.Item != null)
							continue;
					}
					else
					{
						node = new Node<Lazy<TValue, TMetadata>>(name);
						graph.Add(node, 0);
						if (name.Length != 0)
							namedNodes.Add(name, node);
					}
					node.Item = lazy;
					node.OriginalIndex = num++;
					if (comesBeforeItem != null)
					{
						foreach (string str in comesBeforeItem)
						{
							if (str != null)
								UpdateReferenceToLaterNode(graph, namedNodes, node, str.ToUpperInvariant());
						}
					}
					if (comesAfterItem != null)
					{
						foreach (string str in comesAfterItem)
						{
							if (str != null)
								UpdateReferenceToEarlierNode(graph, namedNodes, node, str.ToUpperInvariant());
						}
					}
				}
			}
			return graph;
		}

		/// <summary>
		/// Check the node and try to extract its ordering details.
		/// 
		/// </summary>
		/// <param name="item">The item to interrogate</param><param name="name">The name of the item if s available</param><param name="comesBeforeItem">The list of names items this one comes before</param><param name="comesAfterItem">The list of names of items this one comes after</param>
		/// <returns>
		/// true if the item needs to be a part of the ordering, false if it should be skipped
		/// </returns>
		private static bool TryGetNodeDetails<TValue, TMetadata>(Lazy<TValue, TMetadata> item, out string name, out IEnumerable<string> comesBeforeItem, out IEnumerable<string> comesAfterItem)
			where TValue : class
			where TMetadata : IPartMetadata
		{
			name = string.Empty;
			comesBeforeItem = null;
			comesAfterItem = null;
			if (item == null)
				return false;
			if (item.Metadata.Name != null)
				name = item.Metadata.Name.ToUpperInvariant();
			comesBeforeItem = item.Metadata.Before;
			comesAfterItem = item.Metadata.After;
			return true;
		}

		/// <summary>
		/// Fix up references between the node that is being added to graph and the one that comes after it.
		/// 
		/// </summary>
		private static void UpdateReferenceToLaterNode<TValue, TMetadata>(Dictionary<Node<Lazy<TValue, TMetadata>>, int> graph, Dictionary<string, Node<Lazy<TValue, TMetadata>>> namedNodes, Node<Lazy<TValue, TMetadata>> newNode, string nameOfNodeThatTheNewOneComesBefore)
			where TValue : class
			where TMetadata : IPartMetadata
		{
			Node<Lazy<TValue, TMetadata>> referencedNode;
			if (namedNodes.TryGetValue(nameOfNodeThatTheNewOneComesBefore, out referencedNode))
			{
				if (!referencedNode.ComesAfterNodes.Exists(node => node == newNode))
					referencedNode.ComesAfterNodes.Add(newNode);
			}
			else
			{
				referencedNode = new Node<Lazy<TValue, TMetadata>>(nameOfNodeThatTheNewOneComesBefore);
				referencedNode.ComesAfterNodes.Add(newNode);
				graph.Add(referencedNode, 0);
				namedNodes.Add(referencedNode.Name, referencedNode);
			}
			if (newNode.ComesBeforeNodes.Exists(node => node == referencedNode))
				return;
			newNode.ComesBeforeNodes.Add(referencedNode);
		}

		/// <summary>
		/// Fix up references between the node that is being added to graph and the one that comes before it.
		///  </summary>
		private static void UpdateReferenceToEarlierNode<TValue, TMetadata>(Dictionary<Node<Lazy<TValue, TMetadata>>, int> graph, Dictionary<string, Node<Lazy<TValue, TMetadata>>> namedNodes, Node<Lazy<TValue, TMetadata>> newNode, string nameOfNodeThatTheNewOneComesAfter)
			where TValue : class
			where TMetadata : IPartMetadata
		{
			Node<Lazy<TValue, TMetadata>> referencedNode;
			if (namedNodes.TryGetValue(nameOfNodeThatTheNewOneComesAfter, out referencedNode))
			{
				if (!referencedNode.ComesBeforeNodes.Exists(node => node == newNode))
					referencedNode.ComesBeforeNodes.Add(newNode);
			}
			else
			{
				referencedNode = new Node<Lazy<TValue, TMetadata>>(nameOfNodeThatTheNewOneComesAfter);
				referencedNode.ComesBeforeNodes.Add(newNode);
				graph.Add(referencedNode, 0);
				namedNodes.Add(referencedNode.Name, referencedNode);
			}
			if (newNode.ComesAfterNodes.Exists(node => node == referencedNode))
				return;
			newNode.ComesAfterNodes.Add(referencedNode);
		}

		/// <summary>
		/// Finds all nodes with no incoming edges
		///             (which represent items that don't have any other ones before them).
		///             The returned list contains item sorted in the order corresponding to their position in the original list.
		///             This is done to make this topological sort implementation into a stable sort.
		/// 
		/// </summary>
		private static List<Node<Lazy<TValue, TMetadata>>> FindRoots<TValue, TMetadata>(Dictionary<Node<Lazy<TValue, TMetadata>>, int> graph)
			where TValue : class
			where TMetadata : IPartMetadata
		{
			var list = new List<Node<Lazy<TValue, TMetadata>>>();
			foreach (Node<Lazy<TValue, TMetadata>> node in graph.Keys)
			{
				if (node.ComesAfterNodes.Count == 0)
					list.Add(node);
			}
			list.Sort(CompareTwoRootsByOrigIndex);
			return list;
		}

		/// <summary>
		/// Add a new root to the list of current roots while keeping the list sorted based on the original index positions
		///             (this is done to make this sort implementation stable).
		/// 
		/// </summary>
		private static void AddRoot<TValue, TMetadata>(List<Node<Lazy<TValue, TMetadata>>> roots, Node<Lazy<TValue, TMetadata>> newRoot)
			where TValue : class
			where TMetadata : IPartMetadata
		{
			roots.Add(newRoot);
			roots.Sort(CompareTwoRootsByOrigIndex);
		}

		/// <summary>
		/// Break a circular reference in the graph.
		/// 
		/// </summary>
		/// 
		/// <returns>
		/// Returns a new root node.
		/// </returns>
		private static Node<Lazy<TValue, TMetadata>> BreakCircularReference<TValue, TMetadata>(Dictionary<Node<Lazy<TValue, TMetadata>>, int> graph)
			where TValue : class
			where TMetadata : IPartMetadata
		{
			var nodeToRemove = (Node<Lazy<TValue, TMetadata>>)null;
			foreach (var node in graph.Keys)
			{
				if (nodeToRemove == null || node.ComesAfterNodes.Count < nodeToRemove.ComesAfterNodes.Count || node.ComesAfterNodes.Count == nodeToRemove.ComesAfterNodes.Count && node.OriginalIndex < nodeToRemove.OriginalIndex)
					nodeToRemove = node;
			}

			if (nodeToRemove != null)
			{
				foreach (var node in nodeToRemove.ComesAfterNodes)
					RemoveNodeFromList(node.ComesBeforeNodes, nodeToRemove);
				nodeToRemove.ComesAfterNodes.Clear();
			}

			return nodeToRemove;
		}

		/// <summary>
		/// Removes a node from the list. The node MUST exist in the list.
		/// 
		/// </summary>
		private static void RemoveNodeFromList<TValue, TMetadata>(List<Node<Lazy<TValue, TMetadata>>> nodes, Node<Lazy<TValue, TMetadata>> nodeToRemove)
			where TValue : class
			where TMetadata : IPartMetadata
		{
			int index = nodes.FindIndex(node => node == nodeToRemove);
			if (index < 0)
				throw new InvalidOperationException("Bug in orderer implementation found: node references are broken");
			nodes.RemoveAt(index);
		}

		/// <summary>
		/// Compares two nodes by their original index.
		/// 
		/// </summary>
		private static int CompareTwoRootsByOrigIndex<TValue, TMetadata>(Node<Lazy<TValue, TMetadata>> x, Node<Lazy<TValue, TMetadata>> y)
			where TValue : class
			where TMetadata : IPartMetadata
		{
			return x.OriginalIndex.CompareTo(y.OriginalIndex);
		}
	}
}