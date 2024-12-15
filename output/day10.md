# Day 10: Hoof it

## Preliminaries

````julia
function parse_grid(data)
    transpose(stack([x for x in split(data, '\n')[1:end-1]]))
end
Base.transpose(c::Char) = c
````

## Part 1

Let's start by first writing a function to find all in a grid:

````julia
function find_trailheads(grid)
    [c for c in CartesianIndices(grid) if grid[c] == '0']
end
````

````
find_trailheads (generic function with 1 method)
````

Checking this sample data, we get:

````julia
s1 = parse_grid("""
0123
1234
8765
9876
""")

find_trailheads(s1)
````

````
1-element Vector{CartesianIndex{2}}:
 CartesianIndex(1, 1)
````

Next, let's write a function to find all neighbors of a location that
are part of the grid:

````julia
function neighbors(loc, grid)
    spots = [
        CartesianIndex(loc[1] - 1, loc[2]),
        CartesianIndex(loc[1] + 1, loc[2]),
        CartesianIndex(loc[1], loc[2] - 1),
        CartesianIndex(loc[1], loc[2] + 1),
    ]
    filter(x -> checkbounds(Bool, grid, x), spots)
end

neighbors(CartesianIndex(1, 1), s1)
````

````
2-element Vector{CartesianIndex{2}}:
 CartesianIndex(2, 1)
 CartesianIndex(1, 2)
````

Now let's write a function that finds the next steps for a given
point on a grid:

````julia
function next_step(loc, grid)
    cur = grid[loc]
    up = cur + 1
    filter(x -> grid[x] == up, neighbors(loc, grid))
end

next_step(CartesianIndex(1, 1), s1)
````

````
2-element Vector{CartesianIndex{2}}:
 CartesianIndex(2, 1)
 CartesianIndex(1, 2)
````

### Working with Sample Data

### Working with Actual Data

## Part 2

### Working with Sample Data

### Working with Actual Data

---

*This page was generated using [Literate.jl](https://github.com/fredrikekre/Literate.jl).*

