use RangeChunk;

/**
  Extended exericse: defining iterators for a binary tree.
  ========================================================

  Fill in the following code:

  * Implement the 'visit' method on 'TreeNode'.
    This should yield a subset of the nodes in the element in traversal order,
    given a range of indices to yield (inclusive).
  * Implement the serial, standalone, leader, and follower iterators.

  If you'd rather focus on implementing the iterators and not the 'visit'
  method, see 'tree_ex.halfsolved.chpl' for a version
  of this exercise that has the 'visit' method already implemented.

 */

class TreeNode {
  var key;
  var value;

  var left: owned TreeNode(key.type, value.type)? = nil;
  var right: owned TreeNode(key.type, value.type)? = nil;

  proc type insert(ref into: owned this?, key, value) {
    if into == nil {
      into = new owned TreeNode(key, value);
    } else if key < into!.key {
      insert(into!.left, key, value);
    } else {
      insert(into!.right, key, value);
    }
  }

  proc size: int {
    var count = 1;
    if left != nil then count += left!.size;
    if right != nil then count += right!.size;
    return count;
  }

  /* an iterator that yields nodes given their 0-indexed order.
     The 'currentIdx' encodes the current index in the traversal, and
     'startIdx' and 'endIndex' are the range of indices to yield (inclusive). */
  iter visit(ref currentIdx: int, startIdx: int, endIndex: int): (key.type, value.type) {
  }
}

record multiMap {
  type keyType;
  type valueType;

  var root: owned TreeNode(keyType, valueType)? = nil;

  proc insert(key, value) {
    TreeNode.insert(root, key, value);
  }

  proc size {
    if root == nil then return 0;
    return root!.size;
  }

  iter visit(startIdx: int, endIndex: int) {
    if root == nil then return;

    var currentIdx = 0;
    for x in root!.visit(currentIdx, startIdx, endIndex) {
        yield x;
    }
  }

  iter these(): (keyType, valueType) {
  }

  iter these(param tag) : (keyType, valueType) where tag == iterKind.standalone {
  }

  iter these(param tag) : (range,) where tag == iterKind.leader {
  }

  iter these(followThis, param tag) : (keyType, valueType) where tag == iterKind.follower {
  }
}

var m = new multiMap(int, string);
m.insert(5, "five");
m.insert(1, "one");
m.insert(3, "three");
m.insert(7, "seven");
m.insert(-1, "negative one");
writeln(m);

for (k, v) in m {
  writeln("Key: ", k, ", Value: ", v);
}

var A = [-1, 1, 3, 5, 7];
forall ((k, v), a) in zip(m, A) {
  writeln("Key: ", k, ", Value: ", v, ", Expected: ", a);
}
forall (a, (k, v)) in zip(A, m) {
  writeln("Key: ", k, ", Value: ", v, ", Expected: ", a);
}
