// This demo is to show the very basics of using arrays and domains.
// Distributions are not part of this demo.

// 1. Declaring an array, anonymous domain
var A: [1..10] int;

// 2. Declaring an array over a named domain
const D1 = {1..10};
var B: [D1] int;


// 3. Some options for filling an array. Equivalent:
for i in 1..10 do
  B[i] = i;

for i in B.domain do 
  B[i] = i;

for i in D1 do
  B[i] = i;

writeln("B:\n", B);
writeln("\n\n");

// 4. Multi-dimensional domains and arrays

const D2 = {1..10, 1..10};
var C: [D2] real;

for (i,j) in D2 do
  C[i,j] = 2.0 ** (i:real/j:real);

writeln("C:\n", C);
writeln("\n\n");

// 5. Arrays of more complex types

use List;
const D3 = {1..3, -5..-2, 2..<6};
var E: [D3] list(string);

for (i,j,k) in D3 {
  E[i,j,k].pushBack(i:string);
  E[i,j,k].pushBack(j:string);
  E[i,j,k].pushBack(k:string);
}

var F: [D3] string;
for (i,j,k) in D3 {
  F[i,j,k] = ",".join(E[i,j,k].toArray());
}

writeln("F:\n", F);
writeln("\n\n");
