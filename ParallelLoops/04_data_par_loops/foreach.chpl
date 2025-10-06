record Cat {
  var name: string;
  var trait: string;
  var purrHP: int; // V8 purr power
}

var cats = [
  new Cat(name="Amber", trait="", purrHP=0),
  new Cat(name="Winter", trait="", purrHP=0),
  new Cat(name="Betty", trait="", purrHP=0),
  new Cat(name="Goldie", trait="", purrHP=0),
  new Cat(name="Colitas", trait="", purrHP=0),
  new Cat(name="Alfredo", trait="", purrHP=0),
  new Cat(name="CatGPT", trait="", purrHP=0)
];

const traits = ["Sleeps on keyboards", "Chases shadows", "Loves tuna art",
                "Steals socks", "Hums in the shower", "Invents cat memes", "Debugs humans"];

// Parallel update: birthday, trait, and V8 purr
foreach i in 0..#cats.size {
  cats[i].trait = traits[i];
  cats[i].purrHP = 400 + i*50; // Engine horsepower
}

// Print results
writeln("Our V8-powered cat crew:");
for c in cats do
  writeln(c.name, " ", c.trait, ", and purrs like a ", c.purrHP, "HP V8 engine!");
