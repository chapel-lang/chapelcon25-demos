This folder contains code and other files for the ChapelCon '25 Distributions Demo/Exercise session. 
It also includes a short primer on Chapel arrays.

There are 4 demos and 4 exercises. The suggested order is as follows:
- demo1
- demo2
- exercise1
- demo3
- exercise2
- exercise3
- demo4
- exercise4

There are also some solution files for the first three exercises, and reference outputs. 
Keep in mind that these reference outputs are using 2 locales. Running with different 
numbers of locales will produce different outputs.

The following is a bash command that will set up your Chapel configuration to use GASNET, which enables multi-locale runs, even on a laptop.
```
__gasnetconfig() {
    export CHPL_COMM=gasnet
    export GASNET_SPAWNFN=L
    export GASNET_ROUTE_OUTPUT=0
    export CHPL_GASNET_CFG_OPTIONS=--disable-ibv
    export GASNET_QUIET=Y
    export GASNET_MASTERIP=127.0.0.1
    export GASNET_WORKERIP=127.0.0.0

    export CHPL_TEST_TIMEOUT=500

    export CHPL_RT_OVERSUBSCRIBED=yes
}
```