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

function pmap(grid)
    rows = [join(grid[i, :], "") for i in 1:size(grid, 1)]
    print(join(rows, "\n"))
end

function show_status(grid, partial, queue)
    m = copy(grid[1:25, 1:25])
    for p in partial
        m[p] = '#'
    end
    for p in queue
        m[p] = '*'
    end
    pmap(m)
    println()
    println()
end

function find_region(loc, grid)
    partial = Set{CartesianIndex}()
    push!(partial, loc)
    base = grid[loc]

    queue = [loc]

    while length(queue) > 0
        head = queue[1]
        push!(partial, head)
        queue = queue[2:end]
        for n in neighbors(head, grid)
            if grid[n] == base && !(n in partial) && !(n in queue)
                push!(queue, n)
            end
        end
    end
    partial
end

function find_regions(grid)
    regions = []
    status = fill(false, size(grid))
    for loc in CartesianIndices(grid)
        if status[loc]
            continue
        end
        partial = find_region(loc, grid)
        push!(regions, partial)
        for p in partial
            status[p] = true
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
""");

# The score for `g2` should be $1930$:

score(g2)

# ### Working with Actual Data

data = read("day12.txt", String);

# Now, let's compute the score for our actual data:

grid = parse_grid(data)

# 

score(parse_grid(data))

# ## Part 2

# ### Working with Sample Data

# ### Working with Actual Data