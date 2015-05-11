﻿using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Web;

namespace ConsoleApplication1
{
	/// <summary>
	/// Class for create device status - Is not backwards compatible with IPS
	/// </summary>
	public class DeviceStatusJSON
	{
        public bool isValid ()
        {
            if (ValidSerialNumbers.isValid(intSerial) && seqNum != null)
            {
                return true;
            }



            return false;
        }

		/// <summary>
		/// Gets or sets intSerial
		/// </summary>
		// ReSharper disable InconsistentNaming
		public string intSerial { get; set; }


		public string seqNum { get; set; }

		/// <summary>
		/// Gets or sets startURL
		/// </summary>
		public string startURL { get; set; }

		/// <summary>
		/// Gets or sets reportURL
		/// </summary>
		public string reportURL { get; set; }

		/// <summary>
		/// Gets or sets scanURL
		/// </summary>
		public string scanURL { get; set; }

		/// <summary>
		/// Gets or sets bkupURL
		/// </summary>
		public string bkupURL { get; set; }

		/// <summary>
		/// Gets or sets cmdURL
		/// </summary>
		public string cmdURL { get; set; }


		/// <summary>
		/// Gets or sets capture
		/// </summary>
		public string capture { get; set; }

		/// <summary>
		/// Gets or sets captureMode
		/// </summary>
		public string captureMode { get; set; }

		/// <summary>
		/// Gets or sets requestTimeoutValue
		/// </summary>
		public string requestTimeoutValue { get; set; }

		/// <summary>
		/// Gets or sets callHomeTimeoutMode
		/// </summary>
		public string callHomeTimeoutMode { get; set; }

		/// <summary>
		/// Gets or sets callHomeTimeoutData
		/// </summary>
		public string callHomeTimeoutData { get; set; }

		/// <summary>
		/// Gets or sets dynCodeFormat
		/// </summary>
		public string[] dynCodeFormat { get; set; }

		/// <summary>
		/// Gets or sets cmdChkInt
		/// </summary>
		public string cmdChkInt { get; set; }

		/// <summary>
		/// Gets or sets revId
		/// </summary>
		public string revId { get; set; }

		// ReSharper restore InconsistentNaming

		/// <summary>
		/// Gets or sets errorLog
		/// </summary>
		public string[] errorLog { get; set; }

		/////// <summary>
		/////// Gets or sets security - Not used by Sinbon, left in the class for IPS support
		/////// </summary>
		////[Obsolete("Remove when IPS support is removed",false)]
		////public int? security { get; set; }

		/// <summary>
		/// Gets or sets wpaPSK
		/// </summary>
		/*public string wpaPSK { get; set; }

		/// <summary>
		/// Gets or sets ssid
		/// </summary>
		public string ssid { get; set; }*/

		/*public override string ToString()
		{
			return string.Format("[DeviceStatus bkupURL: {0}, callHomeTimeoutData: {1}, callHomeTimeoutMode: {2}, capture: {3}, captureMode: {4}, cmdChkInt: {5}, cmdURL: {6}, dynCodeFormat: {7}, errorLog: {8}, intSerial: {9}, reportURL: {10}, requestTimeoutValue: {11}, revId: {12}, scanURL: {13},  ssid: {14}, startURL: {15}, wpaPSK: {16} ]", bkupURL, callHomeTimeoutData, callHomeTimeoutMode, capture, captureMode, cmdChkInt, cmdURL, dynCodeFormat, errorLog, intSerial, reportURL, requestTimeoutValue, revId, scanURL,  ssid, startURL, "*");
		}*/
	}
}

