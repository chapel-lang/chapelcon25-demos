use IO;

var f: file = open("foo.txt", ioMode.cwr);

var w = f.writer();
w.writeln("Hello!");
w.flush();

var r = f.reader();
const str = r.read(string);
writeln("read: ", str); // prints ‘read: Hello!'

