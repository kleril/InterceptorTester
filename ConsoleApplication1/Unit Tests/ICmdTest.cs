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

        static float avgTime = -1;
        static int reps = 1;

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
            results.WriteLine("Final Average Time: " + avgTime);
            results.Close();
        }

        [Test, Repeat(50)]
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
            reps += 1;

            results.WriteLine("Test Time: " + time);
            results.WriteLine("Running Average Time: " + avgTime);

            foreach (Test nextTest in Program.getTests())
            {
                Assert.AreEqual(nextTest.getExpectedResult(), nextTest.getActualResult());
            }

            Assert.LessOrEqual(avgTime, 400);
            Assert.LessOrEqual(avgTime, 1000);
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
