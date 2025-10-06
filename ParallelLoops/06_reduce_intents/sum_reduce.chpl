const cats = ["Amber", "Winter", "Betty", "Goldie", "Colitas", "Alfredo", "CatGPT"];
var totalLength = 0;

forall catName in cats
  with (+ reduce totalLength)
{
  totalLength reduce= catName.size; // Each task safely accumulates into its shadow
}

writeln("Total kitty energy (name lengths): ", totalLength);
// Expected: 41
