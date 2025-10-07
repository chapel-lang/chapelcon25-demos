config const n = 11;
const cats: [1..n] string = ["Amber", "Winter", "Betty", "Goldie", "Colitas", "Alfredo", "CatGPT", "Ziggy", "Travy", "Cadence", "Teddy"];

// A mutable array representing how long each cat has been awake (in hours)
var awakeHours: [1..n] int = [3, 5, 2, 7, 1, 4, 6, 5, 6, 2, 4];

// Each cat will nap for 2 hours, in parallel
forall i in 1..n
{
  awakeHours[i] = max(0, awakeHours[i] - 2);
}

writeln("Updated awake hours: ", awakeHours);
