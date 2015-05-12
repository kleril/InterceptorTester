using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Runtime.Serialization;

namespace ConsoleApplication1
{
    //TODO: This Class is redundant, either remove it or the one in DeviceBackupJSON

    [DataContract]
    class DeviceBackupItemJSON
    {
        /// <summary>
        /// Interceptor Serial number
        /// </summary>
        [DataMember]
        public string d { get; set; }

        /// <summary>
        /// List of static device scans. Only one of this or "d" is not null
        /// </summary>
        [DataMember]
        public string s { get; set; }
        /// <summary>
        /// A dynamic code device scan. Only one of this or "b" is not null.
        /// </summary>
        [DataMember]
        public DateTime t { get; set; }
        /// <summary>
        /// request sequence number - monotonically increasing until it resets at max value + 1
        /// </summary>
        [DataMember]
        public bool c { get; set; }

        public override string ToString()
        {
            return string.Format("[SequenceDeviceScan d: {0}, s: {1}, t: {2}, c: {3} ]", d,s,t,c);
        }
    }
}
