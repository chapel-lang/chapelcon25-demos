use IO;

var r = openReader("oldMcDonald.txt");

var adj: string;
var person: string;
var verb: string;
var count: string;
var thing: string;

r.readf("%s %s %s %s %s\n", adj, person, verb, count, thing);

writef("%s %s %s %i %ss\n", adj, person, verb, 5, thing);
