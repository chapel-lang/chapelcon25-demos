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

> [!IMPORTANT]
> If a Chapel program only used `foreach` loops, it would never leverage
> the multiple processor cores or distinct compute nodes of a modern
> system **via the Chapel tasking layer**.

If we simply want to iterate over our list of cats,
applying the operation in a vectorizable manner
(no new Chapel tasks needed):

[foreach.chpl](./foreach.chpl)
```chpl
record Cat {
  var name: string;
  var trait: string;
  var purrHP: int; // V8 purr power
}

var cats = [
  ... // Populate cats
];

const traits = ["Sleeps on keyboards", "Chases shadows", "Loves tuna art",
                "Steals socks", "Hums in the shower", "Invents cat memes", "Debugs humans"];

// Parallel update: birthday, trait, and V8 purr
foreach i in 0..#cats.size {
  cats[i].trait = traits[i];
  cats[i].purrHP = 400 + i*50; // Engine horsepower
}
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

> [!NOTE]
> Different data structures have different ways to parallelize operations
> on them. `forall` loops let the data structure being iterated to decide
> how to divvy up the work through their parallel iterators.


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

#### Example: Cats in pens

Imagine we are trying to put cats in pens, and we have more cats
than pens (tasks), therefore multiple cats go in the same pen.

[forall_intents.chpl](./forall_intents)
```chpl
config const n = 11;
const cats: [1..n] string = ["Amber", "Winter", "Betty", "Goldie", "Colitas", "Alfredo", "CatGPT", "Ziggy", "Travy", "Cadence", "Teddy"];


// Shared array of pens — one per task
var catPens: [1..here.maxTaskPar] string;
var totalCats: int = 0;

// Data-parallel loop
forall i in 1..n
  with (ref catPens, var scratchPad: string, ref totalCats)
{
  // Determine which pen (task) this iteration belongs to
  const penIdx = (i-1) % here.maxTaskPar + 1;

  // Each task has its own scratchPad (task-private)
  // Here we simulate it by reading current pen contents first
  scratchPad = catPens[penIdx];

  // Append the current cat
  scratchPad += cats[i] + " ";

  // Write back to the shared array
  catPens[penIdx] = scratchPad;

  writeln("🐾 Cat ", cats[i], " went to pen ", penIdx);

  // Update total cats processed (shared scalar)
  if i == 1 then totalCats += n;
}

writeln("Total cats: ", totalCats);
writeln("Final cat pens: ", catPens);
```


##### Key Takeaways from the Example:

1. Forall Intent (`ref catPens`): Technically redundant since arrays
    are passed by `ref` by default.

2. Shadow Variable: Inside the loop, `totalCats` refers to the shadow
    variable corresponding to the outer `totalCats`.

3. Task-Private Variable (`var scratchPad`): This variable exists only
    for the duration of each task spawned, is introduced in the with
    clause, and is unrelated to any outer variable of the same name.

> [!IMPORTANT]
> `scratchPad` is actually shared across some iterations since the
> number of iterations (11 in this case) is greater than the number of
> tasks (8 on my machine).
>
> This is an important distinction, these variables are
> **task-private** not iteration-private.


## 3. Square-Bracket Loops: Must-Parallel vs. May-Parallel

Chapel offers a shorthand syntax using square brackets, `[ ]`, for data
parallel loops. This form is key to understanding the concept of
**"may-parallelism."**

| Loop Form      | Keyword | Parallelism Requirement             | Behavior                                                                                                  |
|----------------|----------|------------------------------------|-----------------------------------------------------------------------------------------------------------|
| Must-parallel  | `forall` | Requires a parallel iterator       | Results in an error if the iterable does not support parallel iteration                                   |
| May-parallel   | `[ ]`    | Uses parallel iterator if available | Falls back to serial, order-independent iteration (like `foreach`) if no parallel iterator is found       |

### Example: Applying a Filter to Cats

[may_parallel.chpl](./may_parallel.chpl)
```chpl
const cats: [1..11] string = ["Amber", "Winter", "Betty", "Goldie", "Colitas", "Alfredo", "CatGPT", "Ziggy", "Travy", "Cadence", "Teddy"];

// May-Parallel Loop (Expression form)
// If the array 'cats' provides a parallel iterator (which standard arrays do),
// this executes in parallel (like a forall expression).
// If no parallel iterator existed, it would execute serially (like a foreach).
var loudCats = [name in cats] if name.size > 5 then name + " (LOUD!)";

writeln("The loud cats: ", loudCats);
```

The square brackets replace the `for[each|all]` and `do` keywords.

Since standard arrays provide parallel iterators, the loop above
will be computed in parallel.

#### Filtering Predicates
> [!NOTE]
> The `if name.size > 5 then ...` acts as a ***filtering predicate***,
meaning only matching elements contribute to the result.
>
> See [Filtering Predicates Docs](https://chapel-lang.org/docs/language/spec/data-parallelism.html#filtering-predicates-in-forall-expressions) for more.

## 4. Promotion (Implicit Data Parallelism)

Promotion is a language feature where calling a function or
operator that expects a single scalar argument with a collection
(like an array, range, or domain) triggers implicit data parallelism.

Promotion is equivalent to an implicit **may-parallel** loop that
iterates over the elements of the collection(s) in a zippered manner,
passing the respective elements into the procedure.

### Example: Calculating Cat Purr Factors
Let's define a simple procedure for a scalar input and then apply it to an array of cat ages.

[promotion.chpl](./promotion.chpl)
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
var factorArray = [age in catAges] purrFactor(age);
```
And since arrays have parallel iterators, this in turn is equivalent to:

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
* Promotion: implicit may-parallel behavior over collections.