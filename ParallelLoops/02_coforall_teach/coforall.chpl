const cats = ["Amber", "Winter", "Betty", "Goldie", "Colitas"];

coforall (i, cat) in zip(1..5, cats) do
  writeln("🐈 Cat ", cat, " reporting from task ", i);
