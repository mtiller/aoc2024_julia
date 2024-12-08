# Advent of Code 2024 - Julia + Literate

The goal of this project is to use Literate.jl in conjunction with Julia to
generate solutions for Advent Of Code 2024.

## Setting up

To run this, you need `jlrun` which, in turn, depends on `Runlit` being installed.  
Install `Runlit`, checkout the source, go to the source directory and do:

```
pkg> dev .
```

Then, run `julia --project=.` in that directory and run:

```
pkg> instantiate .
```

## Building

To build the docs and generate solutions, just run `make`.

## Previewing

To view the complete `retype` output, you need to have two processes running at
the same time. The first is `make watch` which will cause `jlrun` to monitor the
Julia source code and regenerate Markdown files as needed in `output`. The other
is `npm run start` which will run `retype` in watch mode and update
automatically on when it sees changes in `output`.
