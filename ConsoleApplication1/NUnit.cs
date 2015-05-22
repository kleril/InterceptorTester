﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using NUnit.Framework;
using System.IO;

namespace ConsoleApplication1
{
	[TestFixture()]
    public class DeviceBackupTest
    {
		static Uri testServer = ServerUris.getLatest();

		[Test()]
		// Valid Serial
		public async Task ValidSerial()
		{
			BackupItem[] items = new BackupItem[3];
			items[0] = getBackupItem(1);
			items[1] = getBackupItem(2);
			items[2] = getBackupItem(3);

			//BackupJSon
			DeviceBackupJSON json = new DeviceBackupJSON();
			json.i = ValidSerialNumbers.getAll()[1];
			json.s = 4;
			json.b = items;

			//BackupOperation
			DeviceBackup operation = new DeviceBackup(testServer, json);

			//Test
			Test backupTest = new Test(operation);
			backupTest.setTestName("ValidSerial");
			List<Test> tests = new List<Test>();
			tests.Add(backupTest);
			await Program.buildTests(tests);

			foreach (Test nextTest in Program.getTests())
			{
				Assert.AreEqual(nextTest.getExpectedResult(), nextTest.getActualResult());
			}
		}

		[Test()]
		// Valid Single Backup Item
		public async Task ValidSingleBackupItem()
		{
			BackupItem[] items = new BackupItem[1];
			items[0] = getBackupItem(1);

			//BackupJSon
			DeviceBackupJSON json = new DeviceBackupJSON();
			json.i = ValidSerialNumbers.getAll()[1];
			json.s = 4;
			json.b = items;

			//BackupOperation
			DeviceBackup operation = new DeviceBackup(testServer, json);

			//Test
			Test backupTest = new Test(operation);
			backupTest.setTestName("ValidSingleBackupItem");
			List<Test> tests = new List<Test>();
			tests.Add(backupTest);
			await Program.buildTests(tests);

			foreach (Test nextTest in Program.getTests())
			{
				Assert.AreEqual(nextTest.getExpectedResult(), nextTest.getActualResult());
			}
		}

		[Test()]
		// Invalid Single Backup Item
		public async Task InvalidSingleBackupItem()
		{


			BackupItem failItem = new BackupItem();

			BackupItem[] failItems = new BackupItem[1];
			failItems[0] = failItem;

			DeviceBackupJSON failJson = new DeviceBackupJSON();
			failJson.i = ValidSerialNumbers.getAll()[1];
			failJson.s = 5;
			failJson.b = failItems;

			DeviceBackup failOperation = new DeviceBackup(testServer, failJson);
			Test failingTest = new Test(failOperation);
			failingTest.setTestName("InvalidSingleBackupItem");

			List<Test> tests = new List<Test>();
			tests.Add(failingTest);
			await Program.buildTests(tests);

			foreach (Test nextTest in Program.getTests())
			{
				Assert.AreEqual(nextTest.getExpectedResult(), nextTest.getActualResult());
			}
		}

		[Test()]
		// Muliple Backup Items with Invalid Backup Item in Them
		public async Task InvalidBackupItems()
		{
			BackupItem failItem = new BackupItem();

			BackupItem[] failItems = new BackupItem[4];
			failItems[0] = getBackupItem(1);
			failItems[1] = getBackupItem(2);
			failItems[2] = failItem;
			failItems[3] = getBackupItem(3);

			DeviceBackupJSON failJson = new DeviceBackupJSON();
			failJson.i = ValidSerialNumbers.getAll()[1];
			failJson.s = 5;
			failJson.b = failItems;

			DeviceBackup failOperation = new DeviceBackup(testServer, failJson);
			Test failingTest = new Test(failOperation);
			failingTest.setTestName("InvalidBackupItems");

			List<Test> tests = new List<Test>();
			tests.Add(failingTest);
			await Program.buildTests(tests);

			foreach (Test nextTest in Program.getTests())
			{
				Assert.AreEqual(nextTest.getExpectedResult(), nextTest.getActualResult());
			}
		}

		[Test()]
		// Invalid Serial Number
		public async Task BadSerial()
		{
			BackupItem[] items = new BackupItem[3];
			items[0] = getBackupItem(1);
			items[1] = getBackupItem(2);
			items[2] = getBackupItem(3);

			DeviceBackupJSON serialJson = new DeviceBackupJSON();
			serialJson.i = "INVALIDSERIAL";
			serialJson.s = 6;
			serialJson.b = items;

			DeviceBackup serialOperation = new DeviceBackup(testServer, serialJson);

			Test serialTest = new Test(serialOperation);
			serialTest.setTestName("BadSerial");

			List<Test> tests = new List<Test>();
			tests.Add(serialTest);
			await Program.buildTests(tests);

			foreach (Test nextTest in Program.getTests())
			{
				Assert.AreEqual(nextTest.getExpectedResult(), nextTest.getActualResult());
			}
		}

