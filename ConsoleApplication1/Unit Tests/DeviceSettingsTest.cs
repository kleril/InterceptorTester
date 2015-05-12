using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
//using Microsoft.VisualStudio.TestTools.UnitTesting;
using NUnit.Framework;

namespace ConsoleApplication1
{
	//[TestClass]
	[TestFixture]
	public class DeviceSettingsTest
	{
		static Uri testServer = ServerUris.getLatest();


		// [TestMethod]
		[Test]
		// Valid Serial
		public async Task ValidSerial() 
		{
			DeviceSetting dSetting1 = new DeviceSetting(testServer, ValidSerialNumbers.getAll()[0]);

			Test ValidSerial = new Test(dSetting1);

			List<Test> tests = new List<Test>();
			tests.Add(ValidSerial);
			
			await Program.buildTests(tests);

			foreach (Test nextTest in Program.getTests())
			{
				Assert.AreEqual(nextTest.getExpectedResult(), nextTest.getActualResult());
			}
		}


		// [TestMethod]
		[Test]
		// Invalid Serial
		public async Task InvalidSerial() 
		{
			DeviceSetting dSetting2 = new DeviceSetting(testServer, "BADSERIAL");

			Test BadSerial = new Test(dSetting2);

			List<Test> tests = new List<Test>();
			tests.Add(BadSerial);

			await Program.buildTests(tests);

			foreach (Test nextTest in Program.getTests())
			{
				Assert.AreEqual(nextTest.getExpectedResult(), nextTest.getActualResult());
			}
		}


		// [TestMethod]
		[Test]
		// No Serial
		public async Task NoSerial() 
		{
			DeviceSetting dSetting3 = new DeviceSetting(testServer, null);

			Test NoSerial = new Test(dSetting3);

			List<Test> tests = new List<Test>();
			tests.Add(NoSerial);

			await Program.buildTests(tests);

			foreach (Test nextTest in Program.getTests())
			{
				Assert.AreEqual(nextTest.getExpectedResult(), nextTest.getActualResult());
			}
		}
	}
}

