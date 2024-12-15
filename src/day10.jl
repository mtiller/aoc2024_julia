# # Day 10: Hoof it

# ## Preliminaries

function parse_grid(data)
    transpose(stack([x for x in split(data, '\n')[1:end-1]]))
end
Base.transpose(c::Char) = c

# ## Part 1 

# Let's start by first writing a function to find all in a grid:

function find_trailheads(grid)
    [c for c in CartesianIndices(grid) if grid[c] == '0']
end

# ### Working with Sample Data

# Checking this sample data, we get:

s1 = parse_grid("""
...0...
...1...
...2...
6543456
7.....7
8.....8
9.....9
""")

find_trailheads(s1)

# Next, let's write a function to find all neighbors of a location that
# are part of the grid:

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

# Now let's write a function that finds the next steps for a given
# point on a grid:

function next_step(loc, grid)
    cur = grid[loc]
    up = cur + 1
    filter(x -> grid[x] == up, neighbors(loc, grid))
end

next_step(CartesianIndex(4, 4), s1)

# Now let's write a function to find the peaks (of height 9)
# that are reachable from a given location:

function peaks(loc, grid)
    if grid[loc] == '9'
        return loc
    end
    vcat([peaks(x, grid) for x in next_step(loc, grid)]...)
end

peaks(CartesianIndex(1, 4), s1)

# Now let's write a function to score a grid:

function trail_score(start, grid)
    ret = peaks(start, grid)
    length(Set(ret))
end
function score(grid)
    sum([trail_score(x, grid) for x in find_trailheads(grid)])
end

score(s1)

# Now let's try some other sample data:

s2 = parse_grid("""
..90..9
...1.98
...2..7
6543456
765.987
876....
987....
""")

score(s2)

# Yet another example:

s3 = parse_grid("""
10..9..
2...8..
3...7..
4567654
...8..3
...9..2
.....01
""")

score(s3)

# One last set of sample data:

s4 = parse_grid("""
89010123
78121874
87430965
96549874
45678903
32019012
01329801
10456732
""")

score(s4)

# Sure enough, $36$ is the correct answer.

# ### Working with Actual Data

# Now let's try this out with our actual data:

data = read("day10.txt", String)

grid = parse_grid(data)

score(grid)

# Excellent, $674$ is the correct answer!

# ## Part 2

# ### Working with Sample Data

s5 = parse_grid("""
.....0.
..4321.
..5..2.
..6543.
..7..4.
..8765.
..9....
""")

# Now we need to compute the rating.  But, in fact, we had already inadvertently
# done this earlier before using the set data type to consolidate the peaks.

function location_rating(loc, grid)
    if grid[loc] == '9'
        return 1
    end
    sum([location_rating(x, grid) for x in next_step(loc, grid)])
end

location_rating(CartesianIndex(1, 6), s5)

# Let's try more sample data:

s6 = parse_grid("""
..90..9
...1.98
...2..7
6543456
765.987
876....
987....
""")

location_rating(CartesianIndex(1, 4), s6)

# where $13$ is the expected answer.  Now, yet more sample data:

s7 = parse_grid("""
012345
123456
234567
345678
4.6789
56789.
""")

location_rating(CartesianIndex(1, 1), s7)

# where $227$ is the expected rating.

# Now we need a function that sums the rating across all trailheads.  This is a simple
# function:

function rating(grid)
    sum([location_rating(x, grid) for x in find_trailheads(grid)])
end

rating(s7)

# where $227$ is the expected rating because there is only a single trailhead.  But now
# let's consider sample data, `s4`, with multiple trail heads:

rating(s4)

# Sure enough, the expected answer is $81$.

# ### Working with Actual Data

# So now let's run this for our actual data:

rating(grid)

# Whew!  $1372$ is the right answer.
