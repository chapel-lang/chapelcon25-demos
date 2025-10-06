
use IO, JSON;

// first, explicitly indicate interface
record MyList : writeSerializable {
  var dom : domain(1);
  var data : [dom] int;
  var n : int = 0;

  proc ref append(x: int) {
    if n >= dom.size {
      dom = {0..#(max(4, 2*dom.size))};
    }
    data[n] = x;
    n += 1;
  }
}
proc MyList.numElements : int { return n; }
iter MyList.these() : int {
  for i in 0..#n do yield data[i];
}

// Write once, use with any Serializer
proc MyList.serialize(writer: fileWriter(?), ref serializer: ?st) throws {
  var ser = serializer.startList(writer, this.numElements); // in JSON, write "["
  for elem in this do
    ser.writeElement(elem); // in JSON, write "," if necessary, then ‘elem’
  ser.endList(); // in JSON, write "]"
}

var lst = new MyList();
for i in 1..10 do lst.append(i*i);
stdout.writeln(lst);
stdout.withSerializer(new jsonSerializer()).writeln(lst);
