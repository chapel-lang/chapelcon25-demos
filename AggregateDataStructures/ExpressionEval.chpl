
use Map;
record symbols {
  var table: map(string, int);
  proc ref add(name: string, value: int) {
    table[name] = value;
  }
  proc get(name: string): int {
    return table[name];
  }
}
class Expr {
  proc eval(syms: symbols): int {
    halt("Not implemented");
  }
  proc stringify(): string {
    halt("Not implemented");
  }
}

proc main() {
  var syms = new symbols();
  syms.add("x", 10);
  syms.add("y", 5);

  var expr = new BinExpr("+",
                new BinExpr("*",
                  new Variable("x"),
                  new Number(2)),
                new BinExpr("-",
                  new Variable("y"),
                  new Number(3)));

  printExpr(expr);
  printVal(expr, syms);
}

