const cats = ["Amber", "Winter", "Betty", "Goldie", "Colitas", "Alfredo", "CatGPT"];
var maxLength = 0;

forall catName in cats
  with (max reduce maxLength)
{
  maxLength reduce= catName.size; // Accumulate maximum per task
}

writeln("Longest cat name length: ", maxLength);
// Expected: 7
