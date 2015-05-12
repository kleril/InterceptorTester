using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ConsoleApplication1.HTTP
{
    class ValidLocIds
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
            fullList.Add("32");
        }

        internal static bool isValid(string i)
        {
            populateList();
            return fullList.Contains(i);
        }
    }
}
