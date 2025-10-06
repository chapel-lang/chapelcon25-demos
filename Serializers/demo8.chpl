
use IO, JSON;

// first, explicitly indicate interface
record MyList : writeSerializable, readDeserializable {
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

  proc ref clear() {
    n = 0;
    data = 0;
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

// Write once, use with any Deserializer
proc ref MyList.deserialize(reader: fileReader(?), ref deserializer: ?dt) throws {
  this.clear(); // reading in-place, so clear the data
  var des = deserializer.startList(reader); // in JSON, reads '['
  while des.hasMore() do // in JSON, checks for more elements
    this.append(des.readElement(int));
  des.endList(); // in JSON, reads ']'
}

proc test(arg: MyList, type ser, type des) {
  var f = openMemFile();

  var w = f.writer(serializer=new ser());
  w.write(arg);
  w.flush();

  var r = f.reader(deserializer=new des());
  var li: MyList;
  r.read(li);
  writeln("type '", des:string, "' read back as: ", li);

  // Cannot do the following because we haven't written an initializer
  // that deserializes the type. See demo9.chpl for an example of such an
  // initializer.
  // var li = r.read(MyList);
}

var lst = new MyList();
for i in 1..10 do lst.append(i*i);

test(lst, defaultSerializer, defaultDeserializer);
test(lst, jsonSerializer, jsonDeserializer);
