# 🧵 Data Parallel Loops in Chapel

In the previous sections, we've become familiar with task parallelism
using `coforall` and the concept of task intents.

Data parallel loops provide a higher-level, more abstract way to express
parallelism over data collections, relying on the Chapel runtime system
to determine the optimal concurrency for the job.

We’ll cover the three main data-parallel loop forms:

1. `foreach` — simple, vectorizable data parallelism
2. `forall` — full-featured, task-parallel data iteration
3. Square-bracket loops `[ ]` — Chapel’s shorthand for “may-parallel” iteration

We’ll finish by introducing promotion, Chapel’s feature for implicit parallelism.

## 1. The Simplest Data Parallel Loop: `foreach`

A `foreach` loop asserts that iterations are order-independent
and should be parallelized if possible by the compiler
(for example, through SIMD or GPU execution).

### What it is

`foreach` expresses element-wise work that *could* be
parallelized at a low level — ideal for short, pure,
side-effect-free computations.

### What it is **not**

Crucially, a `foreach` loop will not implement its iterations using
multiple Chapel tasks or software threads.

If a Chapel program only used `foreach` loops, it would never leverage
the multiple processor cores or distinct compute nodes of a modern
system via the Chapel tasking layer.

If we simply want to iterate over our list of cats,
applying the operation in a vectorizable manner (no new Chapel tasks needed):

```chpl

const cats = ["Amber", "Winter", "Betty", "Goldie", "Colitas", "Alfredo", "CatGPT"];

foreach catName in cats do
  writeln("Hello, " + catName + "!");

```
This code is order-independent, efficient, and entirely
serial in Chapel’s tasking sense.
But it’s still “data parallel” from the compiler’s perspective.

## 2. The Powerful Data Parallel Loop: `forall`


The `forall` statement is Chapel's central construct for expressing data
parallelism.

Unlike `foreach`, `forall` loops have the potential to be implemented
using multiple Chapel tasks. This allows them to utilize multiple cores
and compute nodes.

The actual number of tasks used by a `forall` loop is determined by its
iterable expression (which provides a parallel iterator) and is
typically proportional to the available hardware parallelism.

The concept of parallel iterators, and how to write them is beyond the
scope of this tutorial, and will be covered in tomorrow's session.


### `forall` Intents, Shadow Variables, and Task-Private Variables

Just like we had task intents in `coforall` loops, we have the same
kind of intents in `forall` loops.
Similarly, when a `forall` loop references a variable declared outside
its scope (an "outer variable"), **shadow variables** are introduced.

By default, for simple scalar types, the shadow variable captures the
value of the outer variable, creating a const shadow copy. To allow
modification of the original outer variable, we must explicitly use a
with clause and specify the `ref` intent.

Arrays, however, follow their declaration’s mutability by default
(i.e. unless specified otherwise):
* `var` arrays are passed by `ref`
* `const` arrays are passed by `const ref`

`forall` loops also support task-private variables, just like `coforall`
loops.
However, the way we create them is inside `with` statements, because
the number of tasks spawned by the `forall` is not necessarily the
same as the number of iterations of the `forall`.

#### Example: Counting and Scratch Space

Imagine we are tracking the total number of cats we've processed
(`totalCats`), and we need a mutable, complex object created once per
processing task (e.g., a large buffer or log) that is task-private.

```chpl
config const n = 7;
const cats : [1..n] string = ["Amber", "Winter", "Betty", "Goldie", "Colitas", "Alfredo", "CatGPT"];

// Mutable array of cat ages (to be updated in parallel)
var catAges: [1..n] int = [3, 4, 2, 5, 1, 7, 6];

var totalCats: int;

// Number of tasks that the current locale can run in parallel
const numTasks = here.maxTaskPar;

// Data-parallel loop
forall i in 1..n
  with (
    ref totalCats,               // Shared counter to update safely
    var scratchPad: [1..10] real // Task-private workspace
  )
{

  // Derive a pseudo "task index" — this isn’t a real task ID,
  // but provides a stable mapping across iterations.
  const taskIdx = (i - 1) % numTasks + 1;

  // 1. Use the slot corresponding to this task
  // Simulate some local temporary work on the cat’s scratch pad
  scratchPad[taskIdx] += (catAges[i] ** 1.2) / (taskIdx + 1);

  // 2. Use the scratchPad value to slightly modify the cat’s age
  catAges[i] += scratchPad[taskIdx]:int % 3;

  if i==1 then totalCats+=n; // Safe to do it like this

  writeln("🐾 ", cats[i], " has scratched it's scratch pad ", scratchPad[taskIdx], " times");

}

writeln("Total cats processed: ", totalCats);
writeln("New ages after playtime and enrichment: ", catAges);
```


