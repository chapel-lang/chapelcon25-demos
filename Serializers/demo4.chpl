use IO, JSON;

record X { var data: int; }

var f = openMemFile();

var w = f.writer(serializer=new jsonSerializer());
var rec = new X(42);
w.writeln(rec); // prints to file: {"data":42}
w.flush();

var r = f.reader(deserializer=new jsonDeserializer());
var x = r.read(X);
writeln(x.data); // prints '42'

