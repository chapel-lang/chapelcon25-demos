## Performance Tips and Debugging in Chapel

This directory contains exercises to be used as part of [ChapelCon
'25](https://chapel-lang.org/chapelcon25/) tutorial sessions.

The example revolves around a 2D, 5-point stencil proxy application, where the
directories have gradually evolving code to achieve performance and scalability.

- `01-parallel`: Base implementation of a non-distributed, parallel stencil
  implementation including performance reporting. While largely an acceptable
  implementation, somewhere in there, there is a bad practice that we will
  diagnose and fix during this session.

- `02-distributed`: Same application, but with distributed data. This version
  still carries the bad practice mentioned above. It will cause the application
  to _not_ scale on multinode settings.

- `03-diagnostics`: Behavior-wise, everything is the same. But this version
  introduces `CommDiagnostics` to understand the reason for bad scaling.

- `04-scalable`: This fixes the seemingly innocent bad practice we've had since
  `01-parallel`. This is the version that should scale.

## My Environment

I will use Chapel 2.6 on two different systems for this set of codes:

- **Desktop:** Single-socket Intel i5-11400 @ 2.60GHz with 6-cores
- **Supercomputer:**
  - HPE Apollo configuration
  - InfiniBand HDR 200 GB/s interconnect
  - Dual-socket Xeon 8360Y CPU @ 2.40GHz with 72-cores per socket
  - 512 GB DDR4-3200 memory per node
  - Up to 65 nodes (number of nodes I will use will depend on availability)
