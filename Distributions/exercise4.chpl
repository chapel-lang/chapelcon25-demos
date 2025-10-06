// Task: Do a perforamnce comparison between using BlockDist and StencilDist for stencil
//  computations. The BlockDist code is below, including the code necessary to time the 
//  stencil computation. Try out using a StencilDist instead and compare the performance.

// Remember, compile with `--fast` for the best performance!

use Time, BlockDist, StencilDist, Random;

config const gridSize = 1000;
var gridShape = {1..gridSize,1..gridSize};
var blockDistGrid = new blockDist(boundingBox=gridShape);
var gridDomain = blockDistGrid.createDomain(gridShape);

var srcArray: [gridDomain] real;
var dstArray: [gridDomain] real;

// Initializing
fillRandom(srcArray);
dstArray = 0.0;

var innerGrid = gridDomain.expand((-1,-1));

var s: stopwatch;
s.restart();
for t in 1..20 {
  forall (i,j) in innerGrid {
    dstArray[i,j] = 0.2 * (srcArray[i-1,j] + srcArray[i, j-1] + srcArray[i,j] + srcArray[i,j+1] + srcArray[i+1,j]);
  }
  dstArray <=> srcArray; // swap the arrays for the next iteration
}
s.stop();
writeln(+ reduce dstArray);
writeln("20 iterations took ", s.elapsed(), " seconds");
