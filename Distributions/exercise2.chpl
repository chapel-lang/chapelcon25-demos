// This exercise tests your ability to declare different types of distributions

// Task 1: Create a distributed, 30x30 array of integers. 
//  Distribute the array's rows using a BlockDist, and initialize
//  the array so that the value is 1 for elements on locale 0 and 0 elsewhere.
//  Then print the array.


// Task 2: Create a similar array, but distribute the elements using a 
//  CylicDist distribution. 


// Task 3: Create a third array containing the sum of the first two arrays. 
//  Try out some different distributions. Change up the distributions of 
//  the first two arrays. See how different distribution choices change 
//  how much communication happens. The code to print the communication 
//  is included below.

// https://chapel-lang.org/docs/modules/standard/CommDiagnostics.html
use CommDiagnostics; 


startCommDiagnostics();

// TODO: Your summing code here

stopCommDiagnostics();
writeln(getCommDiagnostics());


