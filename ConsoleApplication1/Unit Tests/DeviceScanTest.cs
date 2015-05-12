using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using NUnit.Framework;

namespace ConsoleApplication1.Unit_Tests
{
    //[TestClass]
	[TestFixture]
    public class DeviceScanTest
    {
        static Uri testServer = ServerUris.getLatest();

        //[TestMethod]
		[Test]
        public async Task ScanTest()
        {

            DeviceScanJSON testJson = new DeviceScanJSON();
            testJson.i = ValidSerialNumbers.getAll()[1];
            testJson.d = "1289472198573";
            testJson.s = 4;
            DeviceScan testDScan = new DeviceScan(testServer, testJson);

            Test scanTest = new Test(testDScan);

            List<Test> tests = new List<Test>();
            tests.Add(scanTest);

            await Program.buildTests(tests);

            foreach (Test nextTest in Program.getTests())
            {
                Assert.AreEqual(nextTest.getExpectedResult(), nextTest.getActualResult());
            }
        }
    }
}
