iter myIter() {
  yield 1;
  yield 2;
  writeln("nooooo, I'm dying!");
  exit(1);
  yield 3;
  yield 4;
}
for i in myIter() {
  writeln(i);
  if i == 2 then break;
}
