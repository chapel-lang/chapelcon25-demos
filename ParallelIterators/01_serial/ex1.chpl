iter myIter() {
  /* yield the numbers 1 through 10 */
  for i in 1..10{
    yield i;
  }
}

for i in myIter() {
  writeln(i);
}
