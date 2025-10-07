const cats = ["Amber", "Winter", "Betty", "Goldie", "Colitas"];

for i in 0..4 do writeln(cats[i]);


for (i, cat) in zip(0..4, cats) {
  writeln("Meow from cat ", i, ": ", cat);
}
