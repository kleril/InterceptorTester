﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ConsoleApplication1
{
	class DeviceBackup : APIOperation
	{
        DeviceBackupJSON json;

		public DeviceBackup(Uri server, DeviceBackupJSON backup)
		{
			opHost = server;
			hOp = HTTPOperation.POST;
            json = backup;
		}

        //TODO: Code this
		public override string getExpectedResult()
		{
            return "201";
		}

		public override string ToString()
		{
            return "DeviceBackup";
		}

        public override Uri getUri()
        {
            return new Uri(opHost, "/api/DeviceBackup/");
        }

        public override object getJson()
        {
            return json;
        }
    }
}

