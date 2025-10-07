iter myParallelIter() {
  for i in 1..here.maxTaskPar {
    for j in 1..4 {
      yield (i - 1) * 4 + j;
    }
  }
}
writeln("Serial");
for x in myParallelIter() {
  writeln(x);
}

iter myParallelIter(param tag) where tag == iterKind.standalone {
  coforall i in 1..here.maxTaskPar {
    for j in 1..4 {
      yield (i - 1) * 4 + j;
    }
  }
}
writeln("Parallel (", here.maxTaskPar, ")");
forall x in myParallelIter() {
  writeln(x);
}
