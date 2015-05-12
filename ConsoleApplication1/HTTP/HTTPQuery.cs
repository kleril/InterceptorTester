using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ConsoleApplication1.HTTP;

namespace ConsoleApplication1
{
    //Handles URL queries
    class HTTPQuery
    {
        QueryParameter param;
        string value;

        public HTTPQuery(QueryParameter queryParam, string queryValue)
        {
            param = queryParam;
            value = queryValue;
        }

        //Unimplemented types will fail
        //Maybe make this throw an error of some sort if false?
        public bool isValid()
        {
            switch (param)
            {
                //TODO: Find out a better way to determine IDs - existence != validity
                case QueryParameter.i:
                    foreach (string nextSerialNumber in ValidSerialNumbers.getAll())
                    {
                        if (value == null)
                        {
                            return false;
                        }
                        if (value.Equals(nextSerialNumber))
                        {
                            return true;
                        }
                    }
                    Console.WriteLine("Invalid device serial number");
                    return false;

                case QueryParameter.intId:
                    foreach(string nextId in ValidIntIds.getAll())
                    {
                        if (value == null)
                        {
                            return false;
                        }
                        if (value.Equals(nextId))
                        {
                            return true;
                        }
                    }
                    return false;

                case QueryParameter.locId:
                    foreach (string nextId in ValidLocIds.getAll())
                    {
                        if (value == null)
                        {
                            return false;
                        }
                        if (value.Equals(nextId))
                        {
                            return true;
                        }
                    }
                    return false;

                case QueryParameter.orgId:
                    foreach (string nextId in ValidOrgIds.getAll())
                    {
                        if (value == null)
                        {
                            return false;
                        }
                        if (value.Equals(nextId))
                        {
                            return true;
                        }
                    }
                    return false;

                default:
                    Console.WriteLine("Query is not of a valid type!");
                    return false;
            }
        }

        /// <summary>
        /// Returns a string formatted to be appended to a URL.
        /// </summary>
        /// <returns>URI ready string</returns>
        public override string ToString()
        {
            string temp = "";
            temp = temp + "?";
            temp = temp + param;
            temp = temp + "=";
            temp = temp + value;
            return temp;
        }
    }
}
