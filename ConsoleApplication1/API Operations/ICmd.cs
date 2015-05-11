using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ConsoleApplication1
{
    class ICmd : APIOperation
    {

        public ICmd(Uri server, string serialNum)
        {
            opHost = server;
            hOp = HTTPOperation.GET;
            opQuery = new HTTPQuery(QueryParameter.i, serialNum);
        }

        //TODO: Clean this up, find out proper responses.
        public override string getExpectedResult()
        {
            if (this.opQuery.isValid())
            {
                return "200";
            }
            return "400";
        }

        public override string ToString()
        {
            return "iCmd";
        }
        
        public override Uri getUri()
        {
            return new Uri(opHost, "/api/iCmd/" + opQuery.ToString());
        }

        public override object getJson()
        {
            return null;
        }
    }
}
