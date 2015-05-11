using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

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

        //TODO: set up all param types
        //Unimplemented types will fail
        //Maybe make this throw an error of some sort if false?
        public bool isValid()
        {
            switch (param)
            {
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
                    Console.WriteLine("You didn't set this query type up yet...");
                    return false;

                case QueryParameter.locId:
                    Console.WriteLine("You didn't set this query type up yet...");
                    return false;

                case QueryParameter.orgId:
                    Console.WriteLine("You didn't set this query type up yet...");
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
