using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ConsoleApplication1
{
    class ServerUris
    {
        static List<Uri> UriList;

        internal static List<Uri> getAllUris()
        {
            if (UriList == null)
            {
                buildList();
            }
            return UriList;
        }

        //Get most up-to-date server
        internal static Uri getLatest()
        {
            if (UriList == null)
            {
                buildList();
            }
            return UriList[0];
        }

        //Add new servers here, new ones at the top
        private static void buildList()
        {
            UriList = new List<Uri>();
            UriList.Add(new Uri("http://03fb817764e54af1b96fbafcd93362e2.cloudapp.net/"));
			UriList.Add(new Uri("http://c1c735b6e41a4325897fb74bf2f8927c.cloudapp.net/"));
            UriList.Add(new Uri("http://cozumotesttls.cloudapp.net"));
        }
    }
}
