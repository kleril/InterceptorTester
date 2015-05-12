//////////////////////////////////////////////////////////////////////////
// This file is a part of VisualStudio.Extensibility.Common NuGet package.
// You are strongly discouraged from fiddling with it.
// If you do, all hell will break loose and living will envy the dead.
//////////////////////////////////////////////////////////////////////////
using System;
using System.Threading;
using System.Threading.Tasks;

namespace $rootnamespace$.Environment
{
    public interface ITaskFactory
    {
        Task Run(Action action);
        Task<T> Run<T>(Func<object, T> func, object state, CancellationToken token);
        Task<T> Run<T>(Func<object, T> func, object state);
    }
}