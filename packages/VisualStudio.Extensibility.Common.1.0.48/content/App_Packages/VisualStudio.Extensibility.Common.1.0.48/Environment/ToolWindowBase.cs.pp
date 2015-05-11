//////////////////////////////////////////////////////////////////////////
// This file is a part of VisualStudio.Extensibility.Common NuGet package.
// You are strongly discouraged from fiddling with it.
// If you do, all hell will break loose and living will envy the dead.
//////////////////////////////////////////////////////////////////////////
using System.ComponentModel.Composition;
using System.IO;
using System.Windows;
using System.Windows.Forms;
using System.Windows.Media.Imaging;
using Microsoft.VisualStudio.OLE.Interop;
using Microsoft.VisualStudio.Shell.Interop;

namespace $rootnamespace$.Environment
{
	/// <summary>
	/// Base class for tool windows
	/// </summary>
	public abstract class ToolWindowBase : IVsUIElementPane
	{
		private string _caption;

		internal IVsWindowFrame Frame { get; set; }

		/// <summary>
		/// Tool window content
		/// </summary>
		public abstract FrameworkElement Element { get; }

		/// <summary>
		/// Tool window caption
		/// </summary>
		public string Caption
		{
			get { return _caption; }
			set
			{
				_caption = value;
				if (Frame != null)
					Frame.SetProperty((int)__VSFPROPID.VSFPROPID_Caption, _caption);
			}
		}

		public virtual BitmapSource Icon { get { return null; } }

		public int SetUIElementSite(IServiceProvider pSp)
		{
			return 0;
		}

		public int CreateUIElementPane(out object punkUiElement)
		{
			punkUiElement = Element;
			return 0;
		}

		public int GetDefaultUIElementSize(SIZE[] psize)
		{
			return -2147467263;
		}

		public int CloseUIElementPane()
		{
			return 0;
		}

		public int LoadUIElementState(IStream pstream)
		{
			byte[] bufferFromIStream = GetBufferFromIStream(pstream);
			if (bufferFromIStream.Length > 0)
			{
				using (MemoryStream stream = new MemoryStream(bufferFromIStream))
				{
					return this.LoadUiState(stream);
				}
			}
			return 0;
		}

		public int SaveUIElementState(IStream pstream)
		{
			Stream stream;
			int hr = SaveUiState(out stream);
			if (hr >= 0)
			{
				using (stream)
				{
					if (((stream == null) || !stream.CanRead) || (stream.Length <= 0L))
					{
						return hr;
					}
					using (BinaryReader reader = new BinaryReader(stream))
					{
						byte[] buffer = new byte[stream.Length];
						stream.Position = 0L;
						reader.Read(buffer, 0, buffer.Length);
						uint pcbWritten = 0;
						pstream.Write(buffer, (uint)buffer.Length, out pcbWritten);
						pstream.Commit(0);
					}
				}
			}
			return hr;

		}

		public int TranslateUIElementAccelerator(MSG[] msg)
		{
			Message m = Message.Create(msg[0].hwnd, (int)msg[0].message, msg[0].wParam, msg[0].lParam);
			bool flag = this.PreProcessMessage(ref m);
			msg[0].message = (uint)m.Msg;
			msg[0].wParam = m.WParam;
			msg[0].lParam = m.LParam;
			if (flag)
			{
				return 0;
			}
			return -2147467259;

		}

		protected virtual int LoadUiState(Stream stream)
		{
			return -2147467263;
		}

		protected virtual int SaveUiState(out Stream stateStream)
		{
			stateStream = null;
			return 0;
		}

		private bool PreProcessMessage(ref Message m)
		{
			Control control = Control.FromChildHandle(m.HWnd);
			return ((control != null) && (control.PreProcessControlMessage(ref m) == PreProcessControlState.MessageProcessed));
		}

		private static byte[] GetBufferFromIStream(IStream comStream)
		{
			LARGE_INTEGER large_integer;
			LARGE_INTEGER large_integer2;
			large_integer.QuadPart = 0L;
			ULARGE_INTEGER[] plibNewPosition = new ULARGE_INTEGER[1];
			comStream.Seek(large_integer, 1, plibNewPosition);
			comStream.Seek(large_integer, 0, null);
			STATSTG[] pstatstg = new STATSTG[1];
			comStream.Stat(pstatstg, 1);
			int quadPart = (int)pstatstg[0].cbSize.QuadPart;
			byte[] pv = new byte[quadPart];
			uint pcbRead = 0;
			comStream.Read(pv, (uint)pv.Length, out pcbRead);
			large_integer2.QuadPart = (long)plibNewPosition[0].QuadPart;
			comStream.Seek(large_integer2, 0, null);
			return pv;
		}
	}
}