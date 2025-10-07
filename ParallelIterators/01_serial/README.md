# Iterator Fundamentals
## What is an iterator?

An _iterator_ is a sort of subroutine that generates, or _yields_, multiple
values. This can be sone serially or in parallel.

```Chapel
iter myIter() {
  yield 1;
  yield 2;
  yield 3;
}
```

This is different from returning an array or list of things, because
iterators can be interleaved with other code, and don't store all
the elements at once.

(e.g., an iterator for 300 million integers can be created and executed,
but an array of integers of this size would take up 8 GiB of RAM).

## Using iterators
Iterators can be used in `for` loops:

```Chapel
for i in myIter() {
  writeln(i);
}
```

When a type has an `iter these()` method, values of this type can be used
in `for` loops as well.

```Chapel
record threeInts {
  var x, y, z: int;

  iter these() {
      yield x;
      yield y;
      yield z;
  }
};

var myThree = new threeInts(1, 2, 3);
for i in myThree {
  writeln(i);
}
```

## Limitations of serial iterators
So far, the iterators we've seen have been _serial_ iterators. They can
only be used as part of serial 'for' loops (or bracket loops, which fall
back to serial iteration). Thus, the following code will not work:

```Chapel
forall i in myThree {}
```

To make an iterator that can be used in parallel loops, we need to make
a _parallel_ iterator.

## Exercises

*  **(Exercise 1)** Re-write `myIter` to yield the first 10 integers, starting at 0.
   You can use a `for` loop to do this instead of writing out each
   `yield` statement.

*  ** (Exercise 2)** Consider the following program. What do you expect to happen?
   What happens when you compile and run it?

   ```Chapel
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
   ```
