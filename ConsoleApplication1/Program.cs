﻿using System;
using System.Security.Cryptography.X509Certificates;
using System.IO;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Threading.Tasks;
using System.Text;
using System.Timers;
using Newtonsoft.Json.Linq;
using System.Collections.Generic;

namespace ConsoleApplication1{

    class Program
    {
        static List<string> serialNumbers;

        static List<Test> tests;

        static Timer time;
        static int seconds;

        static StreamWriter results;

        //Output format (by column):
        //Test
        //Expected value
        //Actual value
        //Time elapsed (in deciseconds)
        //Pass/Fail
        static string outputFile = "testResults.txt";

        static X509Certificate cert;

        public static void Main()
        {
            Console.WriteLine("Try giving the program some actual tests to run.");
			buildTests(tests);
        }

        public static async Task buildTests(List<Test> uTests)
        {
            //Init globals
            FileStream append = File.Open(outputFile, FileMode.Append);
            results = new StreamWriter(append);
            tests = new List<Test>();
            serialNumbers = ValidSerialNumbers.getAll();
            results.WriteLine("Starting Tests! Current time:" + DateTime.Now.ToString());
            try {cert = X509Certificate.CreateFromCertFile("C../../Data/mycert.cer");}
            catch (Exception e) { Console.WriteLine("Failed to load SSL Cert"); }
            //Setup vars
            seconds = 0;

            //Timer ticks once every decisecond (100 miliseconds)
            time = new Timer(100);
            // Hook up the Elapsed event for the timer. 
            time.Elapsed += OnTimedEvent;
            time.Enabled = true;

            //Load and run all test cases
            tests = uTests;

            foreach (Test nextTest in tests)
            {
                results.WriteLine(nextTest.ToString());
                await runTest(nextTest);


            }

            //Shut 'er down!
            Console.WriteLine("Tests complete!");
            Console.WriteLine("Closing writer...");
            results.Close();
            Console.WriteLine("Writer closed!");
        }

        //Do test, output results to file.
        public static async Task runTest(Test currentTest)
        {
            //Get start time
            int startTime = seconds;
            Console.WriteLine("Test starting");
            //Do tests
            await testType(currentTest);
            Console.WriteLine("Test ending");
            //Get end time
            int endTime = seconds;
            int timeDelta = endTime - startTime;
            if (results != null)
            {
                //Output results
                //Test
                results.Write(currentTest.ToString());
                clm();
                //Expected value
                results.Write(currentTest.getExpectedResult());
                clm();
                //Actual value
                results.Write(currentTest.getActualResult());
                clm();
                //Time elapsed (in seconds)
                results.Write(timeDelta);
                clm();
                //Pass/Fail
                results.Write(currentTest.result());
                //Carriage return (set up next line)
                results.WriteLine();
                results.WriteLine("Input URI");
                results.WriteLine(currentTest.getOperation().getUri());
                results.WriteLine("Expected result: " + currentTest.getOperation().getExpectedResult());
                try
                {
                    results.WriteLine("Input JSON");
                    results.WriteLine(currentTest.getOperation().getJson().ToString());
                }
                catch (Exception e)
                {
                    results.WriteLine("No JSON attached to this operation");
                }
            }
        }

        static async Task testType (Test currentTest)
        {
            KeyValuePair<JObject, string> result;
            results.WriteLine("Test results:");
            switch (currentTest.ToString())
            {
                case "iCmd":
                    result = await RunGetAsync(currentTest.getOperation().getUri());
                    currentTest.setActualResult(result.Key.GetValue("StatusCode").ToString());
                    Console.WriteLine(result.Value + " Is the result of the iCmd test");
                    results.WriteLine(result.ToString());
                    break;
                case "DeviceScan":
                    result = await RunPostAsync(currentTest.getOperation().getUri(), currentTest.getOperation().getJson());
                    currentTest.setActualResult(result.Key.GetValue("StatusCode").ToString());
                    Console.WriteLine(result.Value + "Is the result of the DeviceScan test");
                    results.WriteLine(result.ToString());
                    break;
                case "DeviceSetting":
                    result = await RunGetAsync(currentTest.getOperation().getUri());
                    currentTest.setActualResult(result.Key.GetValue("StatusCode").ToString());
                    Console.WriteLine(result.Value + " Is the result of the DeviceSetting test");
                    results.WriteLine(result.ToString());
                    break;
                case "DeviceBackup":
                    result = await RunPostAsync(currentTest.getOperation().getUri(), currentTest.getOperation().getJson());
                    currentTest.setActualResult(result.Key.GetValue("StatusCode").ToString());
                    Console.WriteLine(result.Value + "Is the result of the DeviceBackup test");
                    results.WriteLine(result.ToString());
                    break;
                case "DeviceStatus":
                    result = await RunPostAsync(currentTest.getOperation().getUri(), currentTest.getOperation().getJson());
                    currentTest.setActualResult(result.Key.GetValue("StatusCode").ToString());
                    Console.WriteLine(result.Value + "Is the result of the DeviceStatus test");
                    results.WriteLine(result.ToString());
                    break;
               default:
                    Console.WriteLine("Unrecognized test type!");
                    Console.WriteLine(currentTest.ToString());
                    break;
            }
        }

