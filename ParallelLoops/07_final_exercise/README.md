# 🐱 Curious Cat Café: Morning Rush Simulation

Welcome to the Curious Cat Café! Today we simulate the **morning rush** of hungry cat customers.

## Scenario

- There are `N` orders, each containing a number of tuna items.
- Multiple **barista cats** (tasks) take orders concurrently.
- Each barista uses a **data-parallel forall** to process items in its order.
- The café wants to know the **total tuna sold**.
- Deluxe orders have more than a threshold number of items (we’ll mark them using a square-bracket loop).

## Learning Goals

- Combine **`coforall`** (task parallelism) with **`with (ref ... , + reduce ...)`**.
- Use **`forall`** loops to process items in each order.
- Demonstrate **promotion** for concise per-order calculations.
- Use **square-bracket filtering** to mark deluxe orders.

## Instructions

1. Open `cat_cafe_sim.chpl`.
2. Fill in the **TODOs**:
   - `coforall` header with reduce and ref intents.
   - `forall` header with `with (ref subtotal)`.
   - Optionally, adjust the number of baristas or try a promoted reduction.
3. Run the program:
   ```bash
   chpl cat_cafe_sim.chpl
   ./cat_cafe_sim
  ```