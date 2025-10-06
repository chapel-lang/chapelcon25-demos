use IO, List, JSON;

var li : list(int);
for i in 1..10 do li.pushBack(i);

var f = openMemFile();

// a) write out to file
var w = f.writer(serializer=new jsonSerializer());
w.write(li);
w.flush();

// b) read back in
var r = f.reader(deserializer=new jsonDeserializer());
var li2 = r.read(list(int));
writeln(li2);

// Should print:
// [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
