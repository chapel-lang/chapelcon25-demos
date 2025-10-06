
config const numKittens = 7;
const cats = ["Amber", "Winter", "Betty", "Goldie", "Colitas", "Alfredo", "CatGPT"];
var bowlCount = 0;

coforall tid in 1..numKittens with (ref bowlCount) {
  writeln("Kitten ", tid, ": ", cats[tid-1]);
  if tid == 1 {
    writeln("Kitten ", cats[tid-1], " is eating from the bowl.");
    bowlCount += 1;
  }
}

writeln("Manager cat: bowlCount is ", bowlCount);
