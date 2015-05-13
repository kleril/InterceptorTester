using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using NUnit.Framework;

namespace ConsoleApplication1
{
	[TestFixture]
	public class DeviceScanTest
	{
		static Uri testServer = ServerUris.getLatest();


		// simple scan code

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
			scanTest.setTestName("ValidSingleScanSimple");

			List<Test> tests = new List<Test>();
			tests.Add(scanTest);

			await Program.buildTests(tests);

			foreach (Test nextTest in Program.getTests())
			{
				Assert.AreEqual(nextTest.getExpectedResult(), nextTest.getActualResult());
			}            
		}

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
			scanTest.setTestName("InvalidSingleScanSimple");


			List<Test> tests = new List<Test>();
			tests.Add(scanTest);

			await Program.buildTests(tests);

			foreach (Test nextTest in Program.getTests())
			{
				Assert.AreEqual(nextTest.getExpectedResult(), nextTest.getActualResult());
			}     
		}

		[Test]
		// Bad Serial
		public async Task InvalidSerialSimple()
		{
			DeviceScanJSON testJson = new DeviceScanJSON ();
			testJson.i = "BAD SERIAL";
			testJson.d = "1289472198573";
			testJson.b = null;
			testJson.s = 4;
			DeviceScan testDScan = new DeviceScan(testServer, testJson);

			Test scanTest = new Test(testDScan);
			scanTest.setTestName("InvalidSerialSimple");


			List<Test> tests = new List<Test>();
			tests.Add(scanTest);

			await Program.buildTests(tests);

			foreach (Test nextTest in Program.getTests())
			{
				Assert.AreEqual(nextTest.getExpectedResult(), nextTest.getActualResult());
			}  
		}

		[Test]
		// No Serial(Empty String)
		public async Task EmptySerialSimple()
		{
			DeviceScanJSON testJson = new DeviceScanJSON ();
			testJson.i = "";
			testJson.d = "1289472198573";
			testJson.b = null;
			testJson.s = 4;
			DeviceScan testDScan = new DeviceScan(testServer, testJson);

			Test scanTest = new Test(testDScan);
			scanTest.setTestName("EmptySerialSimple");


			List<Test> tests = new List<Test>();
			tests.Add(scanTest);

			await Program.buildTests(tests);

			foreach (Test nextTest in Program.getTests())
			{
				Assert.AreEqual(nextTest.getExpectedResult(), nextTest.getActualResult());
			}  
		}



		[Test]
		// No Serial(Null)
		public async Task NullSerialSimple()
		{
			DeviceScanJSON testJson = new DeviceScanJSON ();
			testJson.i = null;
			testJson.d = "1289472198573";
			testJson.b = null;
			testJson.s = 4;
			DeviceScan testDScan = new DeviceScan(testServer, testJson);

			Test scanTest = new Test(testDScan);
			scanTest.setTestName("NullSerialSimple");


			List<Test> tests = new List<Test>();
			tests.Add(scanTest);

			await Program.buildTests(tests);

			foreach (Test nextTest in Program.getTests())
			{
				Assert.AreEqual(nextTest.getExpectedResult(), nextTest.getActualResult());
			}  
		}

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
			scanTest.setTestName("LOValidScansSimple");


			List<Test> tests = new List<Test>();
			tests.Add(scanTest);

			await Program.buildTests(tests);

			foreach (Test nextTest in Program.getTests())
			{
				Assert.AreEqual(nextTest.getExpectedResult(), nextTest.getActualResult());
			}            
		}

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
			scanTest.setTestName("ValInvalScansSimple");


			List<Test> tests = new List<Test>();
			tests.Add(scanTest);

			await Program.buildTests(tests);

			foreach (Test nextTest in Program.getTests())
			{
				Assert.AreEqual(nextTest.getExpectedResult(), nextTest.getActualResult());
			}            
		}

        //Dynamic

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
			scanTest.setTestName("ValidSingleScanDyn");


			List<Test> tests = new List<Test> ();
			tests.Add (scanTest);

			await Program.buildTests (tests);

			foreach (Test nextTest in Program.getTests()) 
			{
				Assert.AreEqual (nextTest.getExpectedResult (), nextTest.getActualResult ());
			}
		}

		[Test]
		// Valid Call Home Scan
		public async Task ValidCH()
		{
			DeviceScanJSON testJson = new DeviceScanJSON ();
			testJson.i = ValidSerialNumbers.getAll () [1];
			testJson.d = "~21/*CH*055577520928";
			testJson.b = null;
			testJson.s = 4;
			DeviceScan testDScan = new DeviceScan (testServer, testJson);

			Test scanTest = new Test (testDScan);
			scanTest.setTestName("ValidCH");


			List<Test> tests = new List<Test> ();
			tests.Add (scanTest);

			await Program.buildTests (tests);

			foreach (Test nextTest in Program.getTests()) {
				Assert.AreEqual (nextTest.getExpectedResult (), nextTest.getActualResult ());
			}
		}

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
			scanTest.setTestName("InvalidSingleScanDyn");


			List<Test> tests = new List<Test> ();
			tests.Add (scanTest);

			await Program.buildTests (tests);

			foreach (Test nextTest in Program.getTests()) {
				Assert.AreEqual (nextTest.getExpectedResult (), nextTest.getActualResult ());
			}
		}

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
			scanTest.setTestName("InvalidSerialDyn");


			List<Test> tests = new List<Test> ();
			tests.Add (scanTest);

			await Program.buildTests (tests);

			foreach (Test nextTest in Program.getTests()) {
				Assert.AreEqual (nextTest.getExpectedResult (), nextTest.getActualResult ());
			}
		}


		[Test]
		// No Serial (Empty Sting)
		public async Task EmptySerialDyn()
		{
			DeviceScanJSON testJson = new DeviceScanJSON ();
			testJson.i = "";
			testJson.d = "~20/90210|";
			testJson.b = null;
			testJson.s = 4;
			DeviceScan testDScan = new DeviceScan (testServer, testJson);

			Test scanTest = new Test (testDScan);
			scanTest.setTestName("EmptySerialDyn");


			List<Test> tests = new List<Test> ();
			tests.Add (scanTest);

			await Program.buildTests (tests);

			foreach (Test nextTest in Program.getTests()) {
				Assert.AreEqual (nextTest.getExpectedResult (), nextTest.getActualResult ());
			}
		}

		[Test]
		// No Serial (Null)
		public async Task NullSerialDyn()
		{
			DeviceScanJSON testJson = new DeviceScanJSON ();
			testJson.i = null;
			testJson.d = "~20/90210|";
			testJson.b = null;
			testJson.s = 4;
			DeviceScan testDScan = new DeviceScan (testServer, testJson);

			Test scanTest = new Test (testDScan);
			scanTest.setTestName("NullSerialDyn");


			List<Test> tests = new List<Test> ();
			tests.Add (scanTest);

			await Program.buildTests (tests);

			foreach (Test nextTest in Program.getTests()) {
				Assert.AreEqual (nextTest.getExpectedResult (), nextTest.getActualResult ());
			}
		}

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
			scanTest.setTestName("LOValidScansDyn");


			List<Test> tests = new List<Test> ();
			tests.Add (scanTest);

			await Program.buildTests (tests);

			foreach (Test nextTest in Program.getTests()) {
				Assert.AreEqual (nextTest.getExpectedResult (), nextTest.getActualResult ());
			}
		}

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
			scanTest.setTestName("ValInvalScansDyn");

		
			List<Test> tests = new List<Test> ();
			tests.Add (scanTest);

			await Program.buildTests (tests);

			foreach (Test nextTest in Program.getTests()) {
				Assert.AreEqual (nextTest.getExpectedResult (), nextTest.getActualResult ());
			}
		}



		// Combined

		[Test]
		// List of Valid Simple and Dynamic Code Scans 
		public async Task ValidScansSimDyn()
		{
			DeviceScanJSON testJson = new DeviceScanJSON ();
			testJson.i = ValidSerialNumbers.getAll () [1];
			testJson.d = null;
			string[] scanData = new string[4];
			scanData [0] = "~20/0|";
			scanData [1] = "123456789";
			scanData [2] = "~20/2|";
			scanData [3] = "987654321";
			testJson.b = scanData;
			testJson.s = 4;
			DeviceScan testDScan = new DeviceScan (testServer, testJson);

			Test scanTest = new Test (testDScan);
			scanTest.setTestName("ValidScansSimDyn");


			List<Test> tests = new List<Test> ();
			tests.Add (scanTest);

			await Program.buildTests (tests);

			foreach (Test nextTest in Program.getTests()) {
				Assert.AreEqual (nextTest.getExpectedResult (), nextTest.getActualResult ());
			}
		}

		[Test]
		// Mixed of Valid and Invalid Scans
		public async Task ValInvalScansSimDyn()
		{
			DeviceScanJSON testJson = new DeviceScanJSON ();
			testJson.i = ValidSerialNumbers.getAll () [1];
			testJson.d = null;
			string[] scanData = new string[4];
			scanData [0] = "~20/0|";
			scanData [1] = "123456789";
			scanData [2] = "~20/noendingbar";
			scanData [3] = "qwertyuiopasdfghjklzxcvbnmqwertyuiopasdfghjklzxcvbnmqwertyuiopasdfghjklzxcvbnmqwertyuiopasdfghjklzxcvbnmqwertyuiopasdfghjklzxcvbnm";;
			testJson.b = scanData;
			testJson.s = 4;
			DeviceScan testDScan = new DeviceScan (testServer, testJson);

			Test scanTest = new Test (testDScan);
			scanTest.setTestName("ValInvalScansSimDyn");


			List<Test> tests = new List<Test> ();
			tests.Add (scanTest);

			await Program.buildTests (tests);

			foreach (Test nextTest in Program.getTests()) {
				Assert.AreEqual (nextTest.getExpectedResult (), nextTest.getActualResult ());
			}
		}
	}
}


