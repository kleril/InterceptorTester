using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;

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
            try
            {
                StreamReader reader = new StreamReader("../../Data/ValidOrgIds.txt");
                fullList = new List<string>();
                while (!reader.EndOfStream)
                {
                    fullList.Add(reader.ReadLine());
                }
            }
            catch (IOException e)
            {
                Console.WriteLine("Failed to load OrgIds!");
            }

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
