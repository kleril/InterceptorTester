using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using NUnit.Framework;
using System.IO;
using System.Configuration;
using Nito.AsyncEx;
using System.IO.Compression;

namespace ConsoleApplication1
{
	[TestFixture()]
	public class DeviceBackupTest
	{
        //Globals
        static Uri testServer = new Uri(ConfigurationManager.ConnectionStrings["Server"].ConnectionString);
        static string validSerial = ConfigurationManager.ConnectionStrings["ValidSerial"].ConnectionString;
        static string invalidSerial = ConfigurationManager.ConnectionStrings["InvalidSerial"].ConnectionString;

		[Test()]
		// Valid Serial
		public void ValidSerial()
		{
			BackupItem[] items = new BackupItem[3];
			items[0] = getBackupItem(1);
			items[1] = getBackupItem(2);
			items[2] = getBackupItem(3);

			//BackupJSon
			DeviceBackupJSON json = new DeviceBackupJSON();
            json.i = validSerial;
			json.s = 4;
			json.b = items;

			//BackupOperation
			DeviceBackup operation = new DeviceBackup(testServer, json);

			//Test
			Test backupTest = new Test(operation);
			backupTest.setTestName("ValidSerial");
			List<Test> tests = new List<Test>();
			tests.Add(backupTest);
			AsyncContext.Run(async() => await Program.buildTests(tests));

			foreach (Test nextTest in Program.getTests())
			{
				Assert.AreEqual(nextTest.getExpectedResult(), nextTest.getActualResult());
			}
		}

		[Test()]
		// Valid Single Backup Item
		public void ValidSingleBackupItem()
		{
			BackupItem[] items = new BackupItem[1];
			items[0] = getBackupItem(1);

			//BackupJSon
			DeviceBackupJSON json = new DeviceBackupJSON();
            json.i = validSerial;
			json.s = 4;
			json.b = items;

			//BackupOperation
			DeviceBackup operation = new DeviceBackup(testServer, json);

			//Test
			Test backupTest = new Test(operation);
			backupTest.setTestName("ValidSingleBackupItem");
			List<Test> tests = new List<Test>();
			tests.Add(backupTest);
			AsyncContext.Run(async() => await Program.buildTests(tests));

			foreach (Test nextTest in Program.getTests())
			{
				Assert.AreEqual(nextTest.getExpectedResult(), nextTest.getActualResult());
			}
		}

		[Test()]
		// Invalid Single Backup Item
		public void InvalidSingleBackupItem()
		{
			BackupItem failItem = new BackupItem();

			BackupItem[] failItems = new BackupItem[1];
			failItems[0] = failItem;

			DeviceBackupJSON failJson = new DeviceBackupJSON();
            failJson.i = validSerial;
			failJson.s = 5;
			failJson.b = failItems;

			DeviceBackup failOperation = new DeviceBackup(testServer, failJson);
			Test failingTest = new Test(failOperation);
			failingTest.setTestName("InvalidSingleBackupItem");

			List<Test> tests = new List<Test>();
			tests.Add(failingTest);
			AsyncContext.Run(async() => await Program.buildTests(tests));

			foreach (Test nextTest in Program.getTests())
			{
				Assert.AreEqual(nextTest.getExpectedResult(), nextTest.getActualResult());
			}
		}

		[Test()]
		// Muliple Backup Items with Invalid Backup Item in Them
		public void InvalidBackupItems()
		{
			BackupItem failItem = new BackupItem();

			BackupItem[] failItems = new BackupItem[4];
			failItems[0] = getBackupItem(1);
			failItems[1] = getBackupItem(2);
			failItems[2] = failItem;
			failItems[3] = getBackupItem(3);

			DeviceBackupJSON failJson = new DeviceBackupJSON();
            failJson.i = validSerial;
			failJson.s = 5;
			failJson.b = failItems;

			DeviceBackup failOperation = new DeviceBackup(testServer, failJson);
			Test failingTest = new Test(failOperation);
			failingTest.setTestName("InvalidBackupItems");

			List<Test> tests = new List<Test>();
			tests.Add(failingTest);
			AsyncContext.Run(async() => await Program.buildTests(tests));

			foreach (Test nextTest in Program.getTests())
			{
				Assert.AreEqual(nextTest.getExpectedResult(), nextTest.getActualResult());
			}
		}

