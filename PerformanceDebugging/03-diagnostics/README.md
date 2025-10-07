## Using `CommDiagnostics`

### Exercise 7: Compile, Run, Observe the output

Now that we are using distributed arrays, let's check the current performance.


```
> chpl CoolStencil.chpl --fast           # compile 
> ./CoolStencil --n=2_000 -nl2
> ./CoolStencil --n=2_000 -nl8
```

Observe the printed table as you add more locales.

### Exercise 8: Disable Remote Cache for Easier Debugging

To simplify the table, it is a good idea to disable an optimization called
"remote cache", which is a software cache in the Chapel runtime.

```
> chpl CoolStencil.chpl --no-cache-remote --fast
> ./CoolStencil --n=2_000 -nl2
> ./CoolStencil --n=2_000 -nl8
```

Observe the printed table as you add more locales.

### What's next?

Do you see anything wrong in the table? How can you adjust the code to fix the
issue?

See `04-scalable/CoolStencil.chpl` for a way to do that.
