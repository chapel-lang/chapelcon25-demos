use IO, JSON;

record MyType : writeSerializable {
  var name: string;
  var id: int;
}
proc MyType.serialize(writer: fileWriter(?), ref serializer: ?st) throws {
  var ser = serializer.startRecord(writer, /*name=*/"MyType", /*size=*/1);
  ser.writeField("name", this.name);
  ser.endRecord();
}

var mt = new MyType("Sam", 1);
stdout.writeln(mt);
stdout.withSerializer(new jsonSerializer()).writeln(mt);

