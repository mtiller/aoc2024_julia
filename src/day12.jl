# # Day 12: Garden Groups

# ## Preliminaries 

function parse_grid(data)
    transpose(stack([x for x in split(data, '\n')[1:end-1]]))
end
Base.transpose(c::Char) = c

# Reusing this handle function from day 10:

function neighbors(loc, grid)
    spots = [
        CartesianIndex(loc[1] - 1, loc[2]),
        CartesianIndex(loc[1] + 1, loc[2]),
        CartesianIndex(loc[1], loc[2] - 1),
        CartesianIndex(loc[1], loc[2] + 1),
    ]
    filter(x -> checkbounds(Bool, grid, x), spots)
end

# ## Part 1

# For this part, we need to count the area and perimeter of each region in the
# garden and multiply them together and then take the sum of those products to
# determine the cost.

# ### Working with Sample Data

s1 = """
AAAA
BBCD
BBCC
EEEC
"""

g1 = parse_grid(s1)

function find_region(loc, grid)
    partial = fill(0, size(grid))
    base = grid[loc]

    queue = [loc]

    while length(queue) > 0
        head = queue[1]
        partial[head] = 1
        queue = queue[2:end]
        for n in neighbors(head, grid)
            if grid[n] == base && partial[n] == 0
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
        if status[loc] == 1
            continue
        end
        partial = find_region(loc, grid)
        println("Adding region $partial")
        push!(regions, partial)
        status = status + partial
    end
    regions
end

function region_stats(region)
    area = count(x -> x === 1, region)
    perimeter = 0
    for loc in CartesianIndices(region)
        if region[loc] == 0
            continue
        end
        edges = 4 - length(filter(x -> region[x] === 1, neighbors(loc, region)))
        perimeter += edges
    end
    (area, floor(Int, perimeter))
end

function score(grid)
    regions = find_regions(grid)
    sum([prod(region_stats(region)) for region in regions])
end

# If we score grid 1, we should get $140$:

score(g1)

#

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

# ### Working with Actual Data

data = read("day12.txt", String)

# Now, let's compute the score for our actual data:

score(parse_grid(data))

# ## Part 2

# ### Working with Sample Data

# ### Working with Actual Data
