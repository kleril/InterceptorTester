using System.Runtime.Serialization;

namespace ConsoleApplication1
{

        [DataContract]

    public class DeviceSettingsJSON
        {
            
			public bool isValid ()
			{
				if (seqNum != null)
				{
					return true;
				}

				return false;
			}

			[DataMember]
			// ReSharper disable InconsistentNaming
            public string startURL;
            [DataMember]
            public string reportURL;
            [DataMember]
            public string scanURL;
            [DataMember]
            public string bkupURL;
            [DataMember]
            public string cmdURL;
            [DataMember]
            public string capture;
            [DataMember]
            public string captureMode;
            [DataMember]
            public string requestTimeoutValue;
            [DataMember]
            public string callHomeTimeoutMode;
            [DataMember]
            public string callHomeTimeoutData;
            [DataMember]
            public string[] dynCodeFormat;
            [DataMember]
            public string errorLog;
            [DataMember]
            public string wpaPSK;
            [DataMember]
            public string ssid;
            [DataMember]
            public string cmdChkInt;
            [DataMember]
            public string cTime;
            [DataMember]
            public string seqNum;
            // ReSharper restore InconsistentNaming
        }



}