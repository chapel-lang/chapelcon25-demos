// Curious Cat Café Simulation - Solution

config const numOrders = 7;
config const numBaristas = 3;
const deluxeThreshold = 5;

var orders: [1..numOrders] int = [3, 6, 2, 7, 1, 4, 6];

// Total tuna sold
var totalTuna = 0;

// Task-parallel: Each barista takes one order
coforall orderIdx in 1..numOrders
  with (+ reduce totalTuna)  // share outer variable
{
  writeln("🐾 Barista cat taking order #", orderIdx);

  // Each barista computes a subtotal using data parallelism
  var subtotal = 0;

  // Data-parallel forall over items in the order
  forall item in 1..orders[orderIdx]
    with (+ reduce subtotal) // share inner variable
  {
    subtotal += 1; // each item counts as 1 tuna
  }

  writeln("Order #", orderIdx, " subtotal: ", subtotal);

  // Combine subtotal into totalTuna
  totalTuna += subtotal;
}

// Mark deluxe orders using a filtering square-bracket loop
var deluxeOrders = + reduce [o in orders] if o > deluxeThreshold then o;

writeln("Deluxe orders: ", deluxeOrders);
writeln("Total tuna sold: ", totalTuna);
