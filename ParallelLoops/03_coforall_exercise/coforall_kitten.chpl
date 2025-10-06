// coforall_kitten.chpl -- Curious Cat Café: Kitten Roll Call
config const numKittens = /* TODO*/;

const cats = ["Amber", "Winter", "Betty", "Goldie", "Colitas", "Alfredo", "CatGPT"];
var bowlCount = 0;

// TODO: write a coforall loop. For each tid in 1..numKittens
// - print: "Kitten <tid>: name"
// - have only tid==1 increment bowlCount (so no race);.
coforall tid in /* TODO use the right intent */ {
  // TODO: print kitten line
  // TODO: update bowlCount only for a single task
}

writeln("Manager cat: bowlCount is ", bowlCount);
