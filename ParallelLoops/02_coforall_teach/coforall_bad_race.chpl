config const numCats = 100;

var nom = 0;

coforall 1..numCats with (ref nom) do
  nom += 1; // BAD race condition

// Output is nondeterministic
writeln("Nom nom nom! ", nom, " cats have eaten!");


