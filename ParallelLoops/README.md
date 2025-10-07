# Chapel Parallel Loops: The Curious Cat Café 🐈☕

Welcome to the **Curious Cat Café**, where Chapel tasks are cats, arrays are bowls of tuna, and loops decide how our furry friends share the work.

This 40-minute workshop teaches Chapel's serial and parallel loop constructs through a playful, hands-on storyline. Each exercise has tiny `// TODO` edits — no heavy coding required.

---

## Workshop Structure

### 1. Loop Basics (`01_basics/`)
- Introduction to Chapel's `for` loops and zippered iteration
- Overview of serial vs. parallel constructs
- Foundation concepts for task and data parallelism

### 2. Task Parallelism Teaching (`02_coforall_teach/`)
- Introduction to `coforall` loops and task creation
- Understanding task intents and shadow variables
- Avoiding race conditions with proper variable handling
- **Files**: `coforall.chpl`, `coforall_intent.chpl`, `coforall_shadow.chpl`, `coforall_bad_race.chpl`

### 3. Coforall Exercise (`03_coforall_exercise/`)
- **Exercise**: `coforall_kitten.chpl` — Kitten roll call with task parallelism
- Practice creating tasks and managing shared variables safely
- **Solution**: `coforall_kitten_solution.chpl`

### 4. Data Parallel Loops Teaching (`04_data_par_loops/`)
- Introduction to `foreach`, `forall`, and square-bracket loops
- Understanding data parallelism vs. task parallelism
- Promotion and may-parallel iteration concepts
- **Files**: `foreach.chpl`, `forall_intents.chpl`, `may_parallel.chpl`, `promotion.chpl`

### 5. Forall Exercise (`05_forall_exercise/`)
- **Exercise**: `nap.chpl` — Cat naps with data parallelism and promotion
- Practice with `forall` loops and array operations
- **Solution**: `nap_promotion_solution.chpl`

### 6. Reduce Intents Teaching (`06_reduce_intents/`)
- Introduction to reduce intents for safe parallel aggregation
- Understanding sum, max, and other reduction operations
- **Files**: `sum_reduce.chpl`, `max_reduce.chpl`

### 7. Final Exercise (`07_final_exercise/`)
- **Exercise**: `cat_cafe_sim.chpl` — The Morning Rush simulation
- Combines `coforall` task parallelism with `forall` data parallelism
- Practice with reductions and complex parallel patterns
- **Solution**: `cat_cafe_sim_solution.chpl`

---

## How to Run

### Using Docker (from repository root)
```bash
docker compose run --rm chapel chpl ParallelLoops/path/to/file.chpl
docker compose run --rm chapel ./file
```

### Local Installation
```bash
chpl yourFile.chpl && ./yourFile
```
