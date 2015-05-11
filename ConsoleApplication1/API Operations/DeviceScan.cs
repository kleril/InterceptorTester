using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ConsoleApplication1
{
    class DeviceScan : APIOperation
    {
        DeviceScanJSON json;

        public DeviceScan(Uri server, DeviceScanJSON scan)
        {
            opHost = server;
            hOp = HTTPOperation.POST;
            json = scan;
        }

        //TODO: Implement this in a non-shitty way
        public override string getExpectedResult()
        {
            if (json.isValid())
            {
                return "201";
            }
            else
            {
                return "400";
            }
        }

        public override string ToString()
        {
            return "DeviceScan";
        }

        public override Uri getUri()
        {
            return new Uri(opHost, "/api/DeviceScan/");
        }

        public override object getJson()
        {
            return json;
        }
    }
}
