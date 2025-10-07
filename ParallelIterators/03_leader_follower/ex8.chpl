use RangeChunk;

iter count(start: int, end: int) {
  for i in start..end {
    yield i;
  }
}

iter count(start: int, end: int, param tag) where tag == iterKind.leader {
  coforall rng in chunks(start..end, here.maxTaskPar) {
    var followThis = rng - start;
    yield (followThis,);
  }
}

iter count(start: int, end: int, followThis, param tag) where tag == iterKind.follower {
  var rng = followThis[0] + start;
  for i in rng {
    yield i;
  }
}


writeln("Serial");
for x in count(1, 10) {
  writeln(x);
}

writeln("Parallel (", here.maxTaskPar, ")");
forall x in zip(count(1, 10), count(11, 20)) {
  writeln(x);
}
