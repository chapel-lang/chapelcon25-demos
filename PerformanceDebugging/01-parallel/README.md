## Familiarizing w/ Code & Environment

This is the base implementation of our stencil proxy application, intended to be
used in local configuration. In other words, even if you run this on a cluster,
it will only use a single node.

### Make sure to use the default & performant environment

- Here are the key parts of my `printchplenv` output for performance

```
CHPL_TARGET_PLATFORM: linux64
CHPL_TARGET_COMPILER: llvm
CHPL_TARGET_ARCH: x86_64
CHPL_TARGET_CPU: native *
CHPL_LOCALE_MODEL: flat
CHPL_COMM: none
CHPL_TASKS: qthreads
CHPL_TARGET_MEM: jemalloc
CHPL_ATOMICS: cstdlib
```

### Exercise 1: Compile, Run, Record Results

```
> chpl CoolStencil.chpl      # compile 
> ./CoolStencil --n=20_000   # run with 20k x 20k grid
```

Record `Stencil Performance (GB/s):`.

### Exercise 2: Use `--fast`

```
> chpl CoolStencil.chpl --fast      # compile 
> ./CoolStencil --n=20_000          # run with 20k x 20k grid
```

Record `Stencil Performance (GB/s):`.

### What's next?

Can you distribute the data using Chapel's default block distribution?

See `02-distributed/CoolStencil.chpl` for a way to do that.