##### Key Takeaways from the Example:

1. Forall Intent (`ref totalCats`): We use ref intent because the
    default intent for scalar variables captures the value at task
    creation time (a const shadow copy). `ref` makes the shadow
    variable an alias for the outer variable, allowing modification.

2. Shadow Variable: Inside the loop, `totalCats` refers to the shadow
    variable corresponding to the outer `totalCats`.

3. Task-Private Variable (`var scratchPad`): This variable exists only
    for the duration of each task spawned, is introduced in the with clause, and
    is unrelated to any outer variable of the same name.


## 3. Square-Bracket Loops: Must-Parallel vs. May-Parallel

Chapel offers a shorthand syntax using square brackets, `[ ]`, for data
parallel loops. This form is key to understanding the concept of
**"may-parallelism."**

| Loop Form      | Keyword | Parallelism Requirement             | Behavior                                                                                                  |
|----------------|----------|------------------------------------|-----------------------------------------------------------------------------------------------------------|
| Must-parallel  | `forall` | Requires a parallel iterator       | Results in an error if the iterable does not support parallel iteration                                   |
| May-parallel   | `[ ]`    | Uses parallel iterator if available | Falls back to serial, order-independent iteration (like `foreach`) if no parallel iterator is found       |

### Example: Applying a Filter to Cats

```chpl
const cats = ["Amber", "Winter", "Betty", "Goldie", "Colitas", "Alfredo", "CatGPT"];

// May-Parallel Loop (Expression form)
// If the array 'cats' provides a parallel iterator (which standard arrays do),
// this executes in parallel (like a forall expression).
// If no parallel iterator existed, it would execute serially (like a foreach).
var loudCats = [name in cats] if name.size > 5 then name + " (LOUD!)";

writeln("The loud cats: ", loudCats);
```

The square brackets replace the `for[each|all]` and `do` keywords.
Since standard arrays provide parallel iterators, the loop above will be
computed in parallel.

#### Side Note: Filtering Predicates

The `if name.size > 5 then ...` acts as a filtering predicate,
meaning only matching elements contribute to the result.

See https://chapel-lang.org/docs/language/spec/data-parallelism.html#filtering-predicates-in-forall-expressions for more.

## 4. Promotion (Implicit Data Parallelism)

Promotion is a language feature where calling a function or
operator that expects a single scalar argument with a collection
(like an array, range, or domain) triggers implicit data parallelism.

Promotion is equivalent to an implicit `forall` loop that iterates
over the elements of the collection(s) in a zippered manner, passing
the respective elements into the procedure.

### Example: Calculating Cat Purr Factors
Let's define a simple procedure for a scalar input and then apply it to an array of cat ages.

```chpl
// Scalar function: expects a single integer
proc purrFactor(age: int): int {
  return age * 2 + 1; // Simple calculation
}

// Array of cat ages
const catAges = [1, 4, 2, 3, 5, 4, 6]; // Example ages

// Promotion: Calling purrFactor with an array of integers (catAges)
// The function expects a scalar (int), but receives an array ([] int).
// Chapel automatically promotes the function over the array.
var factorArray = purrFactor(catAges);

writeln("Cat Ages: ", catAges);
writeln("Purr Factors (promoted): ", factorArray);

// Example Output:
// Cat Ages: 1 4 2 3 5 4 6
// Purr Factors (promoted): 3 9 5 7 11 9 13
```

The call to `purrFactors` above is equivalent to:

```chpl
var factorArray = forall age in catAges do purrFactor(age);
```

Promotion works for:

* Functions (f(A))
* Operators (A + B)
* Array indexing (A[B])

It’s one of Chapel’s most elegant language features — often replacing explicit `forall` loops entirely.

## ✅ Summary

* `foreach`: order-independent, vectorized, no tasks.
* `forall`: data-parallel, uses tasks, supports intents and task-private vars.
* `[ ]`: shorthand for may-parallel iteration or comprehension.
* Promotion: implicit `forall` behavior over collections.