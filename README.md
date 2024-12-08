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
