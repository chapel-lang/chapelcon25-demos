const cats = ["Amber", "Winter", "Betty", "Goldie", "Colitas"];
var nameLength: [1..5] int;

coforall (i, cat) in zip(1..5, cats) with (ref nameLength) do
  nameLength[i] = cat.size;

writeln(nameLength);

