﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.IO;

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

        internal static Uri getLatestSecure()
        {
            if (UriList == null)
            {
                buildList();
            }
            foreach (Uri next in UriList)
            {
                if (next.ToString().Contains("https"))
                {
                    return next;
                }
            }
            return null;
        }

        //Add new servers here, new ones at the top
        private static void buildList()
        {
            try
            {
                StreamReader reader = new StreamReader("../../Data/ServerUris.txt");
                UriList = new List<Uri>();
                while (!reader.EndOfStream)
                {
                    UriList.Add(new Uri(reader.ReadLine()));
                }
            }
            catch (IOException e)
            {
                Console.WriteLine("Failed to load server Uris!");
            }
        }
    }
}
