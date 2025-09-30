// This demo introduces more advanced features of distributions
// in conjunction with domains/arrays
use CyclicDist;
use BlockDist;
// 1. Locale queries on array elements


config const n = 8;

const Space1 = {1..n, 1..n};
const CyclicDist1 = new cyclicDist(startIdx=(1,1));
const CyclicDomain1 = CyclicDist1.createDomain(Space1);

var A: [CyclicDomain1] int;
forall a in A do a = here.id;

// Where is A(6,4)?
writeln("With ", Locales.size, " locales, A(6,4) is on locale ", A(6,4).locale.id);
writeln("\n\n");

// 2. Getting local subdomains

// What elements are on locale 0?
var domainOnLocale0 = A.localSubdomain(Locales(0));
writeln("The following indices are on locale 0: ", domainOnLocale0);
for i in Space1.dim(0) {
  for j in Space1.dim(1) {
    if domainOnLocale0.contains((i,j)) then write("T "); else write("F ");
  }
  writeln();
}
writeln("\n\n");

// Print out the elements on locale
if Locales.size > 1 {
  writeln("Locale 1 slice:");
  on Locales(1) {
    var localSubdomain = A.localSubdomain(here);
    var localSlice = A[localSubdomain];
    writeln(localSlice);
  }
  writeln("\n\n");
}


// 3. Changing how your arrays and locales are matched up

// 3.1: `Locales` is an array
writeln("Locale array: ", Locales);
writeln("Locale array shape: ", Locales.shape);
writeln("\n\n");


var localeRow = reshape(Locales, {1..Locales.size, 1..1});
var localeColumn = reshape(Locales, {1..1, 1..Locales.size});

const BlockDist1 = new blockDist(boundingBox=Space1, targetLocales=Locales);
const BlockDomain1 = BlockDist1.createDomain(Space1);
var B: [BlockDomain1] int;
forall b in B do b = here.id;

const BlockDist2 = new blockDist(boundingBox=Space1, targetLocales=localeRow);
const BlockDomain2 = BlockDist2.createDomain(Space1);
var C: [BlockDomain2] int;
forall c in C do c = here.id;

const BlockDist3 = new blockDist(boundingBox=Space1, targetLocales=localeColumn);
const BlockDomain3 = BlockDist3.createDomain(Space1);
var E: [BlockDomain3] int;
forall e in E do e = here.id;

writeln("B, targeting built-in `Locales` array:");
writeln(B);
writeln("\n\n");

writeln("C, targeting `localeRow` array:");
writeln(C);
writeln("\n\n");


writeln("E, targeting `localeColumn` array:");
writeln(E);
writeln("\n\n");