// The purpose of this exercise is to experiment with performance analysis and 
//  learn about another distribution: the StencilDist.

// Remember, compile with `--fast` for the best performance!

// Task 1: Create a new function, computeWithStencilDist, based on the computeWithBlockDist
//  function below. You'll need to make 3 changes:
//    1. Change the distribution from a blockDist to a stencilDist. Don't forget to include
//        the correct module!
//    2. Add the "fluff" argument to the StencilDist. 
//    3. Add the `updateFluff` call to the computation.
// You can learn more about the `fluff` argument and the `updateFluff` method in the
//  documentation here: https://chapel-lang.org/docs/modules/dists/StencilDist.html

use Time, BlockDist, Random;

config const gridSize = 1000;

proc computeWithBlockDist() {
  // Create the block distributed domain
  var gridShape = {1..gridSize,1..gridSize};
  var blockDistribution = new blockDist(boundingBox=gridShape);
  var gridDomain = blockDistribution.createDomain(gridShape);
  
  // Create and initialize the two arrays for the computation
  var srcArray: [gridDomain] real;
  var dstArray: [gridDomain] real;
  fillRandom(srcArray);
  dstArray = 0.0;

  // Define the interior grid for the computation
  var innerGrid = gridDomain.expand((-1,-1));

  // Start a stopwatch to time the computation
  var s: stopwatch;
  s.restart();

  for t in 1..20 {
    forall (i,j) in innerGrid {
      dstArray[i,j] = 0.2 * (srcArray[i-1,j] + srcArray[i, j-1] + srcArray[i,j] + srcArray[i,j+1] + srcArray[i+1,j]);
    }
    dstArray <=> srcArray; // swap the arrays for the next iteration
  }

  s.stop();
  writeln(+ reduce dstArray); // Print to make sure the compiler doesn't optimize away the computation
  writeln("20 iterations using a BlockDist took ", s.elapsed(), " seconds");
}


use StencilDist;

proc computeWithStencilDist() {
  // Create the block distributed domain
  var gridShape = {1..gridSize,1..gridSize};
  var stencilDistribution = new stencilDist(boundingBox=gridShape, fluff=(1,1));
  var gridDomain = stencilDistribution.createDomain(gridShape);
  
  // Create and initialize the two arrays for the computation
  var srcArray: [gridDomain] real;
  var dstArray: [gridDomain] real;
  fillRandom(srcArray);
  dstArray = 0.0;

  // Define the interior grid for the computation
  var innerGrid = gridDomain.expand((-1,-1));

  // Start a stopwatch to time the computation
  var s: stopwatch;
  s.restart();

  for t in 1..20 {
    forall (i,j) in innerGrid {
      dstArray[i,j] = 0.2 * (srcArray[i-1,j] + srcArray[i, j-1] + srcArray[i,j] + srcArray[i,j+1] + srcArray[i+1,j]);
    }
    dstArray <=> srcArray; // swap the arrays for the next iteration
    srcArray.updateFluff();
  }

  s.stop();
  writeln(+ reduce dstArray); // Print to make sure the compiler doesn't optimize away the computation
  writeln("20 iterations using a StencilDist took ", s.elapsed(), " seconds");
}





// Run the two computations
computeWithBlockDist();
computeWithStencilDist();