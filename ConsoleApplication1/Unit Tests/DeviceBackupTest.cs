using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace ConsoleApplication1
{
    [TestClass]
    public class DeviceBackupTest
    {
        static Uri testServer = ServerUris.getLatest();

        [TestMethod]
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
            List<Test> tests = new List<Test>();
            tests.Add(backupTest);
            await Program.buildTests(tests);

            foreach (Test nextTest in Program.getTests())
            {
                Assert.AreEqual(nextTest.getExpectedResult(), nextTest.getActualResult());
            }
        }

        [TestMethod]
        public async Task InvalidBackupItems()
        {
            //Failing Test
            //BackupItems
            BackupItem failItem = new BackupItem();
            //failItem.t = new DateTime(2015, 5, 11, 2, 4, 22, 295);
            //failItem.c = true;

            BackupItem[] failItems = new BackupItem[4];
            failItems[0] = getBackupItem(1);
            failItems[1] = getBackupItem(2);
            failItems[2] = failItem;
            failItems[3] = getBackupItem(3);

            //BackupJSon
            DeviceBackupJSON failJson = new DeviceBackupJSON();
            failJson.i = ValidSerialNumbers.getAll()[1];
            failJson.s = 5;
            failJson.b = failItems;

            //BackupOperation
            DeviceBackup failOperation = new DeviceBackup(testServer, failJson);
            Test failingTest = new Test(failOperation);

            List<Test> tests = new List<Test>();
            tests.Add(failingTest);
            await Program.buildTests(tests);

            foreach (Test nextTest in Program.getTests())
            {
                Assert.AreEqual(nextTest.getExpectedResult(), nextTest.getActualResult());
            }
        }

        [TestMethod]
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

            List<Test> tests = new List<Test>();
            tests.Add(serialTest);
            await Program.buildTests(tests);

            foreach (Test nextTest in Program.getTests())
            {
                Assert.AreEqual(nextTest.getExpectedResult(), nextTest.getActualResult());
            }
        }

        [TestMethod]
        public async Task NoBackupItems()
        {
            BackupItem[] items = new BackupItem[3];
            items[0] = getBackupItem(1);
            items[1] = getBackupItem(2);
            items[2] = getBackupItem(3);

            DeviceBackupJSON emptyJson = new DeviceBackupJSON();
            emptyJson.i = ValidSerialNumbers.getAll()[0];
            emptyJson.s = 8;
            items[0] = null;
            items[1] = null;
            items[2] = null;
            emptyJson.b = items;

            DeviceBackup emptyOperation = new DeviceBackup(testServer, emptyJson);
            Test emptyTest = new Test(emptyOperation);


            List<Test> tests = new List<Test>();
            tests.Add(emptyTest);
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
}            