		[Test()]
		// No Backup Items
		public async Task NoBackupItems()
		{
			BackupItem[] items = new BackupItem[0];

			DeviceBackupJSON emptyJson = new DeviceBackupJSON();
			emptyJson.i = ValidSerialNumbers.getAll()[0];
			emptyJson.s = 8;
			emptyJson.b = items;

			DeviceBackup emptyOperation = new DeviceBackup(testServer, emptyJson);
			Test emptyTest = new Test(emptyOperation);
			emptyTest.setTestName("NoBackupItems");


			List<Test> tests = new List<Test>();
			tests.Add(emptyTest);
			await Program.buildTests(tests);

			foreach (Test nextTest in Program.getTests())
			{
				Assert.AreEqual(nextTest.getExpectedResult(), nextTest.getActualResult());
			}
		}

		[Test()]
		// Input with Serial Number as ""
		public async Task EmptySerial()
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
			await Program.buildTests(tests);

			foreach (Test nextTest in Program.getTests())
			{
				Assert.AreEqual(nextTest.getExpectedResult(), nextTest.getActualResult());
			}
		}


		[Test()]
		// Input with Null Serial Number
		public async Task NullSerial()
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
			await Program.buildTests(tests);

			foreach (Test nextTest in Program.getTests())
			{
				Assert.AreEqual(nextTest.getExpectedResult(), nextTest.getActualResult());
			}
		}

		[Test()]
		// Scan Code being a Special Dynamic Code
		public async Task SpecialDynCode()
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
			serialJson.i = ValidSerialNumbers.getAll()[1];

			DeviceBackup serialOperation = new DeviceBackup(testServer, serialJson);

			Test serialTest = new Test(serialOperation);
			serialTest.setTestName("SpecialDynCode");

			List<Test> tests = new List<Test>();
			tests.Add(serialTest);
			await Program.buildTests(tests);

			foreach (Test nextTest in Program.getTests())
			{
				Assert.AreEqual(nextTest.getExpectedResult(), nextTest.getActualResult());
			}
		}


		[Test()]
		// Scan Code being a Dynamic Code and Not Special
		public async Task NotSpecialDynCode()
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
			serialJson.i = ValidSerialNumbers.getAll()[1];

			DeviceBackup serialOperation = new DeviceBackup(testServer, serialJson);

			Test serialTest = new Test(serialOperation);
			serialTest.setTestName("NotSpecialDynCode");

			List<Test> tests = new List<Test>();
			tests.Add(serialTest);
			await Program.buildTests(tests);

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
		static Uri testServer = ServerUris.getLatest();


		// simple scan code

		[Test()]
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

		[Test()]
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

		[Test()]
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

		[Test()]
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



		[Test()]
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

		[Test()]
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

		[Test()]
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

		[Test()]
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

		[Test()]
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

		[Test()]
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

		[Test()]
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


		[Test()]
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

		[Test()]
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

		[Test()]
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

		[Test()]
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

		[Test()]
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

		[Test()]
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

	[TestFixture()]
	public class DeviceSettingsTest
	{
		static Uri testServer = ServerUris.getLatest();

		[Test()]
		// Valid Serial
		public async Task ValidSerial() 
		{
			DeviceSetting dSetting1 = new DeviceSetting(testServer, ValidSerialNumbers.getAll()[0]);

			Test ValidSerial = new Test(dSetting1);
			ValidSerial.setTestName("ValidSerial");


			List<Test> tests = new List<Test>();
			tests.Add(ValidSerial);

			await Program.buildTests(tests);

			foreach (Test nextTest in Program.getTests())
			{
				Assert.AreEqual(nextTest.getExpectedResult(), nextTest.getActualResult());
			}
		}

		[Test()]
		// Invalid Serial
		public async Task InvalidSerial() 
		{
			DeviceSetting dSetting2 = new DeviceSetting(testServer, "BADSERIAL");

			Test BadSerial = new Test(dSetting2);
			BadSerial.setTestName("BadSerial");


			List<Test> tests = new List<Test>();
			tests.Add(BadSerial);

			await Program.buildTests(tests);

			foreach (Test nextTest in Program.getTests())
			{
				Assert.AreEqual(nextTest.getExpectedResult(), nextTest.getActualResult());
			}
		}

		[Test()]
		// No Serial
		public async Task NoSerial() 
		{
			DeviceSetting dSetting3 = new DeviceSetting(testServer, null);

			Test NoSerial = new Test(dSetting3);
			NoSerial.setTestName("NoSerial");


			List<Test> tests = new List<Test>();
			tests.Add(NoSerial);

			await Program.buildTests(tests);

			foreach (Test nextTest in Program.getTests())
			{
				Assert.AreEqual(nextTest.getExpectedResult(), nextTest.getActualResult());
			}
		}
	}


	[TestFixture()]
	public class DeviceStatusTest
	{
		Uri server = ServerUris.getLatest();


		[Test()]


		public async Task ValidSerial()
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
			status.intSerial = ValidSerialNumbers.getAll()[1];
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

			await Program.buildTests(tests);

			foreach (Test nextTest in Program.getTests())
			{
				Assert.AreEqual(nextTest.getExpectedResult(), nextTest.getActualResult());
			}
		}


		[Test()]
		public async Task InvalidSerial()
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
			status.intSerial = "DOOT DOOT";
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

			await Program.buildTests(tests);

			foreach (Test nextTest in Program.getTests())
			{
				Assert.AreEqual(nextTest.getExpectedResult(), nextTest.getActualResult());
			}
		}

		[Test()]
		public async Task EmptySerial()
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

			await Program.buildTests(tests);

			foreach (Test nextTest in Program.getTests())
			{
				Assert.AreEqual(nextTest.getExpectedResult(), nextTest.getActualResult());
			}
		}

		[Test()]
		public async Task NullSerial()
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

			await Program.buildTests(tests);

			foreach (Test nextTest in Program.getTests())
			{
				Assert.AreEqual(nextTest.getExpectedResult(), nextTest.getActualResult());
			}
		}

		[Test()]
		public async Task AlertDataStore()
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
			status.intSerial = ValidSerialNumbers.getAll()[0];
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

			await Program.buildTests(tests);

			foreach (Test nextTest in Program.getTests())
			{
				Assert.AreEqual(nextTest.getExpectedResult(), nextTest.getActualResult());
			}

		}
	}


	[TestFixture()]
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

		static string outputFile = "../../../logs/performanceTest" + DateTime.Now.ToFileTime() + ".csv";

		/*
		static Excel.Application xlsFile;

		static Excel.Workbook workBook;

		static Excel.Worksheet workSheet;

		object misValue = System.Reflection.Missing.Value;
		*/


		//static string outputFile = "../../../logs/performanceTest" + DateTime.Now.ToFileTime() + ".txt";


		//static string xlsPath = "../../../logs/xlsOutput" + DateTime.Now.ToFileTime () + ".xls";

		[TestFixtureSetUp()]
		public void setup()
		{
			FileStream stream;
			stream = File.Create(outputFile);
			results = new StreamWriter(stream);

			/*
			try
			{
				results.WriteLine ("!!!!!!!!!!!!!!!!!!!!!!!!hey");
				xlsFile = new Excel.Application();
				workBook = xlsFile.Workbooks.Add(misValue);
				workSheet = (Excel.Worksheet)workBook.ActiveSheet;
				workSheet.Cells[1, 1].Value = "ICmd Performance Test";

			}
			catch (Exception e) 
			{
				results.WriteLine("!!!!!!!!!!!!!!!!!!!!!!!!" + e);
			}
			*/

		}

		[TestFixtureTearDown()]
		public void tearDown()
		{
			int index = (maxReps * 95 / 100) - 1;
			int percentile = data[index];
			results.WriteLine("95% of the tests take less than " + percentile + "ms");
			percentage = (lessThan900 / maxReps) * 100;
			results.WriteLine(percentage + "% of tests take less than 900ms");
			results.WriteLine("Average Time," + avgTime);
			results.WriteLine("Minimum Time," + minTime);
			results.WriteLine("Maximum Time," + maxTime);
			results.Close();

			/*
			try
			{
				workSheet.Cells[1, 1].Value = "Average Time";
				workSheet.Cells[1, 2].Value = avgTime;
				workSheet.Cells[2, 1].Value = "Maximum Time";
				workSheet.Cells[2, 2].Value = maxTime;
				workSheet.Cells[3, 1].Value = "Minimum Time";
				workSheet.Cells[3, 2].Value = minTime;
				workSheet.Cells[4, 1].Value = "95 Percentile";
				workSheet.Cells[4, 2].Value = percentile;


				workBook.SaveAs(xlsPath, misValue, misValue, misValue, false, false);
				workBook.Close(true, misValue, misValue);
				xlsFile.Quit();
			}
			catch (Exception e) 
			{
			}
			*/

		}

		[Test(), Repeat(maxReps)]
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

			results.WriteLine("Test Time," + time);


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

		[Test()]
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

		[Test()]
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

		[Test()]
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
