use IO, JSON;

record R { var x: int; }

// use the builtin 'stdout' variable from the 'IO' module
var wj = stdout.withSerializer(new jsonSerializer());

var rec = new R(42);
wj.writeln(rec); // prints: {"x":42}

