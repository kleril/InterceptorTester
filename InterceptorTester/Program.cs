using System;
using System.IO;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Threading.Tasks;
using System.Text;
using System.Timers;
using Newtonsoft.Json.Linq;
using System.Collections.Generic;
using System.Security.Cryptography.X509Certificates;
using ICSharpCode.SharpZipLib.Zip;
using ICSharpCode.SharpZipLib.Core;

namespace ConsoleApplication1{

    class Program
    {
		static string certPath = "../../Data/unittestcert.pfx";
        static string certPass = "unittest";

        // Create a collection object and populate it using the PFX file
        static X509Certificate cert;

        static List<Test> tests;

        static Timer time;
        static int seconds;

        static StreamWriter results;

		static string outputFile = "../../../logs/testResults.txt";

        public static void Main()
        {

			Console.WriteLine("Try giving the program some actual tests to run.");
            //Valid
			/*
            ICmd validICmd = new ICmd(ServerUris.getLatestSecure(), ValidSerialNumbers.getAll()[0]);

            Test validTest = new Test(validICmd);
            validTest.setTestName("ValidSerial");


            List<Test> tests = new List<Test>();
            tests.Add(validTest);
            */

			buildTests(tests);

        }

        public static async Task buildTests(List<Test> uTests)
        {
            //Init globals
            try
            {
                cert = new X509Certificate(certPath, certPass);
                Console.WriteLine("SLL certificate created successfully");
			}
			catch(Exception e)
            {
                Console.WriteLine("Could not initialize SLL certificate");
                Console.WriteLine(e.ToString());
            }

			FileStream stream;
            try
            {
                if (File.Exists(outputFile))
                {
                    stream = File.Open(outputFile, FileMode.Append);
                    Console.WriteLine("Streaming into append mode");
                }
                else
                {
                    stream = File.Create(outputFile);
                    Console.WriteLine("Streaming into new file");
                }


                results = new StreamWriter(stream);
            }
            catch (IOException e)
            {
                results = new StreamWriter("../../../logs/OSXtestResults" + DateTime.Now.ToFileTime() + ".txt");

                Console.WriteLine("Could not initialize logging");
                Console.WriteLine(e);
            }
            tests = new List<Test>();
            results.WriteLine("Starting Tests! Current time: " + DateTime.Now.ToString());
            Console.WriteLine("Setup Complete! Running tests.");
            
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
				results.WriteLine("Test: " + nextTest.ToString() + " " + nextTest.getTestName());
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
				results.WriteLine("Summary:");
				results.WriteLine("Current test: " + currentTest.ToString() + " " + currentTest.getTestName());
                //clm();

				try
				{
					results.WriteLine("Input JSON:");
					results.WriteLine(currentTest.getOperation().getJson().ToString());
				}
				catch (Exception)
				{
					results.WriteLine("No JSON attached to this operation");
				}

				results.WriteLine("Input URI: " + currentTest.getOperation().getUri());

                //Expected value
                results.WriteLine("Expected result: " + currentTest.getExpectedResult());
                //clm();
                //Actual value
                results.WriteLine("Actual result: " + currentTest.getActualResult());
                //clm();
                //Time elapsed (in seconds)
                results.WriteLine("Time elapsed: " + timeDelta + "s");
                //clm();
                //Pass/Fail
                results.WriteLine("Test result: " + currentTest.result());
				results.WriteLine ();
            }
        }

        //TODOIF: Tweak console output to be a little clearer. Console is made redundant by logs, but it could be useful.
        static async Task testType (Test currentTest)
        {
            KeyValuePair<JObject, string> result;
            results.WriteLine("Raw test results:");
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

				WebRequestHandlerWithClientcertificates handler = new WebRequestHandlerWithClientcertificates();
                handler.ClientCertificates.Add(cert);
                using (HttpClient client = new HttpClient(handler))
                using (HttpResponseMessage response = await client.GetAsync(qUri.AbsoluteUri))
                {
                    JObject jResponse = JObject.FromObject(response);
                    string content = await response.Content.ReadAsStringAsync();
                    return new KeyValuePair<JObject, string>(jResponse, content);
                }
            }
            catch (Exception e)
            {
				Console.WriteLine("GET request failed: " + e.ToString());
                Console.WriteLine("URL: " + qUri.ToString());
                Console.WriteLine(e);
                return new KeyValuePair<JObject, string>(null, null);
            }
        }

        //POST call
        static async Task<KeyValuePair<JObject, string>> RunPostAsync(Uri qUri, Object contentToPush)
        {
            try
            {
                // ... Use HttpClient.

				WebRequestHandlerWithClientcertificates handler = new WebRequestHandlerWithClientcertificates();
                handler.ClientCertificates.Add(cert);
                using (HttpClient client = new HttpClient(handler))
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
            catch (Exception e)
            {
                Console.WriteLine("POST request failed.");
                Console.WriteLine("URL: " + qUri.ToString());
                Console.WriteLine("Content: " + contentToPush.ToString());
                Console.WriteLine(e);
                return new KeyValuePair<JObject, string>(null, null);
            }
        }

        //PUT call
        static async Task<KeyValuePair<JObject, string>> RunPutAsync(Uri qUri, HttpContent contentToPut)
        {
            try
            {
                // ... Use HttpClient.
				WebRequestHandlerWithClientcertificates handler = new WebRequestHandlerWithClientcertificates();
                handler.ClientCertificates.Add(cert);
                using (HttpClient client = new HttpClient(handler))
                using (HttpResponseMessage response = await client.PutAsync(qUri, contentToPut))
                {
                    JObject jResponse = JObject.FromObject(response);
                    string content = await response.Content.ReadAsStringAsync();
                    return new KeyValuePair<JObject, string>(jResponse, content);
                }
                
            }
            catch (Exception e)
            {
                Console.WriteLine("PUT request failed.");
                Console.WriteLine("URL: " + qUri.ToString());
                Console.WriteLine("Content: " + contentToPut.ToString());
                Console.WriteLine(e);
                return new KeyValuePair<JObject, string>(null, null);
            }
        }

        //DELETE call
        static async Task<KeyValuePair<JObject, string>> RunDeleteAsync(Uri qUri)
        {
            try
            {
                // ... Use HttpClient.
				WebRequestHandlerWithClientcertificates handler = new WebRequestHandlerWithClientcertificates();
                handler.ClientCertificates.Add(cert);
                using (HttpClient client = new HttpClient(handler))
                using (HttpResponseMessage response = await client.DeleteAsync(qUri))
                {
                    JObject jResponse = JObject.FromObject(response);
                    string content = await response.Content.ReadAsStringAsync();
                    return new KeyValuePair<JObject, string>(jResponse, content);
                }
            }
            catch (Exception e)
            {
                Console.WriteLine("DELETE request failed.");
                Console.WriteLine("URL: " + qUri.ToString());
                Console.WriteLine(e);
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
