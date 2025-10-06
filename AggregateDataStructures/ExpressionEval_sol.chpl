
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
class BinExpr : Expr {
  var op: string;
  var lhs: owned Expr;
  var rhs: owned Expr;

  proc init(op: string, in lhs: owned Expr, in rhs: owned Expr) {
    this.op = op;
    this.lhs = lhs;
    this.rhs = rhs;
  }
  override proc eval(syms: symbols) {
    var left = lhs.eval(syms);
    var right = rhs.eval(syms);
    if op == "+" {
      return left + right;
    } else if op == "-" {
      return left - right;
    } else if op == "*" {
      return left * right;
    } else if op == "/" {
      return left / right;
    } else {
      halt("Unknown operator: " + op);
    }
  }
  override proc stringify(): string {
    return "(" + lhs.stringify() + " " + op + " " + rhs.stringify() + ")";
  }
}
class Number : Expr {
  var value: int;
  proc init(value: int) {
    this.value = value;
  }
  override proc eval(syms: symbols) {
    return value;
  }
  override proc stringify(): string {
    return value:string;
  }
}
class Variable : Expr {
  var name: string;
  proc init(name: string) {
    this.name = name;
  }
  override proc eval(syms: symbols) {
    return syms.get(name);
  }
  override proc stringify(): string {
    return name;
  }
}

proc printExpr(e: borrowed) {
  writeln("Expression: ", e.stringify());
}
proc printVal(e: borrowed, syms: symbols) {
  writeln("Value: ", e.eval(syms));
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

