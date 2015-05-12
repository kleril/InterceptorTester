using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace ConsoleApplication1
{
    [TestClass]
    public class UnitTest1
    {
        static Uri testServer = ServerUris.getLatest();

        //Do this
        [TestMethod]
        public async Task DeviceScanTest()
        {

            DeviceScanJSON testJson = new DeviceScanJSON ();
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

        [TestMethod]
        public async Task DeviceSettingTest()
        {
            // Valid Serial
			DeviceSetting dSetting1 = new DeviceSetting(testServer, ValidSerialNumbers.getAll()[0]);

			Test ValidSerial = new Test(dSetting1);

			// Bad Serial
			DeviceSetting dSetting2 = new DeviceSetting(testServer, "BADSERIAL");

			Test BadSerial = new Test(dSetting2);

			// No Serial
			DeviceSetting dSetting3 = new DeviceSetting(testServer, null);
	
			Test NoSerial = new Test(dSetting3);

			List<Test> tests = new List<Test>();
			tests.Add(ValidSerial);
			tests.Add(BadSerial);
			tests.Add(NoSerial);

			await Program.buildTests(tests);

			foreach (Test nextTest in Program.getTests())
			{
				Assert.AreEqual(nextTest.getExpectedResult(), nextTest.getActualResult());
			}
    	}

       [TestMethod]
        public async Task DeviceStatusTest()
        {
            // Valid Serial
			DeviceStatusJSON testJson1 = new DeviceStatusJSON ();
			testJson1.intSerial = ValidSerialNumbers.getAll()[1];
			testJson1.seqNum = "4";
			testJson1.capture = "1";
			testJson1.captureMode = "1";
			testJson1.callHomeTimeoutMode = "0";
			testJson1.callHomeTimeoutData = null;
			testJson1.dynCodeFormat = new string[2];
			testJson1.dynCodeFormat[0] = "[\"~*[1,12]/*[1,63]\"";
			testJson1.dynCodeFormat[1] = "\"~server/redemption\"]";
			testJson1.errorLog = new string[0];
			testJson1.startURL = "http://cozumotesttls.cloudapp.net:80/api/DeviceSetting";
			testJson1.reportURL = "http://cozumotesttls.cloudapp.net:80/api/DeviceStatus";
			testJson1.scanURL = "http://cozumotesttls.cloudapp.net:80/api/DeviceScan";
			testJson1.bkupURL = "http://cozumotesttls.cloudapp.net:80/api/DeviceBackup";
			testJson1.requestTimeoutValue = "8000";
			testJson1.cmdChkInt = "1";
			testJson1.cmdURL = "http://www.cozumo.com:80/callhome";
			testJson1.revId = "ITCMM15-SBTC-0515-E001";
			DeviceStatus testDStatus1 = new DeviceStatus(testServer, testJson1);
			Test ValidSerial = new Test(testDStatus1);

			// Bad Serial
			DeviceStatusJSON testJson2 = new DeviceStatusJSON ();
			testJson2.intSerial = "BADSERIAL";
			testJson2.seqNum = "4";
			testJson2.capture = "1";
			testJson2.captureMode = "1";
			testJson2.callHomeTimeoutMode = "0";
			testJson2.callHomeTimeoutData = null;
			testJson2.dynCodeFormat = new string[2];
			testJson2.dynCodeFormat[0] = "[\"~*[1,12]/*[1,63]\"";
			testJson2.dynCodeFormat[1] = "\"~server/redemption\"]";
			testJson2.errorLog = new string[0];
			testJson2.startURL = "http://cozumotesttls.cloudapp.net:80/api/DeviceSetting";
			testJson2.reportURL = "http://cozumotesttls.cloudapp.net:80/api/DeviceStatus";
			testJson2.scanURL = "http://cozumotesttls.cloudapp.net:80/api/DeviceScan";
			testJson2.bkupURL = "http://cozumotesttls.cloudapp.net:80/api/DeviceBackup";
			testJson2.requestTimeoutValue = "8000";
			testJson2.cmdChkInt = "1";
			testJson2.cmdURL = "http://www.cozumo.com:80/callhome";
			testJson2.revId = "ITCMM15-SBTC-0515-E001";
			DeviceStatus testDStatus2 = new DeviceStatus(testServer, testJson2);
			Test BadSerial = new Test(testDStatus2);

			// No Serial
			DeviceStatusJSON testJson3 = new DeviceStatusJSON();
			testJson3.intSerial = null;
			testJson3.seqNum = "4";
			testJson3.capture = "1";
			testJson3.captureMode = "1";
			testJson3.callHomeTimeoutMode = "0";
			testJson3.callHomeTimeoutData = null;
			testJson3.dynCodeFormat = new string[2];
			testJson3.dynCodeFormat[0] = "[\"~*[1,12]/*[1,63]\"";
			testJson3.dynCodeFormat[1] = "\"~server/redemption\"]";
			testJson3.errorLog = new string[0];
			testJson3.startURL = "http://cozumotesttls.cloudapp.net:80/api/DeviceSetting";
			testJson3.reportURL = "http://cozumotesttls.cloudapp.net:80/api/DeviceStatus";
			testJson3.scanURL = "http://cozumotesttls.cloudapp.net:80/api/DeviceScan";
			testJson3.bkupURL = "http://cozumotesttls.cloudapp.net:80/api/DeviceBackup";
			testJson3.requestTimeoutValue = "8000";
			testJson3.cmdChkInt = "1";
			testJson3.cmdURL = "http://www.cozumo.com:80/callhome";
			testJson3.revId = "ITCMM15-SBTC-0515-E001";
			DeviceStatus testDStatus3 = new DeviceStatus(testServer, testJson3);
			Test NoSerial = new Test (testDStatus3);


			List<Test> tests = new List<Test>();
			tests.Add(ValidSerial);
			tests.Add(BadSerial);
			tests.Add(NoSerial);

			await Program.buildTests(tests);

			foreach (Test nextTest in Program.getTests())
			{
				Assert.AreEqual(nextTest.getExpectedResult(), nextTest.getActualResult());
			} 
        }
    }
}
