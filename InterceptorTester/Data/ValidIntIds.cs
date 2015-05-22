using System;
using System.IO;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ConsoleApplication1.HTTP
{
    class ValidIntIds
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
                StreamReader reader = new StreamReader("../../Data/ValidIntIds.txt");
                fullList = new List<string>();
                while (!reader.EndOfStream)
                {
                    fullList.Add(reader.ReadLine());
                }
            }
            catch (IOException e)
            {
                Console.WriteLine("Failed to load IntIds!");
            }
        }

        internal static bool isValid(string i)
        {
            populateList();
            return fullList.Contains(i);
        }
    }
}
