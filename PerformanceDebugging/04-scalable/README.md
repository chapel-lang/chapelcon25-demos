## Scaling the application

### Exercise 9: (Optional) Compile, Run, Observe the output

To see the impact of this exercise, you have to use a supercomputer or a
cluster.

Now that we have fixed the issue, let's collect some numbers.

```
> chpl CoolStencil.chpl --fast           # compile 
> ./CoolStencil --n=20_000 -nl2
> ./CoolStencil --n=20_000 -nl8
```

Record `Stencil performance`. Does the performance get better as you add more
nodes?

### Exercise 10: Observe the impact of the data size

Grow your data and see the impact.

```
> ./CoolStencil --n=200_000 -nl16   # adjust the numbers based on your
> resources.
> ./CoolStencil --n=800_000 -nl48
```

Record `Stencil performance`
