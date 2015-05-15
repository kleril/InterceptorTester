﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using NUnit.Framework;
using System.IO;

namespace ConsoleApplication1
{
	[TestFixture]
    public class ICmdTest
    {
        static Uri testServer = ServerUris.getLatest();

		static float lessThan900 = 0;

		static float percentage;

        static float avgTime = -1;
        static float minTime = 9999999999999;
        static float maxTime = -1;
        static int reps = 1;
		public const int maxReps = 50;
		static int[] data = new int[maxReps];


        static StreamWriter results;

        static string outputFile = "../../../logs/performanceTest" + DateTime.Now.ToFileTime() + ".txt";

        [TestFixtureSetUp]
        public void setup()
        {
            FileStream stream;
            stream = File.Create(outputFile);
            results = new StreamWriter(stream);
        }

        [TestFixtureTearDown]
        public void tearDown()
        {
			int index = (maxReps * 95 / 100) - 1;
			int percentile = data[index];
			results.WriteLine("95% of the tests take less than " + percentile + "ms");
			percentage = (lessThan900 / maxReps) * 100;
			results.WriteLine(percentage + "% of the tests take less than 900ms");
			results.WriteLine("Average Time: " + avgTime);
            results.WriteLine("Minimum Time: " + minTime);
            results.WriteLine("Maximum Time: " + maxTime);
            results.Close();
        }

        [Test, Repeat(maxReps)]
        public async Task performanceTest()
        {
            System.Diagnostics.Stopwatch timer = new System.Diagnostics.Stopwatch();

            ICmd validICmd = new ICmd(testServer, ValidSerialNumbers.getAll()[0]);

            Test validTest = new Test(validICmd);
            validTest.setTestName("ValidSerial");


            List<Test> tests = new List<Test>();
            tests.Add(validTest);

            timer.Start();
            await Program.buildTests(tests);
            timer.Stop();
            int time = timer.Elapsed.Milliseconds;
            if (avgTime < 0)
            {
                avgTime = time;
            }
            else
            {
                avgTime = (avgTime * (reps - 1) / reps) + (time / reps);
            }
			data[reps - 1] = time;

            reps += 1;
            if (time < minTime)
            {
                minTime = time;
            }
            if (time > maxTime)
            {
                maxTime = time;
            }
			if (time < 900) 
			{
				lessThan900++;
			}

            results.WriteLine("Test Time: " + time);

            foreach (Test nextTest in Program.getTests())
            {
                Assert.AreEqual(nextTest.getExpectedResult(), nextTest.getActualResult());
            }

            if (reps == maxReps+1)
            {
                Assert.LessOrEqual(avgTime, 900);
                Console.Write("Response time is OK");
            }
        }

        public async Task ValidSerial()
        {
            
            //Valid
            ICmd validICmd = new ICmd(testServer, ValidSerialNumbers.getAll()[0]);

            Test validTest = new Test(validICmd);
			validTest.setTestName("ValidSerial");


            List<Test> tests = new List<Test>();
            tests.Add(validTest);

            await Program.buildTests(tests);

            foreach (Test nextTest in Program.getTests())
            {
                Assert.AreEqual(nextTest.getExpectedResult(), nextTest.getActualResult());
            }
        }

		[Test]
        public async Task InvalidSerial()
        {
            //Invalid
            ICmd invalidICmd = new ICmd(testServer, "BORSHT");
            Test invalidTest = new Test(invalidICmd);
			invalidTest.setTestName("BadSerial");

            List<Test> tests = new List<Test>();
            tests.Add(invalidTest);
            
            await Program.buildTests(tests);
            foreach (Test nextTest in Program.getTests())
            {
                Console.WriteLine(nextTest.getOperation().getUri());
                Assert.AreEqual(nextTest.getExpectedResult(), nextTest.getActualResult());
            }
        }

        [Test]
        public async Task MissingSerial()
        {
            //Missing
            ICmd missingICmd = new ICmd(testServer, null);
            Test missingTest = new Test(missingICmd);
			missingTest.setTestName("EmptySerial");


            List<Test> tests = new List<Test>();
            tests.Add(missingTest);

            await Program.buildTests(tests);

            foreach (Test nextTest in Program.getTests())
            {
                Console.WriteLine(nextTest.getOperation().getUri());
                Assert.AreEqual(nextTest.getExpectedResult(), nextTest.getActualResult());
            }
        }

        [Test]
        public async Task NoQuery()
        {
            //Missing
            ICmd missingICmd = new ICmd(testServer, null);
            missingICmd.noQuery = true;
            Test missingTest = new Test(missingICmd);
			missingTest.setTestName("NoQuery");


            List<Test> tests = new List<Test>();
            tests.Add(missingTest);

            await Program.buildTests(tests);

            foreach (Test nextTest in Program.getTests())
            {
                Console.WriteLine(nextTest.getOperation().getUri());
                Assert.AreEqual(nextTest.getExpectedResult(), nextTest.getActualResult());
            }
        }
    }
}
