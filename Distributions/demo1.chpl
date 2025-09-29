// This demo is to show the very basics of using arrays and domains.
// Distributions are not part of this demo.

// 1. Declaring an array, anonymous domain
var A: [1..10] int;

// 2. Declaring an array over a named domain
const D = {1..10};
var B: [D] int;


// 3. Some options for filling an array. Equivalent:
for i in 1..10 do
  B[i] = i;

for i in B.domain do 
  B[i] = i;

for i in D do
  B[i] = i;



// 4. Multi-dimensional domains and arrays

const D2 = {1..10, 1..10};
var C: [D2] real;

for (i,j) in D2 do
  C[i,j] = 2.0 ** (i/j);


// 5. Arrays of custom types elements

