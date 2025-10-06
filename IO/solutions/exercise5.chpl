use IO;

var r = openReader("oldMcDonald.txt");

// Get through the start of the file
var chorus: string = "E I E I O\n";

r.readf("Old McDonald had a farm\n");
r.readf(chorus);
r.readf("And on that farm he had a sheep\n");
r.readf(chorus);
r.readf("\n");

// Start looking for the bad noise
r.mark();

var noise: string;
r.readf("With a %s", noise);


checkOneNoise("%s here\n", noise);
checkTwoNoises("And a %s %s there\n", noise);
checkOneNoise("Here a %s\n", noise);
checkOneNoise("There a %s\n", noise);
checkTwoNoises("Everywhere a %s %s\n", noise);

proc checkOneNoise(line: string, noise: string) {
  var noiseToCheck: string;
  r.readf(line, noiseToCheck);
  
  if noise != noiseToCheck {
    r.revert();

    write(r.readLine(string));
    exit();
  } else {
    r.commit();
    r.mark();
  }
}

proc checkTwoNoises(line: string, noise: string) {
  var noiseToCheck: string;
  var noiseToCheckAlso: string;
  r.readf(line, noiseToCheck, noiseToCheckAlso);
  
  if noise != noiseToCheck || noise != noiseToCheckAlso {
    r.revert();

    write(r.readLine(string));
    exit();
  } else {
    r.commit();
    r.mark();
  }
}
