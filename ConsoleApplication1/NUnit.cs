using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using NUnit.Framework;

namespace ConsoleApplication1
{
    [TestFixture]
    class NUnit
    {
        [Test]
        public void testMethod()
        {
            Assert.AreEqual(true, true);
        }
    }
}
