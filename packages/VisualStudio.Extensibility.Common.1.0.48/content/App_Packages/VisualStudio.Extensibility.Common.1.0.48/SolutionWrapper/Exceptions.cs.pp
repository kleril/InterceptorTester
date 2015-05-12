//////////////////////////////////////////////////////////////////////////
// This file is a part of VisualStudio.Extensibility.Common NuGet package.
// You are strongly discouraged from fiddling with it.
// If you do, all hell will break loose and living will envy the dead.
//////////////////////////////////////////////////////////////////////////
using System;
using System.Runtime.Serialization;

namespace $rootnamespace$.SolutionWrapper
{
	[Serializable]
	public class SolutionException : Exception
	{
		//
		// For guidelines regarding the creation of new exception types, see
		//    http://msdn.microsoft.com/library/default.asp?url=/library/en-us/cpgenref/html/cpconerrorraisinghandlingguidelines.asp
		// and
		//    http://msdn.microsoft.com/library/default.asp?url=/library/en-us/dncscol/html/csharp07192001.asp
		//

		public SolutionException()
		{
		}

		public SolutionException(string message) : base(message)
		{
		}

		public SolutionException(string message, Exception inner) : base(message, inner)
		{
		}

		protected SolutionException(
			SerializationInfo info,
			StreamingContext context) : base(info, context)
		{
		}
	}
}