using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ConsoleApplication1
{
    class ValidSerialNumbers
    {
        static List<string> fullList;
        internal static List<string> getAll()
        {
            populateList();
            return fullList;
        }

        //TODO: Change this so it gets serial numbers from ???
        //i.e. anything but hardcoded
        private static void populateList()
        {
           fullList = new List<string>();
           fullList.Add("D05FB84F1606");
           fullList.Add("2A2A2A2A2A2A");
           fullList.Add("DEADDEADBEEF");
           fullList.Add("D05FB84F2A31");
           fullList.Add("D05FB84F2F8E");
           fullList.Add("D05FB84F2C4B");
        }



        internal static bool isValid(string i)
        {
            populateList();
            return fullList.Contains(i);
        }
    }
}
