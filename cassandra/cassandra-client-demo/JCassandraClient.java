package com.test.cassandra;

import java.io.UnsupportedEncodingException;
import org.apache.thrift.transport.TTransport;
import org.apache.thrift.transport.TSocket;
import org.apache.thrift.protocol.TProtocol;
import org.apache.thrift.protocol.TBinaryProtocol;
import org.apache.thrift.TException;
import org.apache.cassandra.thrift.Cassandra;
import org.apache.cassandra.thrift.Column;
import org.apache.cassandra.thrift.ColumnOrSuperColumn;
import org.apache.cassandra.thrift.ColumnPath;
import org.apache.cassandra.thrift.ConsistencyLevel;
import org.apache.cassandra.thrift.InvalidRequestException;
import org.apache.cassandra.thrift.NotFoundException;
import org.apache.cassandra.thrift.TimedOutException;
import org.apache.cassandra.thrift.UnavailableException;
/**
 * Java客户端连接Cassandra并进行读写操作
 * @author jimmy
 *
 */
public class JCassandraClient
{
    public static void main(String[] args) throws InvalidRequestException, NotFoundException, UnavailableException, TimedOutException, TException, UnsupportedEncodingException    {
        TTransport tr = new TSocket("192.168.10.2", 9160);
        TProtocol proto = new TBinaryProtocol(tr);

        Cassandra.Client client = new Cassandra.Client(proto);
        tr.open();

        String keyspace = "Keyspace1";
        String cf = "Standard2";
        String key = "studentA";
         // Insert
        long timestamp = System.currentTimeMillis();
        ColumnPath path = new ColumnPath(cf);
        path.setColumn("age".getBytes("UTF-8"));
         client.insert(keyspace,
                      key,
                       path,
                      "18".getBytes("UTF-8"),
                      timestamp,
                      ConsistencyLevel.ONE);

        path.setColumn("height".getBytes("UTF-8"));
        client.insert(keyspace,
		                key,
		                path,
                      "172cm".getBytes("UTF-8"),
                      timestamp,
                      ConsistencyLevel.ONE);

        // Read
        path.setColumn("height".getBytes("UTF-8"));
        ColumnOrSuperColumn cc = client.get(keyspace, key, path, ConsistencyLevel.ONE);
         Column c = cc.getColumn();

        String v = new String(c.value, "UTF-8");

        System.out.println("Read studentA height:"+v);

        tr.close();
    }
}
