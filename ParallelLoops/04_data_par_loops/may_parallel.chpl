const cats = ["Amber", "Winter", "Betty", "Goldie", "Colitas", "Alfredo", "CatGPT"];

// May-Parallel Loop (Expression form)
// If the array 'cats' provides a parallel iterator (which standard arrays do),
// this executes in parallel (like a forall expression).
// If no parallel iterator existed, it would execute serially (like a foreach).
var loudCats = [name in cats] if name.size > 5 then name + " (LOUD!)";

writeln("The loud cats: ", loudCats);
