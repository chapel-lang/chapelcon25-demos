// This demo tests your knowledge of some of the features that are interactions
//  between array, domain, and distribution features.

// Task 1: Create a 15x15 domain, distributed using a cyclic distribution.
//  Then create an array of reals over that domain. Initialize each element
//  to double its locale plus 1/2. Print the array.
use CyclicDist;

const cycDist = new cyclicDist(startIdx=(1,1));
const D = cycDist.createDomain({1..15,1..15});
var A1: [D] real;

forall a in A1 do 
  a = here.id * 2 + 0.5;

writeln(A1);

// Task 2: Use the `expand` function to create a interior domain that 
//  has 2 fewer elements in each direction. Create an array of reals over
//  this new domain. Initialize each element to the average of its neighbors 
//  in the array from Task 1. Take the average of the 5x5 grid of neighbors.
//  Print the second, smaller array.

const D2 = D.expand((-2,-2));
var A2: [D2] real;

forall (i,j) in D2 {
  A2[i,j] = + reduce A1[i-2..i+2,j-2..j+2];
}

writeln(A2);