		[Test()]
		// Invalid Serial Number
		public void BadSerial()
		{
			BackupItem[] items = new BackupItem[3];
			items[0] = getBackupItem(1);
			items[1] = getBackupItem(2);
			items[2] = getBackupItem(3);

			DeviceBackupJSON serialJson = new DeviceBackupJSON();
			serialJson.i = invalidSerial;
			serialJson.s = 6;
			serialJson.b = items;

			DeviceBackup serialOperation = new DeviceBackup(testServer, serialJson);

			Test serialTest = new Test(serialOperation);
			serialTest.setTestName("BadSerial");

			List<Test> tests = new List<Test>();
			tests.Add(serialTest);
			AsyncContext.Run(async() => await Program.buildTests(tests));

			foreach (Test nextTest in Program.getTests())
			{
				Assert.AreEqual(nextTest.getExpectedResult(), nextTest.getActualResult());
			}
		}

		[Test()]
		// No Backup Items
		public void NoBackupItems()
		{
			BackupItem[] items = new BackupItem[0];

			DeviceBackupJSON emptyJson = new DeviceBackupJSON();
            emptyJson.i = validSerial;
			emptyJson.s = 8;
			emptyJson.b = items;

			DeviceBackup emptyOperation = new DeviceBackup(testServer, emptyJson);
			Test emptyTest = new Test(emptyOperation);
			emptyTest.setTestName("NoBackupItems");


			List<Test> tests = new List<Test>();
			tests.Add(emptyTest);
			AsyncContext.Run(async() => await Program.buildTests(tests));

			foreach (Test nextTest in Program.getTests())
			{
				Assert.AreEqual(nextTest.getExpectedResult(), nextTest.getActualResult());
			}
		}

		[Test()]
		// Input with Serial Number as ""
		public void EmptySerial()
		{
			BackupItem[] items = new BackupItem[3];
			items[0] = getBackupItem(1);
			items[1] = getBackupItem(2);
			items[2] = getBackupItem(3);

			DeviceBackupJSON serialJson = new DeviceBackupJSON();
			serialJson.s = 6;
			serialJson.b = items;
			serialJson.i = "";

			DeviceBackup serialOperation = new DeviceBackup(testServer, serialJson);

			Test serialTest = new Test(serialOperation);
			serialTest.setTestName("EmptySerial");

			List<Test> tests = new List<Test>();
			tests.Add(serialTest);
			AsyncContext.Run(async() => await Program.buildTests(tests));

			foreach (Test nextTest in Program.getTests())
			{
				Assert.AreEqual(nextTest.getExpectedResult(), nextTest.getActualResult());
			}
		}


		[Test()]
		// Input with Null Serial Number
		public void NullSerial()
		{
			BackupItem[] items = new BackupItem[3];
			items[0] = getBackupItem(1);
			items[1] = getBackupItem(2);
			items[2] = getBackupItem(3);

			DeviceBackupJSON serialJson = new DeviceBackupJSON();
			serialJson.s = 6;
			serialJson.b = items;
			serialJson.i = null;

			DeviceBackup serialOperation = new DeviceBackup(testServer, serialJson);

			Test serialTest = new Test(serialOperation);
			serialTest.setTestName("NullSerial");

			List<Test> tests = new List<Test>();
			tests.Add(serialTest);
			AsyncContext.Run(async() => await Program.buildTests(tests));

			foreach (Test nextTest in Program.getTests())
			{
				Assert.AreEqual(nextTest.getExpectedResult(), nextTest.getActualResult());
			}
		}

		[Test()]
		// Scan Code being a Special Dynamic Code
		public void SpecialDynCode()
		{
			BackupItem[] items = new BackupItem[1];
			items[0] = new BackupItem();
			items[0].d = "~123~status=ssid|";
			items[0].s = 442;
			items[0].t = new DateTime(2015, 5, 11, 2, 4, 22, 295);
			items[0].c = false;

			DeviceBackupJSON serialJson = new DeviceBackupJSON();
			serialJson.s = 6;
			serialJson.b = items;
            serialJson.i = validSerial;

			DeviceBackup serialOperation = new DeviceBackup(testServer, serialJson);

			Test serialTest = new Test(serialOperation);
			serialTest.setTestName("SpecialDynCode");

			List<Test> tests = new List<Test>();
			tests.Add(serialTest);
			AsyncContext.Run(async() => await Program.buildTests(tests));

			foreach (Test nextTest in Program.getTests())
			{
				Assert.AreEqual(nextTest.getExpectedResult(), nextTest.getActualResult());
			}
		}


