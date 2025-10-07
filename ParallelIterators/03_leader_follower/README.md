# Leader-follower parallel iterators

Let's take another look at our standalone `count` iterator:

```Chapel
iter count(start: int, end: int, param tag) where tag == iterKind.standalone {
  coforall rng in chunks(start..end, here.maxTaskPar) {
    for i in rng {
      yield i;
    }
  }
}
```

This is actually doing two distinct pieces of work:

1. Dividing up the work, and spawning up tasks to handle each piece.
2. Within each task, taking the work and yielding the values to the loop.

If we could somehow split the iterator into these two pieces, we could
make use of that to enable _other_ data structures to be iterated over
at the same time. For instance, we would be able to `zip` two arrays in parallel.

How would this work?
1. One data structure (the _leader_) would be responsible to dividing up the
   work and spawning tasks. Instead of yielding elements, it would yield
   _information about what work each task should do_.
2. In each task, all the data structures would receive the above specification,
   and _follow_ it. They wouldn't be spinning up their own tasks, but
   accepting a range of indices to iterate over, and yielding the values
   from their own data structures.

You can see how the standalone iterator is a special case of this:
it divides up the work, spawns tasks, and then, being the only data structure,
immediately takes the work ranges (`rng` above) and yields the values.

To split up the work, we use _two_ iterators, both of which yield different
things. The first yields descriptions of the work to do, and the second
yields the values from the data structure.

```Chapel
iter count(start: int, end: int, param tag) where tag == iterKind.leader {
  coforall rng in chunks(start..end, here.maxTaskPar) {
    var followThis = rng;
    yield followThis;
  }
}

iter count(start: int, end: int, followThis, param tag) where tag == iterKind.follower {
  var rng = followThis;
  for i in rng {
    yield i;
  }
}
```

Here, we are still using the `param tag` to distinguish between the two
iterators. Also notice that we accept the extra work using the `followThis`
argument. I've also made the leader yield `followThis` (copied from `rng`)
to be explicit about how the two are connected. The argument to the follower
_must_ be called `followThis` (it's passed by name). The leader can yield whatever
it wants (me using `followThis` is just a convention).

* ** (Exercise 7)** Modify the `ex7.chpl` file to `zip` two calls to `count`
  and iterate over them in parallel using a `forall` loop. Use different arguments
  to count: `1` and `10`, then `11` and `20`. What do you see printed?
  What should've been printed?

## Standard Patterns

As exercise 7 shows, our leader and follower are not quite correct. The
missing piece is that each individual follower normally has _different data_
to yield. You might, for instance, have an array be a follower. If that array
is zippered with `count(101, 110)`, how does the array know which of its
own elements correspond to these indices?

In fact, we take a convention: `followThis` should yield ranges that are
zero-indexed. Each follower must translate the zero-indexed ranges into values
that match what it wants to yield. We can make our `count` iterator create
zero-indexed ranges by subtracting the `start` value from the `followThis`
when yielding it, and adding it back when iterating over it.

Another convention we take is that, for N-dimensional data structures,
we make `followThis` be a tuple of ranges. Since our `count` iterator
is one-dimensional, we must return a single-element tuple
to match the expected type.

```Chapel
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
```

** (Exercise 8)** Modify the `ex8.chpl` file to `zip` a call to `count`
   with a new array of integers with 10 elements to make sure it works.

   Make the array have 20 elements. What happens?
