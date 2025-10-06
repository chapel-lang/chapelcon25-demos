
use IO, List;

record point : serializable { var x, y: int; }

var li : list(point);
for i in 1..10 by 2 do li.pushBack(new point(i, i+1));

var f = openMemFile();
var w = f.writer();
w.writeln(li);
w.flush();

var r = f.reader();
var li2 = r.read(list(point));
writeln("read: ", li2);

// Boilerplate to get started
/*

proc point.serialize(writer: fileWriter(?), ref serializer: ?) throws {
}

proc ref point.deserialize(reader: fileReader(?), ref deserializer: ?) throws {
}

proc point.init(reader: fileReader(?), ref deserializer: ?) throws {
}

// adding a user-defined initializer for reading prevents generation of the
// default initializer that takes two ints, so recreate it here
proc point.init(x: int, y: int) {
  this.x = x;
  this.y = y;
}
*/
