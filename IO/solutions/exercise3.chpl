use IO;

var r = openReader("oldMcDonald.txt");

for l in r.lines(stripNewline=true) {
  writeln(l);
}
