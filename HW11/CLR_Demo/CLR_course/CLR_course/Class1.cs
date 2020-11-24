using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Microsoft.SqlServer.Server;
using System.Data;
using System.Data.SqlTypes;

namespace CLR_course
{
    public class Class1
    {
        public static int SumFunction(int a, int b)
        {
            return a + b;
        }

        public static void NameProcedure(SqlString name)
        {
            var pipe = SqlContext.Pipe;

            var columns = new SqlMetaData[1];
            columns[0] = new SqlMetaData("HelloColumn", SqlDbType.NVarChar, 100);

            var row = new SqlDataRecord(columns);
            pipe.SendResultsStart(row);
            for (int i = 0; i < 5; i++)
            {
                row.SetSqlString(0, string.Format("{0} Hello, {1}", i, name));
                pipe.SendResultsRow(row);
            }

            pipe.SendResultsEnd();
        }
    }
}
