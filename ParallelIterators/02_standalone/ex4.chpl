use RangeChunk;

iter count(start: int, end: int) {
  for i in start..end {
    yield i;
  }
}

iter count(start: int, end: int, param tag) where tag == iterKind.standalone {
  coforall rng in chunks(start..end, here.maxTaskPar) {
    for i in rng {
      yield i;
    }
  }
}

writeln("Serial");
for x in count(1, 10) {
  writeln(x);
}

writeln("Parallel (", here.maxTaskPar, ")");
forall x in count(1, 10) {
  writeln(x);
}
