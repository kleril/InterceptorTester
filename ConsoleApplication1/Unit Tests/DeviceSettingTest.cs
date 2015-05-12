using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace ConsoleApplication1.Unit_Tests
{
    [TestClass]
    public class DeviceSettingTest
    {
        static Uri testServer = ServerUris.getLatest();

        [TestMethod]
        public async Task SettingTest()
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
    }
}
