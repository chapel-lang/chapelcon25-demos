use IO, JSON;

record R { var x: int; }

var f = new file(1); // opens stdout, assuming POSIX system...
var wj = f.writer(serializer=new jsonSerializer());

var rec = new R(42);
wj.writeln(rec); // prints: {"x":42}

