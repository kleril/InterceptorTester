using System;

namespace ConsoleApplication1
{

	/// <summary>
	/// Used to parse the Json of the b element of the DeviceBackup class
	/// </summary>
	public class BackupItem
	{
        public bool isValid()
        {
            if (d != null && s != null && t != null && c != null)
            {
                return true;
            }
            else
            {
                return false;
            }
        }

		public String d;
		public int s;

		public DateTimeOffset t;

		public bool? c;

	}

	public class DeviceBackupJSON
	{
        public bool isValid()
        {
			if (a != null && ValidSerialNumbers.isValid (i) && s != null) {
				foreach (BackupItem item in b) {
					if (!item.isValid ()) {
						return false;
					}
				}
				return true;
			} else
				return false;
        }

		/// <summary>
		/// Gets or sets a
		/// </summary>
		public string a { get; set; }

		/// <summary>
		/// Gets or sets i
		/// </summary>
		public string i { get; set; }

		/// <summary>
		/// Gets or sets b
		/// </summary>
		public object[] b { get; set; }

		public int s { get; set; }

		public override string ToString()
		{
			return string.Format("[DeviceBackup s: {0}, i: {1}, b: {2}, a: {3} ]", s, i, b, a);
		}
	}


}

