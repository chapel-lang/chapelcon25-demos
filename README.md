This repository contains files relevant to the ChapelCon '25 Tutorial Day Demos.
The schedule for Tutorial Days are below, all times are PST.

## October 7: Tutorials, Day 1

* 9:00 - 9:10 – Welcome/Introduction
* 9:10 - 9:40 – An Introduction to Chapel
* 9:40 - 10:20 – IO Demo/Exercise Session
* 10:20 - 11:00 – Parallel Loops Demo/Exercise Session
* 11:00 - 11:30 – Break
* 11:30 - 12:10 – Distributions Demo/Exercise Session
* 12:10 - 12:50 – Aggregate Data Structures Demo/Exercise Session
* 12:50 – 14:00 – Free-Code Session

## October 8: Tutorials, Day 2

* 9:00 - 9:10 – Welcome/Introduction
* 9:10 - 9:40 – Chapel's Advanced Features
* 9:40 - 10:20 – Performance Debugging Demo/Exercise Session
* 10:20 - 11:00 – Serializers Demo/Exercise Session
* 11:00 - 13:20 – Free-Code Session
* 13:20 - 14:00 – Parallel Iterators Demo/Exercise Session

## Running Chapel Programs

### Using Docker (Recommended)

This repository includes a Docker Compose setup that provides a Chapel environment without requiring a local Chapel installation.

**Note:** Make sure you are in the top-level directory of this repository (where `docker-compose.yml` is located) before running these commands.

To run Chapel programs using Docker:

```bash
# Start an interactive Chapel session
docker compose run --rm chapel

# Compile and run a specific Chapel program
docker compose run --rm chapel chpl -o program_name source_file.chpl
docker compose run --rm chapel ./program_name

# Compile and run in one command
docker compose run --rm chapel chpl --fast source_file.chpl && ./source_file
```

The Docker container maps your current directory to `/workspace`, so all files in this repository are accessible within the container.

### Local Chapel Installation

If you have Chapel installed locally, you can run programs directly:

```bash
# Compile a Chapel program
chpl -o program_name source_file.chpl

# Run the compiled program
./program_name

# Compile and run with optimizations
chpl --fast -o program_name source_file.chpl
./program_name
```

For more information about Chapel compilation options, see the [Chapel documentation](https://chapel-lang.org/docs/).

You can find code and exercises for each session within the relevant subdirectories.