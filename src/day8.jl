# # Day 8: Resonating Collinearity 

# ## Premable

using LinearAlgebra
Base.transpose(c::Char) = c
parse_grid = x -> transpose(stack([x for x in split(x, '\n')[1:end-1]]))

# ## Part 1

# ### Working with Sample Data

# The sample data for this problem is:

sample = """
............
........0...
.....0......
.......0....
....0.......
......A.....
............
............
........A...
.........A..
............
............
""";

grid = parse_grid(sample)

# Let's create an empty grid of the same size to hold
# the antinode locations:

antinodes = zeros(Int, size(grid))

# For such a grid, we can compute the number of antinodes 
# present with a simple sum:

sum(antinodes)

# Now let's write a function to iterate over every location and
# then every _other_ location and determine if the same frequency
# antenna exists at both and, if so, plot the two antinodes:

function find_antinodes(data)
    grid = parse_grid(data)
    antinodes = zeros(Int, size(grid))
    for i in CartesianIndices(grid)
        for j in CartesianIndices(grid)
            if j <= i
                continue
            end
            if grid[i] === grid[j] && grid[i] != '.'
                a1 = j + (j - i)
                a2 = i - (j - i)
                if checkbounds(Bool, antinodes, a1)
                    antinodes[a1] = 1
                end
                if checkbounds(Bool, antinodes, a2)
                    antinodes[a2] = 1
                end
            end
        end
    end
    antinodes
end

# Trying this out for a simple case, we can see that the 
# antinodes end up where they should

find_antinodes("""
..........
...#......
..........
....a.....
..........
.....a....
..........
......#...
..........
..........
""")

# Now looking at the complete data set we find the antinodes here:

find_antinodes(sample)

# Adding these up, we see that we get the expected $14$:

sum(find_antinodes(sample))

# ### Working with Actual Data

data = read("day8.txt", String)

sum(find_antinodes(data))

# It turns out $359$ is the correct answer!

# ## Part 2

# Now for the twist...we need to consider harmonics.  This means
# that we will have repeating antinodes.  Let's create a function 
# that generates all antinodes within a given grid for
# two points:

function list_antinodes(i, j, grid)
    if i == j
        return []
    end
    d = (j - i)
    right = [j + c * d for c in 0:max(size(grid)...) if checkbounds(Bool, grid, j + c * d)]
    left = [i - c * d for c in 0:max(size(grid)...) if checkbounds(Bool, grid, i - c * d)]
    return vcat(left, right)
end

list_antinodes(CartesianIndex(3, 3), CartesianIndex(5, 5), grid)


# So we have to modify `find_antinodes` as follows:

function find_antinodes2(data)
    grid = parse_grid(data)
    antinodes = zeros(Int, size(grid))
    for i in CartesianIndices(grid)
        for j in CartesianIndices(grid)
            if j <= i
                continue
            end
            if grid[i] === grid[j] && grid[i] != '.'
                for k in list_antinodes(i, j, grid)
                    antinodes[k] = 1
                end
            end
        end
    end
    antinodes
end

find_antinodes2("""
T.........
...T......
.T........
..........
..........
..........
..........
..........
..........
..........
""")

# Trying this with our original sample data giveS:

find_antinodes2(sample)

# Which contains the expected $34$ antinodes:

sum(find_antinodes2(sample))

# ### Working with Actual Data

# So now let's use our real data and see how many anti nodes we get:

sum(find_antinodes2(data))

# And, as it turns out, $1,293$ is exactly what we expect!