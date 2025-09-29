// This demo introduces some more advanced features of arrays and domains


// 1. parallel iteration
const D = {1..100, 1..100};
var A: [D] real;

// Fill the array with random numbers
use Random;
fillRandom(A);

var B: [D] complex;

// Compute Euler's identify for our values, in parallel
use Math;
forall (i,j) in D {
  B[i,j] = cos(A[i,j]) + 1i * sin(A[i,j]);
}


// 2. Scalar promotion 

var C: [D] complex;
C = cos(A) + sin(A) * 1i;

writeln("After scalar assignment, does C == B? ", && reduce (C == B));


// 3. Parallel reductions
var sum = + reduce C;
writeln("Sum of the array: ", sum);

var realPart = C.re;
var (maxVal, maxLoc) = maxloc reduce zip(realPart, realPart.domain);
writeln("Maximum real value is ", maxVal, " at index ", maxLoc, ". Full value is: ", C[maxLoc]);


// 4. Domain `expand`
const D2 = {1..10, 1..10};
var E: [D2] real = 0;

for (i,j) in D2.expand((-1, -1)) {
  E[i,j] = 1.0;
}
writeln(E);
