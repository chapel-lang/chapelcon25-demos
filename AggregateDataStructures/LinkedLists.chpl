class Node {
  type T;
  var data: T;
  var next: owned Node(T)?;
  proc init(data: ?T) {
    this.T = T;
    this.data = data;
    next = nil;
  }
}
record linkedList {
  type T;
  var head: owned Node(T)?;
  proc init(type T) {
    this.T = T;
    head = nil;
  }
}
proc linkedList.printList() {
  var current = head.borrow();
  var sep = "";
  while current != nil {
    write(sep, current!.data);
    current = current!.next.borrow();
    sep = " -> ";
  }
  writeln();
}
proc ref linkedList.append(data: T) {
  if head == nil {
    head = new Node(data);
  } else {
    appendHelper(head!, data);
  }
}
proc appendHelper(node: borrowed, data: node.T) {
  if node.next == nil {
    node.next = new Node(data);
  } else {
    appendHelper(node.next!, data);
  }
}

proc main() {
  var list = new linkedList(int);
  list.append(10);
  list.append(20);
  list.append(30);
  list.printList();
}
