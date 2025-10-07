config const n = 11;
const cats: [1..n] string = ["Amber", "Winter", "Betty", "Goldie", "Colitas", "Alfredo", "CatGPT", "Ziggy", "Travy", "Cadence", "Teddy"];


// Shared array of pens — one per task
var catPens: [1..here.maxTaskPar] string;
var totalCats: int = 0;

// Data-parallel loop
forall i in 1..n
  with (ref catPens, var scratchPad: string, ref totalCats)
{
  // Determine which pen (task) this iteration belongs to
  const penIdx = (i-1) % here.maxTaskPar + 1;

  // Each task has its own scratchPad (task-private)
  // Here we simulate it by reading current pen contents first
  scratchPad = catPens[penIdx];

  // Append the current cat
  scratchPad += cats[i] + " ";

  // Write back to the shared array
  catPens[penIdx] = scratchPad;

  writeln("🐾 Cat ", cats[i], " went to pen ", penIdx);

  // Update total cats processed (shared scalar)
  if i == 1 then totalCats += n;
}

writeln("Total cats: ", totalCats);
writeln("Final cat pens: ", catPens);