//////////////////////////////////////////////////////////////////////////
// This file is a part of VisualStudio.Extensibility.Common NuGet package.
// You are strongly discouraged from fiddling with it.
// If you do, all hell will break loose and living will envy the dead.
//////////////////////////////////////////////////////////////////////////
using System;
using System.Collections.Generic;
using System.ComponentModel.Composition;
using System.Linq;

namespace $rootnamespace$.Environment.Impl
{
	public abstract class PartsCatalogBase<TContract, TMetadata> where TMetadata : IPartMetadata
	{
		[ImportMany]
		private IEnumerable<Lazy<TContract, TMetadata>> ImportedParts
		{
			set
			{
				_typedParts = value.ToDictionary(x => x.Value.GetType(), x => x);
				_namedParts = value
					.Where(x => !string.IsNullOrEmpty(x.Metadata.Name))
					.ToDictionary(x => x.Metadata.Name, x => x);
			}
		}

		private Dictionary<Type, Lazy<TContract, TMetadata>> _typedParts;
		private Dictionary<string, Lazy<TContract, TMetadata>> _namedParts;

		protected IEnumerable<TContract> Parts { get { return _typedParts.Values.Select(x => x.Value); } }
		protected IEnumerable<Lazy<TContract, TMetadata>> PartsWithMetadata { get { return _typedParts.Values; } }

		protected bool ContainsPart<TPart>() where TPart : TContract
		{
			return _typedParts.ContainsKey(typeof(TPart));
		}

		protected bool ContainsPart(string name)
		{
			return _namedParts.ContainsKey(name);
		}

		protected TPart GetPart<TPart>() where TPart : TContract
		{
			var type = typeof(TPart);

			if (!_typedParts.ContainsKey(type))
				throw new InvalidOperationException("Can't find the component with type: " + type.Name);

			return (TPart)_typedParts[type].Value;
		}

		protected TContract GetPart(string name)
		{
			if (!_namedParts.ContainsKey(name))
				throw new InvalidOperationException("Can't find the component with name: " + name);

			return _namedParts[name].Value;
		}

		protected Lazy<TContract, TMetadata> GetPartWithMetadata<TPart>() where TPart : TContract
		{
			var type = typeof(TPart);

			if (!_typedParts.ContainsKey(type))
				throw new InvalidOperationException("Can't find the component with type: " + type.Name);

			var pair = _typedParts[type];
			return new Lazy<TContract, TMetadata>(() => (TPart)pair.Value, pair.Metadata);
		}

		protected Lazy<TContract, TMetadata> GetPartWithMetadata(string name)
		{
			if (!_namedParts.ContainsKey(name))
				throw new InvalidOperationException("Can't find the component with name: " + name);

			return _namedParts[name];
		}
	}
}