## Using distributed arrays

### Exercise 3: Compile, Run, Record Results

Now that we are using distributed arrays, let's check the current performance.


```
> chpl CoolStencil.chpl --fast      # compile 
> ./CoolStencil --n=20_000          # run with 20k x 20k grid
```

Record `Stencil Performance (GB/s):`.


Note that even though we are using distributed types, our configuration is still
for single-node. There might be small overhead caused by the distributed arrays,
though hopefully nothing too big.

### Exercise 4: Use "oversubscribed" multi-locale setup locally

You can configure Chapel for multi-locale execution even in a single
workstation. Let's give it a try. The following is sufficient on Linux:

```
export CHPL_COMM=gasnet
export GASNET_SPAWNFN=L
```

IMPORTANT: You have to rebuild Chapel after making this change.

Now, let's re-run in this config

```
> chpl CoolStencil.chpl --fast      # compile 
> ./CoolStencil --n=20_000 -nl1     # run with 20k x 20k grid using 1 locale
```

Record `Stencil Performance (GB/s):`.


### Exercise 5: Use multiple locales in a single system

You can use multiple locales in this setup. But note that those locales will be
using the same hardware. **This will result in really bad performance**, but
nonetheless it can be useful for distributed memory debugging and optimization
without having to use an actual supercomputer. We will do exactly that in the
next exercise.

Run the same executable you compiled with 2 locales this time:

```
> ./CoolStencil --n=20_000 -nl2     # run with 20k x 20k grid using 2 locales
```

Record `Stencil Performance (GB/s):`.

### Exercise 6: (Optional) Use a supercomputer to run this

The benefit of what we have done so far is that our application runs correctly
on multiple nodes. Let's observe its performance.

On this system, my setup looks like:

```
> printchplenv --anonymize
CHPL_TARGET_PLATFORM: hpe-apollo
CHPL_TARGET_COMPILER: llvm
CHPL_TARGET_ARCH: x86_64
CHPL_TARGET_CPU: native *
CHPL_LOCALE_MODEL: flat
CHPL_COMM: gasnet *
  CHPL_COMM_SUBSTRATE: ibv
  CHPL_GASNET_SEGMENT: large
CHPL_TASKS: qthreads
CHPL_LAUNCHER: gasnetrun_ibv *
CHPL_TIMERS: generic
CHPL_UNWIND: none
CHPL_TARGET_MEM: jemalloc
CHPL_ATOMICS: cstdlib
  CHPL_NETWORK_ATOMICS: none
CHPL_GMP: bundled
CHPL_HWLOC: bundled
CHPL_RE2: bundled
CHPL_LLVM: system *
CHPL_AUX_FILESYS: none
```

Compile as before and run again:

```
> ./CoolStencil --n=20_000 -nl2     # run with 20k x 20k grid using 2 locales
```

Record `Stencil Performance (GB/s):`.

### What's next?

It doesn't seem to scale at all. Can you use `CommDiagnostics` to fix
performance?

See `03-diagnostics/CoolStencil.chpl` for a way to do that.