		[Test()]
		// Scan Code being a Dynamic Code and Not Special
		public void NotSpecialDynCode()
		{
			BackupItem[] items = new BackupItem[1];
			items[0] = new BackupItem();
			items[0].d = "~20/12345|";
			items[0].s = 442;
			items[0].t = new DateTime(2015, 5, 11, 2, 4, 22, 295);
			items[0].c = false;

			DeviceBackupJSON serialJson = new DeviceBackupJSON();
			serialJson.s = 6;
			serialJson.b = items;
            serialJson.i = validSerial;

			DeviceBackup serialOperation = new DeviceBackup(testServer, serialJson);

			Test serialTest = new Test(serialOperation);
			serialTest.setTestName("NotSpecialDynCode");

			List<Test> tests = new List<Test>();
			tests.Add(serialTest);
			AsyncContext.Run(async() => await Program.buildTests(tests));

			foreach (Test nextTest in Program.getTests())
			{
				Assert.AreEqual(nextTest.getExpectedResult(), nextTest.getActualResult());
			}
		}


		//TODO: Do this in a cleaner way
		public BackupItem getBackupItem(int i)
		{
			List<BackupItem> items = new List<BackupItem>();
			//BackupItems
			BackupItem item1 = new BackupItem();
			item1.d = "12566132";
			item1.s = 442;
			item1.t = new DateTime(2015, 5, 11, 2, 4, 22, 295);
			item1.c = false;
			BackupItem item2 = new BackupItem();
			item2.d = "534235721";
			item2.s = 442;
			item2.t = new DateTime(2015, 5, 11, 2, 4, 28, 216);
			item2.c = false;
			BackupItem item3 = new BackupItem();
			item3.d = "892535";
			item3.s = 442;
			item3.t = new DateTime(2015, 5, 11, 2, 4, 25, 142);
			item3.c = false;

			items.Add(item1);
			items.Add(item2);
			items.Add(item3);

			return items[i-1];
		}
	}

	[TestFixture()]
	public class DeviceScanTest
    {
        static Uri testServer = new Uri(ConfigurationManager.ConnectionStrings["Server"].ConnectionString);
        static string validSerial = ConfigurationManager.ConnectionStrings["ValidSerial"].ConnectionString;
        static string invalidSerial = ConfigurationManager.ConnectionStrings["InvalidSerial"].ConnectionString;

		// simple scan code

		[Test()]
		// Valid Single Scan
		public void ValidSingleScanSimple()
		{

			DeviceScanJSON testJson = new DeviceScanJSON ();
            testJson.i = validSerial;
			testJson.d = "1289472198573";
			testJson.b = null;
			testJson.s = 4;
			DeviceScan testDScan = new DeviceScan(testServer, testJson);

			Test scanTest = new Test(testDScan);
			scanTest.setTestName("ValidSingleScanSimple");

			List<Test> tests = new List<Test>();
			tests.Add(scanTest);

			AsyncContext.Run(async() => await Program.buildTests(tests));

			foreach (Test nextTest in Program.getTests())
			{
				Assert.AreEqual(nextTest.getExpectedResult(), nextTest.getActualResult());
			}            
		}

		[Test()]
		// Invalid Single Scan
		public void InvalidSingleScanSimple()
		{
            //TODO: Given when then comments
           // var getThing = appconfig.get(invalidScanData);

			DeviceScanJSON testJson = new DeviceScanJSON ();
            testJson.i = validSerial;
			testJson.d = "qwertyuiopasdfghjklzxcvbnmqwertyuiopasdfghjklzxcvbnmqwertyuiopasdfghjklzxcvbnmqwertyuiopasdfghjklzxcvbnmqwertyuiopasdfghjklzxcvbnm";
			testJson.b = null;
			testJson.s = 4;
			DeviceScan testDScan = new DeviceScan(testServer, testJson);

			Test scanTest = new Test(testDScan);
			scanTest.setTestName("InvalidSingleScanSimple");


			List<Test> tests = new List<Test>();
			tests.Add(scanTest);

			AsyncContext.Run(async() => await Program.buildTests(tests));

			foreach (Test nextTest in Program.getTests())
			{
				Assert.AreEqual(nextTest.getExpectedResult(), nextTest.getActualResult());
			}     
		}

		[Test()]
		// Bad Serial
		public void InvalidSerialSimple()
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

			AsyncContext.Run(async() => await Program.buildTests(tests));

			foreach (Test nextTest in Program.getTests())
			{
				Assert.AreEqual(nextTest.getExpectedResult(), nextTest.getActualResult());
			}  
		}

		[Test()]
		// No Serial(Empty String)
		public void EmptySerialSimple()
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

			AsyncContext.Run(async() => await Program.buildTests(tests));

