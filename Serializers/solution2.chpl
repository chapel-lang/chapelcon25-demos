
use IO;

record Counter : writeSerializable {
  var count: int;

  proc ref inc() { count += 1; }
}

var c : Counter;

for i in 1..100 {
  if i % 7 == 0 && i % 3 == 0{
    c.inc();
  }
}

writeln(c);

proc Counter.serialize(writer: fileWriter(?), ref serializer: ?) throws {
  writer.write(count);
}
