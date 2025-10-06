# 📘 Loop basics in Chapel


Before our cats go parallel, we recall that Chapel supports standard `for` loops just like any other language:

```chpl
const cats = ["Winter", "Betty", "Goldie", "Colitas"]

for i in 0..3 do writeln(cats[i]);
```

The `for` loop invokes a serial iterator for the object being iterated over.

In this example, the loop iterates through the range `1..3` in order, using a serial iterator. Only one iteration runs at a time — a single thread of control.


Chapel also supports zippered iteration:


```chpl
for (i, cat) in zip(0..3, cats) {
  writeln("Meow from cat ", i, ": ", cat);
}
```


There are also other kinds of serial loops in Chapel, like `while`, `do ... while`, etc.

## 🧩 From Serial to Parallel

In this tutorial, we’ll focus on the parallel loop constructs in Chapel — where multiple iterations or tasks can execute concurrently.

There are two main categories of parallel loops in Chapel:

1. Task Parallel Loops
  * These explicitly create multiple tasks that can execute concurrently.
  * The key construct here is the `coforall` loop.

2. Data Parallel Loops
  * These automatically distribute work across tasks when iterating over collections of data.
  * The main constructs here are `foreach`, `forall`, and the square bracket loop (`[]`).


### 🐱 What’s Next

In the next section, we’ll explore task parallelism with `coforall`.