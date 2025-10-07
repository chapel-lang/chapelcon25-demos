config const n = 11;
const cats: [1..n] string = ["Amber", "Winter", "Betty", "Goldie", "Colitas", "Alfredo", "CatGPT", "Ziggy", "Travy", "Cadence", "Teddy"];

// A mutable array representing how long each cat has been awake (in hours)
var awakeHours: [1..n] int = [3, 5, 2, 7, 1, 4, 6, 5, 6, 2, 4];

// Each cat will nap for 2 hours, in parallel
forall /*TODO: fill in the loop variable*/
{
  // TODO:
  // 1. Simulate the nap: subtract 2 hours from awakeHours[i], but don’t go below 0.
}

writeln("Updated awake hours: ", awakeHours);
