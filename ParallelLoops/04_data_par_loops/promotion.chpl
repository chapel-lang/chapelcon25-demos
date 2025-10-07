// Scalar function: expects a single integer
proc purrFactor(age: int): int {
  return age * 2 + 1; // Simple calculation
}

// Array of cat ages
const catAges = [1, 4, 2, 3, 5, 4, 6]; // Example ages

// Promotion: Calling purrFactor with an array of integers (catAges)
// The function expects a scalar (int), but receives an array ([] int).
// Chapel automatically promotes the function over the array.
var factorArray = purrFactor(catAges);

// This is equivalent to the may-parallel loop:
// var factorArray = [age in catAges] purrFactor(age);

writeln("Cat Ages: ", catAges);
writeln("Purr Factors (promoted): ", factorArray);

// Example Output:
// Cat Ages: 1 4 2 3 5 4 6
// Purr Factors (promoted): 3 9 5 7 11 9 13
