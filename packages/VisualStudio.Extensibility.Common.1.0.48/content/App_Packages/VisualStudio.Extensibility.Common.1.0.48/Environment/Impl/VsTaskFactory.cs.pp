//////////////////////////////////////////////////////////////////////////
// This file is a part of VisualStudio.Extensibility.Common NuGet package.
// You are strongly discouraged from fiddling with it.
// If you do, all hell will break loose and living will envy the dead.
//////////////////////////////////////////////////////////////////////////
using System;
using System.ComponentModel.Composition;
using System.Threading;
using System.Threading.Tasks;

namespace $rootnamespace$.Environment.Impl
{
    [Export(typeof(ITaskFactory))]
    public class VsTaskFactory : ITaskFactory
    {
        private readonly TaskFactory _factory = new TaskFactory(new ForcedThreadScheduler());
        
        public Task Run(Action action)
        {
            return _factory.StartNew(action);
        }

        public Task<T> Run<T>(Func<object, T> func, object state, CancellationToken token)
        {
            return _factory.StartNew(func, state, token);
        }

        public Task<T> Run<T>(Func<object, T> func, object state)
        {
            return _factory.StartNew(func, state);
        }
    }
}