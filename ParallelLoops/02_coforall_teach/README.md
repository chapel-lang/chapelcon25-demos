# 🧵 Task Parallelism in Chapel: `coforall` Loops

Now that we’ve seen serial loops, it’s time to explore how Chapel creates and manages parallel tasks.

The main construct for task parallelism in Chapel is the `coforall` loop.

## 🚀 What is a coforall Loop?

A `coforall` loop spawns a separate task for each iteration of the loop body.

Each iteration runs **concurrently**, not sequentially.
Chapel automatically handles task creation, scheduling, and cleanup.

Here’s the simplest example:

[coforall.chpl](./coforall.chpl)
```chapel
const cats = ["Amber", "Winter", "Betty", "Goldie", "Colitas"];

coforall (i, cat) in zip(1..5, cats) do
  writeln("🐈 Cat ", cat, " reporting from task ", i);
```

Each task runs independently — Chapel doesn’t wait for one to finish before starting the next.


## ⚙️ How Tasks Work

Each coforall iteration corresponds to a **task** in Chapel’s runtime.
You can think of tasks as lightweight threads that Chapel manages for you.

The number of tasks that can actually run in parallel depends on your system and Chapel configuration.
You can query this using:

```chpl
writeln("Maximum parallel tasks on this locale: ", here.maxTaskPar);
```

>[!NOTE]
>`here` is a special variable that refers to the current `Locale` that the program is executing on.
>
>If you’re experimenting on your own machine, `here.maxTaskPar` usually corresponds to the number of cores.


## 🧠 Shadow Variables and Task Intents

When a `coforall` loop body references variables from outside the loop (known as "outer variables"), Chapel decides how those variables are handled.
Each task may:

* Work on its own copy (a ***shadow variable***), or
* Access the shared variable directly (if you specify a **task intent** explicitly).

Each task created by the task construct gets its own set of shadow variables, one per outer variable.

> [!WARNING]
> Shadow variables and task itents do not protect against data races. See [about data races](#about-data-races).

Let’s illustrate the difference:

### Without task intents (each task has its own copy)

[coforall_shadow.chpl](./coforall_shadow.chpl)
```chpl
const ages = [3, 5, 2, 4, 1];
var ageUpBy = 2;

coforall (cat, age) in zip(cats, ages) do
  writeln(cat, " is now ", age + ageUpBy, " years old.");
```

Each task gets its own **copy** of `ageUpBy`.
This is fine because all tasks only read the variable — no sharing or races involved.

### With task intents (shared access)

If we actually want each task to update a shared variable, we need to change the task intent using a `with` clause.

[coforall_intent.chpl](./coforall_intent.chpl)
```chpl
const cats = ["Amber", "Winter", "Betty", "Goldie", "Colitas"];
var nameLength: [1..5] int;

coforall (i, cat) in zip(1..5, cats) with (ref nameLength) do
  nameLength[i] = cat.size;

writeln(nameLength);
```

Each task writes to a different index of the shared `nameLength` array.
Because there’s no overlap between indices, this is safe even with `ref` intent.

> [!NOTE]
> Arrays declared with `var` are passed in by `ref` by default. So technically the intent above is redundant.

You can learn more about task intents here: https://chapel-lang.org/docs/primers/taskParallel.html#task-intents

## About Data Races
⚠️
Data races happen when multiple tasks read and write the same variable at the same time.

⚠️
Shadow variables and task intents help manage variable scope, but they don’t automatically make updates atomic.

> [!TIP]
> When tasks truly need to share mutable state (like a shared counter), Chapel provides safer mechanisms — such as `sync`, `atomic`, or reduction operations — which we’ll explore later.

See [coforall_bad_race.chpl](./coforall_bad_race.chpl) for an example of a race condition.

## Task private variables.

If we declare a variable inside the body of a `coforall`, a copy of the variable is created for each task, and cannot be accessed by other tasks.
It goes out of scope (and is deallocated) once the task finishes.

## 🧩 Next Up

In the next exercise, you’ll use `coforall` loops to coordinate multiple “cat workers” performing independent tasks — safely, without stepping on each other’s memory space.