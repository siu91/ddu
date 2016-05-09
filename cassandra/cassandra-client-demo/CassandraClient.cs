namespace CshareCassandra
{
    using System;
    using System.Collections.Generic;
    using System.Diagnostics;
    using Apache.Cassandra;
    using Thrift.Protocol;
    using Thrift.Transport;

    class CassandraClient
    {
        static void Main(string[] args)
        {
            //建立数据库连接
            TTransport transport = new TSocket("192.168.10.2", 9160);
            TProtocol protocol = new TBinaryProtocol(transport);
            Cassandra.Client client = new Cassandra.Client(protocol);
            transport.Open();

            System.Text.Encoding utf8Encoding = System.Text.Encoding.UTF8;
            long timeStamp = DateTime.Now.Millisecond;
            ColumnPath nameColumnPath = new ColumnPath()
			{
				Column_family = "Standard1",
				Column = utf8Encoding.GetBytes("age")
			};
            //写入数据
            client.insert("Keyspace1",
                          "studentA",
                          nameColumnPath,
                          utf8Encoding.GetBytes("18"),
                          timeStamp,
                          ConsistencyLevel.ONE);

           //读取数据
            ColumnOrSuperColumn returnedColumn = client.get("Keyspace1", "studentA", nameColumnPath, ConsistencyLevel.ONE);
            Console.WriteLine("Keyspace1/Standard1: age: {0}, value: {1}", utf8Encoding.GetString(returnedColumn.Column.Name), utf8Encoding.GetString(returnedColumn.Column.Value));
 
           //关闭连接
           transport.Close();
        }
    }
}
