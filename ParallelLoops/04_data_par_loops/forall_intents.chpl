config const n = 7;
const cats : [1..n] string = ["Amber", "Winter", "Betty", "Goldie", "Colitas", "Alfredo", "CatGPT"];

// Mutable array of cat ages (to be updated in parallel)
var catAges: [1..n] int = [3, 4, 2, 5, 1, 7, 6];

var totalCats: int;

// Number of tasks that the current locale can run in parallel
const numTasks = here.maxTaskPar;

// Data-parallel loop
forall i in 1..n
  with (
    ref totalCats,               // Shared counter to update safely
    var scratchPad: [1..10] real // Task-private workspace
  )
{

  // Derive a pseudo "task index" — this isn’t a real task ID,
  // but provides a stable mapping across iterations.
  const taskIdx = (i - 1) % numTasks + 1;

  // 1. Use the slot corresponding to this task
  // Simulate some local temporary work on the cat’s scratch pad
  scratchPad[taskIdx] += (catAges[i] ** 1.2) / (taskIdx + 1);

  // 2. Use the scratchPad value to slightly modify the cat’s age
  catAges[i] += scratchPad[taskIdx]:int % 3;

  if i==1 then totalCats+=n; // Safe to do it like this

  writeln("🐾 ", cats[i], " has scratched it's scratch pad ", scratchPad[taskIdx], " times");

}

writeln("Total cats processed: ", totalCats);
writeln("New ages after playtime and enrichment: ", catAges);
