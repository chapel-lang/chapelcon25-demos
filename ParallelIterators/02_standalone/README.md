# Standalone parallel iterators

The simplest parallel iterator we can make is a _standalone_ parallel iterator.
These iterators are useful because they can be used in parallel loops (and
can spin up parallel tasks), but don't require thinking about how to allow
other data structures to be iterated in addition (i.e., in a loop with `zip`).
This might also mean simpler logic, which can be slightly more efficient.

## The `tag` Argument

The Chapel compiler currently invokes non-serial iterator by making a call
to the iterator with an additional `tag` argument.

> [!NOTE]
> This tutorial covers the current state of defining parallel iterators in Chapel.
> We are always working on improving the language and its features, and
> are open to alternative ways to define parallel iterators.

Inside the body of the iterator, you can use low-level parallel constructs
(e.g., `coforall`) to spawn parallel tasks. We can use `here.maxTaskPar` to
query how many tasks can run in parallel on the current locale.

As a simple example, we can create a parallel iterator that yields the
first `maxTaskPar * 4` integers. First, though, let's create a serial
version of this code.

```Chapel
iter myParallelIter() {
  // could've written this as one loop, but it helps prepare us for the
  // parallel version
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
```

> [!NOTE]
> Currently, Chapel resolves calls to parallel iterators (like `myParallelIter()`)
> before trying to insert the `tag`. Thus, a serial iterator must exist
> for the parallel iterator to work. Here, we are both using the serial
> version for pedagogical purposes and to ensure that the parallel
> version works correctly.

In the parallel version, we use the `coforall` loop to create as many
tasks as our locale can handle in parallel. Within each tasks, we run a loop
4 times to yield the integers we want. The rest is unchanged; we can use
`forall` to iterate over the parallel version.

```Chapel
iter myParallelIter(param tag) where tag == iterKind.standalone {
  coforall i in 1..here.maxTaskPar {
    for j in 1..4 {
      yield (i - 1) * 4 + j;
    }
  }
}
writeln("Parallel");
forall x in myParallelIter() {
  writeln(x);
}
```

* **(Exercise 3)** Compile the two code blocks above (see `ex3.chpl`). What
  output do you expect? What is the output you get?

  Are the numbers in a totally random order?

## Dividing Up Work
The iterator above was very simple, but it doesn't handle dividing work.
For most data structures, the number of elements is not provided by
the number of cores, but is rather fixed or determined by something else.

The Chapel standard library provides an (unstable, package) module called
`RangeChunk`, which serves to divide up a range of integers into equal-ish
chunks. I say "ish" because it's not always possible to divide a range into
exactly equal chunks (how can you split 5 into 3 chunks?).

To define an example of an iterator that doesn't get to decide how much
work to do, we can define a `count` iterator that accepts a "start" and "end"
value, and yields all integers in that range. The serial version is as follows:

```Chapel
iter count(start: int, end: int) {
  for i in start..end {
    yield i;
  }
}
writeln("Serial");
for x in count(1, 10) {
  writeln(x);
}
```

In the parallel version, we can use `RangeChunk` to divide the range into
chunks, and then use `coforall` to iterate over those chunks and create tasks
for each. Then, within each task, we can iterate over the chunk and yield
the integers in that chunk.

```Chapel
use RangeChunk;
iter count(start: int, end: int, param tag) where tag == iterKind.standalone {
  coforall rng in chunks(start..end, here.maxTaskPar) {
    //            ^^^^^^ from the RangeChunk module
    for i in rng {
      yield i;
    }
  }
}
writeln("Parallel (", here.maxTaskPar, ")");
forall x in count(1, 10) {
  writeln(x);
}
```

This iterator can handle however many elements we ask it to count, while always
using exactly `maxTaskPar` tasks to do so. This should avoid tasking overheads
from creating too many tasks, enabling us to efficiently use all the parallelism
available to us.

* **(Exercise 4)** Adjust the parallel form of `count` to print each `rng`
  being iterated over. How do the ranges change as you increase the distance
  between `start` and `end`?

## Limitations of Standalone Parallel Iterators

As you might guess from their name, standalone parallel iterators stand alone.
You cannot use them in a loop with `zip`, for instance, because these iterators
have no way of telling other data structures what fragments to visit in each
task. Because of this, you also can't promote over multipel instances
of data structures with standalone parallel iterators.

Next, we'll look at _leader/follower_ iterators, which play nicely with
other data structures.

## Exercises
* **(Exercise 5)** Parallel iterators can contain more than just `coforall`.
  Define a parallel iterator that accepts two arrays, `A` and `Aidxs`,
  and uses a `forall` loop to iterate over one of the arrays, yielding
  the elements of `A` at the indices specified by `Aidxs`.

  Why might this be useful?

* **(Exercise 6)** The special `these` iterator is invoked when a value of
  a type is used in a `forall` loop. Define a new record `myRange`, which
  has two fields, `start` and `end`, and serial + standalone `these` iterator
  methods. Create a new instance of `myRange` and use it in a
  `forall` loop to print the integers in the range.

  You have just created a basic version of Chapel's `range` type, with a parallel
  iterator!
