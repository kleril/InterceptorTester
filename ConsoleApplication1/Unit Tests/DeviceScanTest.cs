using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using NUnit.Framework;



namespace ConsoleApplication1
{
	// [TestClass]
	[TestFixture]
	public class DeviceScanTest
	{
		static Uri testServer = ServerUris.getLatest();

		// simple scan code

		// [TestMethod]
		[Test]
		// Valid Single Scan
		public async Task ValidSingleScanSimple()
		{

			DeviceScanJSON testJson = new DeviceScanJSON ();
			testJson.i = ValidSerialNumbers.getAll()[1];
			testJson.d = "1289472198573";
			testJson.b = null;
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

		// [TestMethod]
		[Test]
		// Invalid Single Scan
		public async Task InvalidSingleScanSimple()
		{
			DeviceScanJSON testJson = new DeviceScanJSON ();
			testJson.i = ValidSerialNumbers.getAll()[1];
			testJson.d = "qwertyuiopasdfghjklzxcvbnmqwertyuiopasdfghjklzxcvbnmqwertyuiopasdfghjklzxcvbnmqwertyuiopasdfghjklzxcvbnmqwertyuiopasdfghjklzxcvbnm";
			testJson.b = null;
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

		// [TestMethod]
		[Test]
		// Bad Serial
		public async Task InvalidSerialSimple()
		{
			DeviceScanJSON testJson = new DeviceScanJSON ();
			testJson.i = "BADSERIAL";
			testJson.d = "1289472198573";
			testJson.b = null;
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

		// [TestMethod]
		[Test]
		// No Serial
		public async Task NoSerialSimple()
		{
			DeviceScanJSON testJson = new DeviceScanJSON ();
			testJson.i = null;
			testJson.d = "1289472198573";
			testJson.b = null;
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

		// [TestMethod]
		[Test]
		// List of Valid Scans
		public async Task LOValidScansSimple()
		{
			DeviceScanJSON testJson = new DeviceScanJSON ();
			testJson.i = ValidSerialNumbers.getAll()[1];
			testJson.d = null;
			string[] scanData = new string[4];
			scanData [0] = "0";
			scanData [1] = "1";
			scanData [2] = "2";
			scanData [3] = "3";
			testJson.b = scanData;
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

		// [TestMethod]
		[Test]
		// Mixed of Valid/Invalid Scans
		public async Task ValInvalScansSimple()
		{
			DeviceScanJSON testJson = new DeviceScanJSON ();
			testJson.i = ValidSerialNumbers.getAll()[1];
			testJson.d = null;
			string[] scanData = new string[4];
			scanData [0] = "0";
			scanData [1] = "qwertyuiopasdfghjklzxcvbnmqwertyuiopasdfghjklzxcvbnmqwertyuiopasdfghjklzxcvbnmqwertyuiopasdfghjklzxcvbnmqwertyuiopasdfghjklzxcvbnm";
			scanData [2] = "2";
			scanData [3] = "3";
			testJson.b = scanData;
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

			


		// dynamic scan code

		// [TestMethod]
		[Test]
		// Valid Single Scan
		public async Task ValidSingleScanDyn()
		{
			DeviceScanJSON testJson = new DeviceScanJSON ();
			testJson.i = ValidSerialNumbers.getAll () [1];
			testJson.d = "~20/90210|";
			testJson.b = null;
			testJson.s = 4;
			DeviceScan testDScan = new DeviceScan (testServer, testJson);

			Test scanTest = new Test (testDScan);

			List<Test> tests = new List<Test> ();
			tests.Add (scanTest);

			await Program.buildTests (tests);

			foreach (Test nextTest in Program.getTests()) 
			{
				Assert.AreEqual (nextTest.getExpectedResult (), nextTest.getActualResult ());
			}
		}

		// [TestMethod]
		[Test]
		// Valid Call Home Scan
		public async Task ValidCH()
		{
			DeviceScanJSON testJson = new DeviceScanJSON ();
			testJson.i = ValidSerialNumbers.getAll () [1];
			testJson.d = "~21/*CH*055577520928|";
			testJson.b = null;
			testJson.s = 4;
			DeviceScan testDScan = new DeviceScan (testServer, testJson);

			Test scanTest = new Test (testDScan);

			List<Test> tests = new List<Test> ();
			tests.Add (scanTest);

			await Program.buildTests (tests);

			foreach (Test nextTest in Program.getTests()) {
				Assert.AreEqual (nextTest.getExpectedResult (), nextTest.getActualResult ());
			}
		}

		// [TestMethod]
		[Test]
		// Invalid Scan Data
		public async Task InvalidSingleScanDyn()
		{
			DeviceScanJSON testJson = new DeviceScanJSON ();
			testJson.i = ValidSerialNumbers.getAll () [1];
			testJson.d = "~20|noendingbar";
			testJson.b = null;
			testJson.s = 4;
			DeviceScan testDScan = new DeviceScan (testServer, testJson);

			Test scanTest = new Test (testDScan);

			List<Test> tests = new List<Test> ();
			tests.Add (scanTest);

			await Program.buildTests (tests);

			foreach (Test nextTest in Program.getTests()) {
				Assert.AreEqual (nextTest.getExpectedResult (), nextTest.getActualResult ());
			}
		}

		// [TestMethod]
		[Test]
		// Bad Serial
		public async Task InvalidSerialDyn()
		{
			DeviceScanJSON testJson = new DeviceScanJSON ();
			testJson.i = "BADSERIAL";
			testJson.d = "~20/90210|";
			testJson.b = null;
			testJson.s = 4;
			DeviceScan testDScan = new DeviceScan (testServer, testJson);

			Test scanTest = new Test (testDScan);

			List<Test> tests = new List<Test> ();
			tests.Add (scanTest);

			await Program.buildTests (tests);

			foreach (Test nextTest in Program.getTests()) {
				Assert.AreEqual (nextTest.getExpectedResult (), nextTest.getActualResult ());
			}
		}

		// [TestMethod]
		[Test]
		// No Serial
		public async Task NoSerialDyn()
		{
			DeviceScanJSON testJson = new DeviceScanJSON ();
			testJson.i = null;
			testJson.d = "~20/90210|";
			testJson.b = null;
			testJson.s = 4;
			DeviceScan testDScan = new DeviceScan (testServer, testJson);

			Test scanTest = new Test (testDScan);

			List<Test> tests = new List<Test> ();
			tests.Add (scanTest);

			await Program.buildTests (tests);

			foreach (Test nextTest in Program.getTests()) {
				Assert.AreEqual (nextTest.getExpectedResult (), nextTest.getActualResult ());
			}
		}

		// [TestMethod]
		[Test]
		// List of Valid Scans
		public async Task LOValidScansDyn()
		{
			DeviceScanJSON testJson = new DeviceScanJSON ();
			testJson.i = ValidSerialNumbers.getAll () [1];
			testJson.d = null;
			string[] scanData = new string[4];
			scanData[0] = "~20/0|";
			scanData[1] = "~20/1|";
			scanData[2] = "~20/2|";
			scanData[3] = "~20/3|";
			testJson.b = scanData;
			testJson.s = 4;
			DeviceScan testDScan = new DeviceScan (testServer, testJson);

			Test scanTest = new Test (testDScan);

			List<Test> tests = new List<Test> ();
			tests.Add (scanTest);

			await Program.buildTests (tests);

			foreach (Test nextTest in Program.getTests()) {
				Assert.AreEqual (nextTest.getExpectedResult (), nextTest.getActualResult ());
			}
		}

		// [TestMethod]
		[Test]
		// Mixed of Valid/Invalid Scans
		public async Task ValInvalScansDyn()
		{
			DeviceScanJSON testJson = new DeviceScanJSON ();
			testJson.i = ValidSerialNumbers.getAll () [1];
			testJson.d = null;
			string[] scanData = new string[4];
			scanData [0] = "~20/0|";
			scanData [1] = "~20/noendingbar";
			scanData [2] = "~20/2|";
			scanData [3] = "~20/3|";
			testJson.b = scanData;
			testJson.s = 4;
			DeviceScan testDScan = new DeviceScan (testServer, testJson);

			Test scanTest = new Test (testDScan);
		
			List<Test> tests = new List<Test> ();
			tests.Add (scanTest);

			await Program.buildTests (tests);

			foreach (Test nextTest in Program.getTests()) {
				Assert.AreEqual (nextTest.getExpectedResult (), nextTest.getActualResult ());
			}
		}

	}
}


