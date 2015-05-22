using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;

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

        private static void populateList()
        {
            try
            {
                StreamReader reader = new StreamReader("../../Data/ValidSerialNumbers.txt");
                fullList = new List<string>();
                while (!reader.EndOfStream)
                {
                    fullList.Add(reader.ReadLine());
                }
            }
            catch (IOException e)
            {
                Console.WriteLine("Failed to load serial numbers!");
            }
        }



        internal static bool isValid(string i)
        {
            populateList();
            return fullList.Contains(i);
        }
    }
}
