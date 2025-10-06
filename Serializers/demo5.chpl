
use IO, JSON;

record MyType : writeSerializable {
  var name: string;
  var id: int;
}

proc MyType.serialize(writer: fileWriter(?), ref serializer: ?st) throws {
  writer.write(this.name);
}
proc MyType.serialize(writer: fileWriter(serializerType=jsonSerializer),
                      ref serializer: jsonSerializer) throws {
  writer.writeLiteral('{"name": ');
  writer.write(this.name);
  writer.writeLiteral("}");
}

var mt = new MyType(name="Sam", id=42);
writeln(mt);

var wj = stdout.withSerializer(new jsonSerializer());
wj.writeln(mt);
