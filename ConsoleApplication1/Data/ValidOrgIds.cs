using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ConsoleApplication1.HTTP
{
    class ValidOrgIds
    {
        static List<string> fullList;
        internal static List<string> getAll()
        {
            populateList();
            return fullList;
        }

        private static void populateList()
        {
            fullList = new List<string>();
            fullList.Add("42");
            fullList.Add("2249");
            fullList.Add("44");
            fullList.Add("43");
            fullList.Add("2248");
            fullList.Add("38");
        }

        internal static bool isValid(string i)
        {
            populateList();
            return fullList.Contains(i);
        }
    }
}
