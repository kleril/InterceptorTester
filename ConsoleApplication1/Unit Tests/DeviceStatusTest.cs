using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using NUnit.Framework;

namespace ConsoleApplication1
{
    [TestFixture]
	public class DeviceStatusTest
	{
        Uri server = ServerUris.getLatest();

        [Test]
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

            List<Test> tests = new List<Test>();
			tests.Add(statusTest);
			
			await Program.buildTests(tests);

			foreach (Test nextTest in Program.getTests())
			{
				Assert.AreEqual(nextTest.getExpectedResult(), nextTest.getActualResult());
			}
		}

        [Test]
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

            List<Test> tests = new List<Test>();
            tests.Add(statusTest);

            await Program.buildTests(tests);

            foreach (Test nextTest in Program.getTests())
            {
                Assert.AreEqual(nextTest.getExpectedResult(), nextTest.getActualResult());
            }
        }

        [Test]
        public async Task NoSerial()
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

            List<Test> tests = new List<Test>();
            tests.Add(statusTest);

            await Program.buildTests(tests);

            foreach (Test nextTest in Program.getTests())
            {
                Assert.AreEqual(nextTest.getExpectedResult(), nextTest.getActualResult());
            }
        }

        [Test]
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

            List<Test> tests = new List<Test>();
			tests.Add(statusTest);

		}
	}
}
