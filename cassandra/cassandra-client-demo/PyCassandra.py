from thrift import Thrift
from thrift.transport import TTransport
from thrift.transport import TSocket
from thrift.protocol.TBinaryProtocol import TBinaryProtocolAccelerated
from cassandra import Cassandra
from cassandra.ttypes import *
import time
import pprint

def main():
     socket = TSocket.TSocket("192.168.10.2", 9160)
    transport = TTransport.TBufferedTransport(socket)
    protocol = TBinaryProtocol.TBinaryProtocolAccelerated(transport)
    client = Cassandra.Client(protocol)
    pp = pprint.PrettyPrinter(indent=2)
    keyspace = "Keyspace1"
    column_path = ColumnPath(column_family="Standard1", column="age")
    key = "studentA"
    value = "18 "
    timestamp = time.time()
    try:
        #打开数据库连接
        transport.open()
        #写入数据
        client.insert(keyspace,
                      key,
                      column_path,
                      value,
                      timestamp,
                      ConsistencyLevel.ZERO)
        #查询数据
        column_parent = ColumnParent(column_family="Standard1")
        slice_range = SliceRange(start="", finish="")
        predicate = SlicePredicate(slice_range=slice_range)
        result = client.get_slice(keyspace,
                                  key,
                                  column_parent,
                                  predicate,
                                  ConsistencyLevel.ONE)
        pp.pprint(result)
    except Thrift.TException, tx:
        print 'Thrift: %s' % tx.message
    finally:
        #关闭连接
        transport.close()

if __name__ == '__main__':
main()
