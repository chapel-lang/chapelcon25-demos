config const n = 7;
const cats = ["Amber", "Winter", "Betty", "Goldie", "Colitas", "Alfredo", "CatGPT"];
var awakeHours: [1..n] int = [3, 5, 2, 7, 1, 4, 6];
var zeroes: [1..n] int = 0;

// Use promotion to apply max element-wise
awakeHours = max(awakeHours - 2, zeroes);

writeln("Updated awake hours: ", awakeHours);
