//////////////////////////////////////////////////////////////////////////
// This file is a part of VisualStudio.Extensibility.Common NuGet package.
// You are strongly discouraged from fiddling with it.
// If you do, all hell will break loose and living will envy the dead.
//////////////////////////////////////////////////////////////////////////
using System;

namespace $rootnamespace$.Updater
{
	public class DownloadResultArgs : EventArgs
	{
		public DownloadResultArgs()
		{
		}

		public DownloadResultArgs(bool isSuccess, string error)
		{
			IsSuccess = isSuccess;
			Error = error;
		}

		public bool IsSuccess { get; set; }
		public string Error { get; set; }
	}
}