        //GET call
        static async Task<KeyValuePair<JObject, string>> RunGetAsync(Uri qUri)
        {
            // ... Use HttpClient.
            try
            {
                //TODOIF: If http does not allow inclusion of certificates, create secure versions of all calls
                //TODO: Implement client certificate behaviour (for https)
                //WebRequestHandler handler = new WebRequestHandler();
                //handler.ClientCertificates.Add(cert);
                
                //For https add handler to client constructor
                using (HttpClient client = new HttpClient())
                using (HttpResponseMessage response = await client.GetAsync(qUri.AbsoluteUri))
                {
                    JObject jResponse = JObject.FromObject(response);
                    string content = await response.Content.ReadAsStringAsync();
                    return new KeyValuePair<JObject, string>(jResponse, content);
                }
            }
            catch (Exception)
            {
                Console.WriteLine("GET request failed.");
                Console.WriteLine("URL: " + qUri.ToString());
                return new KeyValuePair<JObject, string>(null, null);
            }
        }

        //POST call
        static async Task<KeyValuePair<JObject, string>> RunPostAsync(Uri qUri, Object contentToPush)
        {
            try
            {
                // ... Use HttpClient.
                using (HttpClient client = new HttpClient())
                {
                    client.DefaultRequestHeaders.Accept.Clear();
                    client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));

                    // Newtonsoft Json serialization
                    Console.WriteLine(contentToPush.ToString());
                    var upContent = JObject.FromObject(contentToPush);
                    Console.WriteLine(upContent.ToString());
                    var strContent = new System.Net.Http.StringContent(upContent.ToString(), Encoding.UTF8, "application/json");

                    using (HttpResponseMessage response = await client.PostAsync(qUri, strContent))
                    {
                        JObject jResponse = JObject.FromObject(response);
                        string content = await response.Content.ReadAsStringAsync();
                        return new KeyValuePair<JObject, string>(jResponse, content);
                    }
                }
                return new KeyValuePair<JObject, string>(null, null);
            }
            catch (Exception)
            {
                Console.WriteLine("POST request failed.");
                Console.WriteLine("URL: " + qUri.ToString());
                Console.WriteLine("Content: " + contentToPush.ToString());
                return new KeyValuePair<JObject, string>(null, null);
            }
        }

        //PUT call
        static async Task<KeyValuePair<JObject, string>> RunPutAsync(Uri qUri, HttpContent contentToPut)
        {
            try
            {
                // ... Use HttpClient.
                using (HttpClient client = new HttpClient())
                using (HttpResponseMessage response = await client.PutAsync(qUri, contentToPut))
                {
                    JObject jResponse = JObject.FromObject(response);
                    string content = await response.Content.ReadAsStringAsync();
                    return new KeyValuePair<JObject, string>(jResponse, content);
                }
                
            }
            catch (Exception)
            {
                Console.WriteLine("PUT request failed.");
                Console.WriteLine("URL: " + qUri.ToString());
                Console.WriteLine("Content: " + contentToPut.ToString());
                return new KeyValuePair<JObject, string>(null, null);
            }
        }

        //DELETE call
        static async Task<KeyValuePair<JObject, string>> RunDeleteAsync(Uri qUri)
        {
            try
            {
                // ... Use HttpClient.
                using (HttpClient client = new HttpClient())
                using (HttpResponseMessage response = await client.DeleteAsync(qUri))
                {
                    JObject jResponse = JObject.FromObject(response);
                    string content = await response.Content.ReadAsStringAsync();
                    return new KeyValuePair<JObject, string>(jResponse, content);
                }
            }
            catch (Exception)
            {
                Console.WriteLine("DELETE request failed.");
                Console.WriteLine("URL: " + qUri.ToString());
                return new KeyValuePair<JObject, string>(null,null);
            }
        }

        public static List<Test> getTests()
        {
            return tests;
        }

        public static void setTests(List<Test> newTests)
        {
            tests = newTests;
        }

        //Whenever timer interval is reached, increments counter.
        private static void OnTimedEvent(Object source, ElapsedEventArgs e)
        {
            seconds += 1;
        }

        //Adds a comma to the output file (column break)
        private static void clm()
        {
            results.Write(",");
        }
    }
}
