// Curious Cat Café Simulation
// TODO exercise: Fill in the parallel constructs

config const numOrders = 7;
config const numBaristas = 3;
const deluxeThreshold = 5;

var orders: [1..numOrders] int = [3, 6, 2, 7, 1, 4, 6];

// 1. Total tuna sold across all baristas (to be computed in parallel)
var totalTuna = 0;

// TODO: Fill in coforall header (task parallel, reduction)
coforall orderIdx in 1..numOrders
  with (
    // TODO: Fill in reduction intent for totalTuna
  )
{
  writeln("🐾 Barista cat taking order #", orderIdx);

  var subtotal = 0;

  // TODO: Fill in forall header to process each item in this order
  forall item in 1..orders[orderIdx]
    with ( // TODO: Fill in reduction intent for subtotal
    )
  {
    // Each item adds 1 tuna to subtotal
    subtotal += 1;
  }

  writeln("Order #", orderIdx, " subtotal: ", subtotal);
}

// 2. Mark deluxe orders using square-bracket filtering and reduce to sum them together
var deluxeOrders = // TODO

writeln("Deluxe orders: ", deluxeOrders);
writeln("Total tuna sold: ", totalTuna);
