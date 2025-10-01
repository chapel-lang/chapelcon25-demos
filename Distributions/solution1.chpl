// This first exercise tests your knowledge about creating, 
// initializing, and computing with basic arrays and domains


// Task 1: Create an 2D array of dimension 30x30 of integers.
//   Your index space should start at (1,1). For each element
//   of the array, set it to 1 if the column index evenly divides
//   the row index.
const n = 30;
var D = {1..n,1..n};
var A: [D] int;
for (i,j) in A.domain do
  A(i,j) = if (i % j) == 0 then 1 else 0;
writeln(A);

// Task 2: Create a 1D array that contains the sums of each row 
//   of the array you created in Task 1. Create a second array 
//   that contains the column sums. Print the row sums, then the
//   column sums.
var rowSums: [1..n] int;
var colSums: [1..n] int;
for (i,j) in A.domain {
  rowSums[i] += A[i,j];
  colSums[j] += A[i,j];
}
writeln(rowSums);
writeln(colSums);


// Task 3: Create a 1D array that contains the pairwise product 
//   of the arrays your created in Task 3. Do this without a loop.
//   Print the resulting array.
var product: [1..n] int = rowSums * colSums;
writeln(product);