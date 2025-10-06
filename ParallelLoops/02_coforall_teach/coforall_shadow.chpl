const cats = ["Amber", "Winter", "Betty", "Goldie", "Colitas"];
const ages = [3, 5, 2, 4, 1];
var ageUpBy = 2;

coforall (cat, age) in zip(cats, ages) do
  writeln(cat, " is now ", age + ageUpBy, " years old.");
