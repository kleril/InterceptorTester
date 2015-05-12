using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using NUnit.Framework;

namespace ConsoleApplication1
{
	[TestFixture]
    public class ICmdTest
    {
        static Uri testServer = ServerUris.getLatest();

		[Test]
        public async Task ValidSerial()
        {
            //Valid
            ICmd validICmd = new ICmd(testServer, ValidSerialNumbers.getAll()[0]);

            Test validTest = new Test(validICmd);

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
            List<Test> tests = new List<Test>();
            tests.Add(invalidTest);
            
            await Program.buildTests(tests);
            foreach (Test nextTest in Program.getTests())
            {
                Assert.AreEqual(nextTest.getExpectedResult(), nextTest.getActualResult());
            }
        }

		[Test]
        public async Task MissingSerial()
        {
            //Missing
            ICmd missingICmd = new ICmd(testServer, null);
            Test missingTest = new Test(missingICmd);

            List<Test> tests = new List<Test>();
            tests.Add(missingTest);

            await Program.buildTests(tests);

            foreach (Test nextTest in Program.getTests())
            {
                Assert.AreEqual(nextTest.getExpectedResult(), nextTest.getActualResult());
            }
        }
    }
}
