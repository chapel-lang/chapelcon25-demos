# Introduction to Reduce Intents

When a `forall` loop modifies an outer variable with `ref`, multiple tasks can race if they try to write to it at the same time.

**Reductions** solve this problem: they combine values from multiple iterations safely into a single result (e.g., sum, min, max).

## How Reduce Intents Work

1. **Task-local accumulation**: Each task gets a shadow variable, initialized to the identity of the reduction operation (0 for `+`, `-inf` for `max`).
2. **Accumulate values**: The task adds or compares values into its shadow variable.
3. **Combine results**: When tasks finish, their shadow variables are safely combined into the outer variable.
4. **Outer variable inclusion**: The initial value of the outer variable is included in the final reduction.

---

## 🐱 Cat Example: Total Name Length

[sum_reduce.chpl](./sum_reduce.chpl)
```chpl
const cats = ["Amber", "Winter", "Betty", "Goldie", "Colitas", "Alfredo", "CatGPT"];
var totalLength = 0;

forall catName in cats
  with (+ reduce totalLength)
{
  totalLength += catName.size; // Each task safely accumulates into its shadow
}

writeln("Total kitty energy (name lengths): ", totalLength);
// Expected: 42
```

### `reduce=`

We technically have a duplication of the operation we
are doing here.
`totalLength += catName.size` specifies `+` as the reduction again.


We can replace `+=` with `reduce=` in the body of the loop
in order to eliminate the need to specify the reduction
operator twice.
`totalLength reduce= catName.size`

> [!NOTE]
> `reduce=` is how promoted reductions in Chapel are implemented
>
> Ex:
> If you write `+ reduce bla`
>
> ```chpl
> var accTmp: bla.eltType;
> [b in bla] with (+ reduce accTmp) {
>   accTmp reduce= b;
> }
> // accTmp now contains the result of `+ reduce bla`
> ```

## 🐱 Cat Example: Max Name Length

[max_reduce.chpl](./max_reduce.chpl)
```chpl
const cats = ["Amber", "Winter", "Betty", "Goldie", "Colitas", "Alfredo", "CatGPT"];
var maxLength = 0;

forall catName in cats
  with (max reduce maxLength)
{
  maxLength reduce= catName.size; // Accumulate maximum per task
}

writeln("Longest cat name length: ", maxLength);
// Expected: 7
```
