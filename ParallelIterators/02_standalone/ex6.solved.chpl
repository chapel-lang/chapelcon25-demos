use RangeChunk;

record myRange {
  var start: int;
  var end: int;

  iter these() {
    for i in start..end {
      yield i;
    }
  }
  iter these(param tag) where tag == iterKind.standalone {
    coforall rng in chunks(start..end, here.maxTaskPar) {
      for i in rng {
        yield i;
      }
    }
  }
}


writeln("Serial");
var r = new myRange(1, 10);
for x in r {
  writeln(x);
}

writeln("Parallel (", here.maxTaskPar, ")");
forall x in r {
  writeln(x);
}
