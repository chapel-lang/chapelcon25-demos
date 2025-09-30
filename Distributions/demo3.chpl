// This demo introduces the basics of distributions. 

use BlockDist, CyclicDist, BlockCycDist;

config const n = 8;
// 1. Declaring and using a distribution

const Space1 = {1..n, 1..n};
const BlockDist1 = new blockDist(boundingBox=Space1);
const BlockDomain1 = BlockDist1.createDomain(Space1);
var A: [BlockDomain1] int;

forall a in A do
  a = here.id;

writeln("BlockDist A");
writeln(A);
writeln("\n\n");

// 2. Partial domains

const BlockDomain2 = BlockDist1.createDomain({1..n/2 + 2, 1..n});
var B: [BlockDomain2] int;

forall b in B do
  b = here.id;

writeln("BlockDist Subdomain B");
writeln(B);
writeln("\n\n");




// 3. CyclicDist

const CyclicDist1 = new cyclicDist(startIdx=(1,1));
const CyclicDomain1 = CyclicDist1.createDomain(Space1);
var C: [CyclicDomain1] int;

forall c in C do 
  c = here.id;

writeln("CyclicDist C");
writeln(C);
writeln("\n\n");