// This exercise tests your ability to declare different types of distributions

// Task 1: Create a distributed, 30x30 array of integers. 
//  Distribute the array's rows using a BlockDist, and initialize
//  the array so that the value is 1 for elements on locale 0 and 0 elsewhere.
//  Then print the array.
use BlockDist;
const D = {1..30,1..30};
const bDist = new blockDist(boundingBox=D);
const blockDomain = bDist.createDomain(D);
var A: [blockDomain] int;
forall a in A do
  a = if a.locale.id == 0 then 1 else 0;

writeln(A);
// Task 2: Create a similar array, but distribute the elements using a 
//  CylicDist distribution. Print the array.
use CyclicDist;
const cDist = new cyclicDist(startIdx=(1,1));
const cyclicDomain = cDist.createDomain(D);
var B: [cyclicDomain] int;
forall b in B do
  b = if b.locale.id == 0 then 1 else 0;

writeln(B);
// Task 3: Create a third array containing the sum of the first two arrays. 
//  Try out some different distributions. Change up the distributions of 
//  the first two arrays. See how different distribution choices change 
//  how much communication happens. The code to print the communication 
//  is included below.

// https://chapel-lang.org/docs/modules/standard/CommDiagnostics.html
use CommDiagnostics; 
var C: [cyclicDomain] int;

startCommDiagnostics();

C = A + B;

stopCommDiagnostics();
writeln("\n\n");
writeln(getCommDiagnostics());


