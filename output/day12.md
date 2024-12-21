# Day 12: Garden Groups

## Preliminaries

````julia
function parse_grid(data)
    transpose(stack([x for x in split(data, '\n')[1:end-1]]))
end
Base.transpose(c::Char) = c
````

Reusing this handle function from day 10:

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
````

````
neighbors (generic function with 1 method)
````

## Part 1

For this part, we need to count the area and perimeter of each region in the
garden and multiply them together and then take the sum of those products to
determine the cost.

### Working with Sample Data

````julia
s1 = """
AAAA
BBCD
BBCC
EEEC
"""

g1 = parse_grid(s1)

function find_region(loc, grid)
    partial = Set(CartesianIndex[loc])
    base = grid[loc]

    queue = [loc]

    while length(queue) > 0
        head = queue[1]
        push!(partial, head)
        queue = queue[2:end]
        for n in neighbors(head, grid)
            if grid[n] == base && !(n in partial)
                push!(queue, n)
            end
        end
    end
    partial
end

function find_regions(grid)
    regions = []
    status = fill(0, size(grid))
    for loc in CartesianIndices(grid)
        if status[loc] === 1
            continue
        end
        partial = find_region(loc, grid)
        push!(regions, partial)
        for p in partial
            status[p] = 1
        end
    end
    regions
end

function region_stats(region, grid)
    area = length(region)
    perimeter = 0
    for loc in region
        edges = 4 - count(x -> (x in region), neighbors(loc, grid))
        perimeter += edges
    end
    (area, floor(Int, perimeter))
end

function score(grid)
    regions = find_regions(grid)
    sum([prod(region_stats(region, grid)) for region in regions])
end
````

````
score (generic function with 1 method)
````

If we score grid 1, we should get $140$:

````julia
score(g1)
````

````
140
````

````julia
g2 = parse_grid("""
RRRRIICCFF
RRRRIICCCF
VVRRRCCFFF
VVRCCCJFFF
VVVVCJJCFE
VVIVCCJJEE
VVIIICJJEE
MIIIIIJJEE
MIIISIJEEE
MMMISSJEEE
""")

score(g2)
````

````
1930
````

### Working with Actual Data

````julia
data = read("day12.txt", String);
````

Now, let's compute the score for our actual data:

score(parse_grid(data))

## Part 2

### Working with Sample Data

### Working with Actual Data

---

*This page was generated using [Literate.jl](https://github.com/fredrikekre/Literate.jl).*