			foreach (Test nextTest in Program.getTests())
			{
				Assert.AreEqual(nextTest.getExpectedResult(), nextTest.getActualResult());
			}  
		}



		[Test()]
		// No Serial(Null)
		public void NullSerialSimple()
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

			AsyncContext.Run(async() => await Program.buildTests(tests));

			foreach (Test nextTest in Program.getTests())
			{
				Assert.AreEqual(nextTest.getExpectedResult(), nextTest.getActualResult());
			}  
		}

		[Test()]
		// List of Valid Scans
		public void LOValidScansSimple()
		{
			DeviceScanJSON testJson = new DeviceScanJSON ();
			testJson.i = validSerial;
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

			AsyncContext.Run(async() => await Program.buildTests(tests));

			foreach (Test nextTest in Program.getTests())
			{
				Assert.AreEqual(nextTest.getExpectedResult(), nextTest.getActualResult());
			}            
		}

		[Test()]
		// Mixed of Valid/Invalid Scans
		public void ValInvalScansSimple()
		{
			DeviceScanJSON testJson = new DeviceScanJSON ();
			testJson.i = validSerial;
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

			AsyncContext.Run(async() => await Program.buildTests(tests));

			foreach (Test nextTest in Program.getTests())
			{
				Assert.AreEqual(nextTest.getExpectedResult(), nextTest.getActualResult());
			}            
		}

		//Dynamic

		[Test()]
		// Valid Single Scan
		public void ValidSingleScanDyn()
		{
			DeviceScanJSON testJson = new DeviceScanJSON ();
			testJson.i = validSerial;
			testJson.d = "~20/90210|";
			testJson.b = null;
			testJson.s = 4;
			DeviceScan testDScan = new DeviceScan (testServer, testJson);

			Test scanTest = new Test (testDScan);
			scanTest.setTestName("ValidSingleScanDyn");


			List<Test> tests = new List<Test> ();
			tests.Add (scanTest);

			AsyncContext.Run(async() => await Program.buildTests(tests));

			foreach (Test nextTest in Program.getTests()) 
			{
				Assert.AreEqual (nextTest.getExpectedResult (), nextTest.getActualResult ());
			}
		}

		[Test()]
		// Valid Call Home Scan
		public void ValidCH()
		{
			DeviceScanJSON testJson = new DeviceScanJSON ();
			testJson.i = validSerial;
			testJson.d = "~21/*CH*055577520928";
			testJson.b = null;
			testJson.s = 4;
			DeviceScan testDScan = new DeviceScan (testServer, testJson);

			Test scanTest = new Test (testDScan);
			scanTest.setTestName("ValidCH");


			List<Test> tests = new List<Test> ();
			tests.Add (scanTest);

			AsyncContext.Run(async() => await Program.buildTests(tests));

			foreach (Test nextTest in Program.getTests()) {
				Assert.AreEqual (nextTest.getExpectedResult (), nextTest.getActualResult ());
			}
		}

		[Test()]
		// Invalid Scan Data
		public void InvalidSingleScanDyn()
		{
			DeviceScanJSON testJson = new DeviceScanJSON ();
			testJson.i = validSerial;
			testJson.d = "~20|noendingbar";
			testJson.b = null;
			testJson.s = 4;
			DeviceScan testDScan = new DeviceScan (testServer, testJson);

			Test scanTest = new Test (testDScan);
			scanTest.setTestName("InvalidSingleScanDyn");


			List<Test> tests = new List<Test> ();
			tests.Add (scanTest);

			AsyncContext.Run(async() => await Program.buildTests(tests));

			foreach (Test nextTest in Program.getTests()) {
				Assert.AreEqual (nextTest.getExpectedResult (), nextTest.getActualResult ());
			}
		}

		[Test()]
		// Bad Serial
		public void InvalidSerialDyn()
		{
			DeviceScanJSON testJson = new DeviceScanJSON ();
			testJson.i = invalidSerial;
			testJson.d = "~20/90210|";
			testJson.b = null;
			testJson.s = 4;
			DeviceScan testDScan = new DeviceScan (testServer, testJson);

			Test scanTest = new Test (testDScan);
			scanTest.setTestName("InvalidSerialDyn");


			List<Test> tests = new List<Test> ();
			tests.Add (scanTest);

			AsyncContext.Run(async() => await Program.buildTests(tests));

			foreach (Test nextTest in Program.getTests()) {
				Assert.AreEqual (nextTest.getExpectedResult (), nextTest.getActualResult ());
			}
		}


		[Test()]
		// No Serial (Empty Sting)
		public void EmptySerialDyn()
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

			AsyncContext.Run(async() => await Program.buildTests(tests));

			foreach (Test nextTest in Program.getTests()) {
				Assert.AreEqual (nextTest.getExpectedResult (), nextTest.getActualResult ());
			}
		}

		[Test()]
		// No Serial (Null)
		public void NullSerialDyn()
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

			AsyncContext.Run(async() => await Program.buildTests(tests));

			foreach (Test nextTest in Program.getTests()) {
				Assert.AreEqual (nextTest.getExpectedResult (), nextTest.getActualResult ());
			}
		}

		[Test()]
		// List of Valid Scans
		public void LOValidScansDyn()
		{
			DeviceScanJSON testJson = new DeviceScanJSON ();
			testJson.i = validSerial;
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

			AsyncContext.Run(async() => await Program.buildTests(tests));

			foreach (Test nextTest in Program.getTests()) {
				Assert.AreEqual (nextTest.getExpectedResult (), nextTest.getActualResult ());
			}
		}

		[Test()]
		// Mixed of Valid/Invalid Scans
		public void ValInvalScansDyn()
		{
			DeviceScanJSON testJson = new DeviceScanJSON ();
			testJson.i = validSerial;
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

			AsyncContext.Run(async() => await Program.buildTests(tests));

			foreach (Test nextTest in Program.getTests()) {
				Assert.AreEqual (nextTest.getExpectedResult (), nextTest.getActualResult ());
			}
		}



		// Combined

		[Test()]
		// List of Valid Simple and Dynamic Code Scans 
		public void ValidScansSimDyn()
		{
			DeviceScanJSON testJson = new DeviceScanJSON ();
			testJson.i = validSerial;
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

			AsyncContext.Run(async() => await Program.buildTests(tests));

			foreach (Test nextTest in Program.getTests()) {
				Assert.AreEqual (nextTest.getExpectedResult (), nextTest.getActualResult ());
			}
		}

		[Test()]
		// Mixed of Valid and Invalid Scans
		public void ValInvalScansSimDyn()
		{
			DeviceScanJSON testJson = new DeviceScanJSON ();
			testJson.i = validSerial;
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

			AsyncContext.Run(async() => await Program.buildTests(tests));

			foreach (Test nextTest in Program.getTests()) {
				Assert.AreEqual (nextTest.getExpectedResult (), nextTest.getActualResult ());
			}
		}
	}

	[TestFixture()]
	public class DeviceSettingsTest
    {
        static Uri testServer = new Uri(ConfigurationManager.ConnectionStrings["Server"].ConnectionString);
        static string validSerial = ConfigurationManager.ConnectionStrings["ValidSerial"].ConnectionString;
        static string invalidSerial = ConfigurationManager.ConnectionStrings["InvalidSerial"].ConnectionString;

		[Test()]
		// Valid Serial
		public void ValidSerial() 
		{
			DeviceSetting dSetting1 = new DeviceSetting(testServer, validSerial);

			Test ValidSerial = new Test(dSetting1);
			ValidSerial.setTestName("ValidSerial");


			List<Test> tests = new List<Test>();
			tests.Add(ValidSerial);

			AsyncContext.Run(async() => await Program.buildTests(tests));

			foreach (Test nextTest in Program.getTests())
			{
				Assert.AreEqual(nextTest.getExpectedResult(), nextTest.getActualResult());
			}
		}

		[Test()]
		// Invalid Serial
		public void InvalidSerial() 
		{
			DeviceSetting dSetting2 = new DeviceSetting(testServer, invalidSerial);

			Test BadSerial = new Test(dSetting2);
			BadSerial.setTestName("BadSerial");


			List<Test> tests = new List<Test>();
			tests.Add(BadSerial);

			AsyncContext.Run(async() => await Program.buildTests(tests));

			foreach (Test nextTest in Program.getTests())
			{
				Assert.AreEqual(nextTest.getExpectedResult(), nextTest.getActualResult());
			}
		}

		[Test()]
		// No Serial
		public void NoSerial() 
		{
			DeviceSetting dSetting3 = new DeviceSetting(testServer, null);

			Test NoSerial = new Test(dSetting3);
			NoSerial.setTestName("NoSerial");


			List<Test> tests = new List<Test>();
			tests.Add(NoSerial);

			AsyncContext.Run(async() => await Program.buildTests(tests));

			foreach (Test nextTest in Program.getTests())
			{
				Assert.AreEqual(nextTest.getExpectedResult(), nextTest.getActualResult());
			}
		}
	}


	[TestFixture()]
	public class DeviceStatusTest
    {
        static Uri server = new Uri(ConfigurationManager.ConnectionStrings["Server"].ConnectionString);
        static string validSerial = ConfigurationManager.ConnectionStrings["ValidSerial"].ConnectionString;
        static string invalidSerial = ConfigurationManager.ConnectionStrings["InvalidSerial"].ConnectionString;

		[Test()]
		public void ValidSerial()
		{
			DeviceStatusJSON status = new DeviceStatusJSON();
			status.bkupURL = "http://cozumotesttls.cloudapp.net:80/api/DeviceBackup";
			status.callHomeTimeoutData = "";
			status.callHomeTimeoutMode = "0";
			status.capture = "1";
			status.captureMode = "1";
			status.cmdChkInt = "1";
			status.cmdURL = "http://cozumotesttls.cloudapp.net:80/api/iCmd";
			string[] err = new string[3];
			err[0] = "asdf";
			err[1] = "wasd";
			err[2] = "qwerty";
			status.dynCodeFormat = err;
			status.errorLog = err;
            status.intSerial = validSerial;
			status.reportURL = "http://cozumotesttls.cloudapp.net:80/api/DeviceStatus";
			status.requestTimeoutValue = "8000";
			status.revId = "52987";
			status.scanURL = "http://cozumotesttls.cloudapp.net:80/api/DeviceScan";
			status.seqNum = "87";
			status.startURL = "http://cozumotesttls.cloudapp.net:80/api/DeviceSetting";

			DeviceStatus operation = new DeviceStatus(server, status);
			Test statusTest = new Test(operation);
			statusTest.setTestName("ValidSerial");


			List<Test> tests = new List<Test>();
			//for (int i = 0; i < 1000; i++) 
			//{
			tests.Add (statusTest);
			//}

			AsyncContext.Run(async() => await Program.buildTests(tests));

			foreach (Test nextTest in Program.getTests())
			{
				Assert.AreEqual(nextTest.getExpectedResult(), nextTest.getActualResult());
			}
		}


		[Test()]
		public void InvalidSerial()
		{
			DeviceStatusJSON status = new DeviceStatusJSON();
			status.bkupURL = "http://cozumotesttls.cloudapp.net:80/api/DeviceBackup";
			status.callHomeTimeoutData = null;
			status.callHomeTimeoutMode = "0";
			status.capture = "1";
			status.captureMode = "1";
			status.cmdChkInt = "1";
			status.cmdURL = "http://cozumotesttls.cloudapp.net:80/api/iCmd";
			string[] err = new string[3];
			err[0] = "asdf";
			err[1] = "wasd";
			err[2] = "qwerty";
			status.errorLog = err;
			status.intSerial = invalidSerial;
			status.reportURL = "http://cozumotesttls.cloudapp.net:80/api/DeviceStatus";
			status.requestTimeoutValue = "8000";
			status.revId = "52987";
			status.scanURL = "http://cozumotesttls.cloudapp.net:80/api/DeviceScan";
			status.seqNum = "87";
			status.startURL = "http://cozumotesttls.cloudapp.net:80/api/DeviceSetting";

			DeviceStatus operation = new DeviceStatus(server, status);
			Test statusTest = new Test(operation);
			statusTest.setTestName("BadSerial");


			List<Test> tests = new List<Test>();
			tests.Add(statusTest);

			AsyncContext.Run(async() => await Program.buildTests(tests));

			foreach (Test nextTest in Program.getTests())
			{
				Assert.AreEqual(nextTest.getExpectedResult(), nextTest.getActualResult());
			}
		}

		[Test()]
		public void EmptySerial()
		{
			DeviceStatusJSON status = new DeviceStatusJSON();
			status.bkupURL = "http://cozumotesttls.cloudapp.net:80/api/DeviceBackup";
			status.callHomeTimeoutData = "";
			status.callHomeTimeoutMode = "0";
			status.capture = "1";
			status.captureMode = "1";
			status.cmdChkInt = "1";
			status.cmdURL = "http://cozumotesttls.cloudapp.net:80/api/iCmd";
			string[] err = new string[3];
			err[0] = "asdf";
			err[1] = "wasd";
			err[2] = "qwerty";
			status.errorLog = err;
			status.reportURL = "http://cozumotesttls.cloudapp.net:80/api/DeviceStatus";
			status.requestTimeoutValue = "8000";
			status.revId = "52987";
			status.scanURL = "http://cozumotesttls.cloudapp.net:80/api/DeviceScan";
			status.seqNum = "87";
			status.startURL = "http://cozumotesttls.cloudapp.net:80/api/DeviceSetting";

			DeviceStatus operation = new DeviceStatus(server, status);
			Test statusTest = new Test(operation);
			statusTest.setTestName("EmptySerial");


			List<Test> tests = new List<Test>();
			tests.Add(statusTest);

			AsyncContext.Run(async() => await Program.buildTests(tests));

			foreach (Test nextTest in Program.getTests())
			{
				Assert.AreEqual(nextTest.getExpectedResult(), nextTest.getActualResult());
			}
		}

		[Test()]
		public void NullSerial()
		{
			DeviceStatusJSON status = new DeviceStatusJSON();
			status.bkupURL = "http://cozumotesttls.cloudapp.net:80/api/DeviceBackup";
			status.callHomeTimeoutData = null;
			status.callHomeTimeoutMode = "0";
			status.capture = "1";
			status.captureMode = "1";
			status.cmdChkInt = "1";
			status.cmdURL = "http://cozumotesttls.cloudapp.net:80/api/iCmd";
			string[] err = new string[3];
			err[0] = "asdf";
			err[1] = "wasd";
			err[2] = "qwerty";
			status.errorLog = err;
			status.reportURL = "http://cozumotesttls.cloudapp.net:80/api/DeviceStatus";
			status.requestTimeoutValue = "8000";
			status.revId = "52987";
			status.scanURL = "http://cozumotesttls.cloudapp.net:80/api/DeviceScan";
			status.seqNum = "87";
			status.startURL = "http://cozumotesttls.cloudapp.net:80/api/DeviceSetting";

			DeviceStatus operation = new DeviceStatus(server, status);
			Test statusTest = new Test(operation);
			statusTest.setTestName("NullSerial");


			List<Test> tests = new List<Test>();
			tests.Add(statusTest);

			AsyncContext.Run(async() => await Program.buildTests(tests));

			foreach (Test nextTest in Program.getTests())
			{
				Assert.AreEqual(nextTest.getExpectedResult(), nextTest.getActualResult());
			}
		}

		[Test()]
		public void AlertDataStore()
		{
			DeviceStatusJSON status = new DeviceStatusJSON();
			status.bkupURL = "http://cozumotesttls.cloudapp.net:80/api/DeviceBackup";
			status.callHomeTimeoutData = null;
			status.callHomeTimeoutMode = "0";
			status.capture = "1";
			status.captureMode = "1";
			status.cmdChkInt = "1";
			status.cmdURL = "http://cozumotesttls.cloudapp.net:80/api/iCmd";
			string[] err = new string[3];
			err[0] = "<timestamp>///900///bypassmode";
			err[1] = "wasd";
			err[2] = "qwerty";
			status.errorLog = err;
			status.intSerial = validSerial;
			status.reportURL = "http://cozumotesttls.cloudapp.net:80/api/DeviceStatus";
			status.requestTimeoutValue = "8000";
			status.revId = "52987";
			status.scanURL = "http://cozumotesttls.cloudapp.net:80/api/DeviceScan";
			status.seqNum = "87";
			status.startURL = "http://cozumotesttls.cloudapp.net:80/api/DeviceSetting";

			DeviceStatus operation = new DeviceStatus(server, status);
			Test statusTest = new Test(operation);
			statusTest.setTestName("AlertDataStore");


			List<Test> tests = new List<Test>();
			tests.Add(statusTest);

			AsyncContext.Run(async() => await Program.buildTests(tests));

			foreach (Test nextTest in Program.getTests())
			{
				Assert.AreEqual(nextTest.getExpectedResult(), nextTest.getActualResult());
			}

		}
	}
		
	[TestFixture()]
	public class ICmdTest
    {
        
		static float lessThan900 = 0;

		static float percentage;

		static float avgTime = -1;
		static float minTime = 9999999999999;
		static float maxTime = -1;
		static int reps = 1;
		public int maxReps;
		//static int[] data = new int[maxReps];


		static StreamWriter results;
		static StreamWriter results1;

		static string outputFile = "../../../logs/performanceTest.csv";

		static string outputFile1 = "../../../logs/performance.csv";


        static Uri testServer;
        static string validSerial;
        static string invalidSerial;

		[TestFixtureSetUp()]
		public void setup()
		{
		    try
            {
                testServer = new Uri(ConfigurationManager.ConnectionStrings["Server"].ConnectionString);
                validSerial = ConfigurationManager.ConnectionStrings["ValidSerial"].ConnectionString;
                invalidSerial = ConfigurationManager.ConnectionStrings["InvalidSerial"].ConnectionString;

                string testRunsString = ConfigurationManager.ConnectionStrings["TimesToRunTests"].ConnectionString;
                try { maxReps = int.Parse(testRunsString); }
                catch (Exception e)
                {
                    Console.WriteLine(e);
                    Console.WriteLine("Chances are your appconfig is misconfigured. Double check that performanceTestRuns is an integer and try again.");
                }
            }
            catch (Exception e)
            {
                Console.WriteLine(e);
            }
		}

        /*
		[TestFixtureTearDown()]
		public void tearDown()
		{
			
		}
        */
		

		[Test()]
		public void PerformanceTest()
		{
			FileStream stream;
			stream = File.Create(outputFile);
			results = new StreamWriter(stream);

			FileStream stream1;
			stream1 = File.Create (outputFile1);
			results1 = new StreamWriter (stream1);

			for (int i = 0; i < maxReps; i++)
			{
				System.Diagnostics.Stopwatch timer = new System.Diagnostics.Stopwatch ();

				ICmd validICmd = new ICmd (testServer, validSerial);

				Test validTest = new Test (validICmd);
				validTest.setTestName ("ValidSerial");


				List<Test> tests = new List<Test> ();
				tests.Add (validTest);

				timer.Start ();
				AsyncContext.Run (async() => await Program.buildTests (tests));
				timer.Stop ();
				int time = timer.Elapsed.Milliseconds;
				/*
				if (avgTime < 0) {
					avgTime = time;
				} else {
					avgTime = (avgTime * (reps - 1) / reps) + (time / reps);
				}
				data [reps - 1] = time;

				reps += 1;
				if (time < minTime) {
					minTime = time;
				}
				if (time > maxTime) {
					maxTime = time;
				}
				if (time < 900) {
					lessThan900++;
				}
				*/

				results.WriteLine ("Test Time," + time);

				results1.WriteLine (time);


				foreach (Test nextTest in Program.getTests()) {
					Assert.AreEqual (nextTest.getExpectedResult (), nextTest.getActualResult ());
				}

				/*if (reps == maxReps + 1) {
					Assert.LessOrEqual (avgTime, 900);
					Console.Write ("Response time is OK");
				}*/
			}
			results.Close ();
			results1.Close ();
		}

		public void ValidSerial()
		{

			//Valid
			ICmd validICmd = new ICmd(testServer, validSerial);

			Test validTest = new Test(validICmd);
			validTest.setTestName("ValidSerial");


			List<Test> tests = new List<Test>();
			tests.Add(validTest);

			AsyncContext.Run(async() => await Program.buildTests(tests));

			foreach (Test nextTest in Program.getTests())
			{
				Assert.AreEqual(nextTest.getExpectedResult(), nextTest.getActualResult());
			}
		}

		[Test()]
		public void InvalidSerial()
		{
			//Invalid
			ICmd invalidICmd = new ICmd(testServer, invalidSerial);
			Test invalidTest = new Test(invalidICmd);
			invalidTest.setTestName("BadSerial");

			List<Test> tests = new List<Test>();
			tests.Add(invalidTest);

			AsyncContext.Run(async() => await Program.buildTests(tests));
			foreach (Test nextTest in Program.getTests())
			{
				Console.WriteLine(nextTest.getOperation().getUri());
				Assert.AreEqual(nextTest.getExpectedResult(), nextTest.getActualResult());
			}
		}

		[Test()]
		public void MissingSerial()
		{
			//Missing
			ICmd missingICmd = new ICmd(testServer, null);
			Test missingTest = new Test(missingICmd);
			missingTest.setTestName("EmptySerial");


			List<Test> tests = new List<Test>();
			tests.Add(missingTest);

			AsyncContext.Run(async() => await Program.buildTests(tests));

			foreach (Test nextTest in Program.getTests())
			{
				Console.WriteLine(nextTest.getOperation().getUri());
				Assert.AreEqual(nextTest.getExpectedResult(), nextTest.getActualResult());
			}
		}

		[Test()]
		public void NoQuery()
		{
			//Missing
			ICmd missingICmd = new ICmd(testServer, null);
			missingICmd.noQuery = true;
			Test missingTest = new Test(missingICmd);
			missingTest.setTestName("NoQuery");


			List<Test> tests = new List<Test>();
			tests.Add(missingTest);

			AsyncContext.Run(async() => await Program.buildTests(tests));

			foreach (Test nextTest in Program.getTests())
			{
				Console.WriteLine(nextTest.getOperation().getUri());
				Assert.AreEqual(nextTest.getExpectedResult(), nextTest.getActualResult());
			}
		}
	}
}

