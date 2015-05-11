//////////////////////////////////////////////////////////////////////////
// This file is a part of VisualStudio.Extensibility.Common NuGet package.
// You are strongly discouraged from fiddling with it.
// If you do, all hell will break loose and living will envy the dead.
//////////////////////////////////////////////////////////////////////////
using System;
using System.ComponentModel.Composition;
using System.Text;
using Microsoft.VisualStudio.Shell.Interop;

namespace $rootnamespace$.Environment
{
	/// <summary>
	/// Base class for an output pane
	/// </summary>
	public abstract class OutputPaneBase
	{
		private StringBuilder _cache;

		[Import]
		private IOutputWindowService _outputWindowService = null;

		private IVsOutputWindowPane _pane;

		internal IVsOutputWindowPane Pane
		{
			get { return _pane; }
			set
			{
				_pane = value;
				FlushCache();
			}
		}

		/// <summary>
		/// Pane caption
		/// </summary>
		public abstract string Caption { get; }

		/// <summary>
		/// Activates the pane
		/// </summary>
		/// <param name="withWindow">Set true to activate the output window as well.</param>
		public void Activate(bool withWindow = false)
		{
			if (withWindow)
				_outputWindowService.ActivateOutputWindow();

			Pane.Activate();
		}

		/// <summary>
		/// Clears the pane
		/// </summary>
		public void Clear()
		{
			Pane.Clear();
		}

		/// <summary>
		/// Hides the pane
		/// </summary>
		public void Hide()
		{
			Pane.Hide();
		}

		/// <summary>
		/// Writes a message to the pane
		/// </summary>
		public void Write(string message)
		{
			if (Pane == null)
			{
				if (_cache == null)
					_cache = new StringBuilder();
				_cache.Append(message);
			}
			else
				Pane.OutputStringThreadSafe(message);
		}

		/// <summary>
		/// Writes a line to the pane
		/// </summary>
		public void WriteLine(string message)
		{
			Write(message + System.Environment.NewLine);
		}

		private void FlushCache()
		{
			if (_cache != null)
			{
				string msg = _cache.ToString();
				if (!string.IsNullOrEmpty(msg))
					Pane.OutputStringThreadSafe(msg);
				_cache = null;
			}
		}
	}
}