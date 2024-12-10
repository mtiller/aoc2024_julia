# # Day 4: Ceres Search

# ### A Bit of Housekeeping

# We will need the `diag` and `transpose` functions so we need to bring
# `LinearAlgebra` into scope.

using LinearAlgebra

# For transpose, we need to define how we want a `Char` to be transposed
# in order for `LinearAlgebra.transpose` to work.

Base.transpose(c::Char) = c

# ## Part 1 

# ### Working with Sample Data

# For this step, we need to find occurrences of the word XMAS
# in an grid of letters.  Our sample data looks like this:

sample = """
MMMSXXMASM
MSAMXMSMSA
AMXSXMAAMM
MSAMASMSMX
XMASAMXAMM
XXAMMXXAMA
SMSMSASXSS
SAXAMASAAA
MAMMMXMMMM
MXMXAXMASX
""";


# We can make this into an array of characters with:

grid = transpose(stack([x for x in split(sample, '\n')[1:end-1]]))

# We can pluck out individual letters using indices, _e.g.,_e

grid[1, 1]

# Or pull our ranges or characters, _e.g.,_

grid[1, 1:4]

# This can be reconstituted back into strings with:

join(grid[1, 1:4], "")

# number of rows and columns we need to concern ourselves with
# would be:

(nrows, ncols) = size(grid)

# We can compute all the "forward" words in the grid with:

forward = [join(grid[i, j:j+3], "") for i in 1:nrows, j in 1:ncols-3]

# ...and all "backward" words with:

backward = [join(grid[i, j+3:-1:j], "") for i in 1:nrows, j in 1:ncols-3]

# We could also do this with:

map(reverse, forward)

# Alternatively, we could just search for matches to `XMAS` and `SAMX` 
# in whatever words we extract.

# As a result, we really only need to create 4 different collections of words.
# Those that are horizontal, vertical, diagonal (top left to bottom right) and
# diagonal (top right to bottom left).  We already did `forward`, but doing the
# vertical words can be done as follows:

vertical = [join(grid[i:i+3, j], "") for i in 1:nrows-3, j in 1:ncols]

# Now we can extract each submatrix and then extract its diagonal.  It isn't the 
# most efficient way since it has to allocate a bunch of (small) matrices along the 
# way, but it keeps this as a one liner:

diagonal1 = [join(diag(grid[i:i+3, j:j+3]), "") for i in 1:nrows-3, j in 1:ncols-3]

# The other diagonal is a little 

diagonal2 = [join(diag(grid[i+3:-1:i, j:j+3]), "") for i in 1:nrows-3, j in 1:ncols-3]

# Now with those four collections we can determine the number of 
# occurrences of `XMAS` (or `SAMX`) with  

sum([
    count(x -> x == "XMAS" || x == "SAMX", forward),
    count(x -> x == "XMAS" || x == "SAMX", vertical),
    count(x -> x == "XMAS" || x == "SAMX", diagonal1),
    count(x -> x == "XMAS" || x == "SAMX", diagonal2)])

# 

function xmas(sample)
    grid = transpose(stack([x for x in split(sample, '\n')[1:end-1]]))
    (nrows, ncols) = size(grid)
    forward = [join(grid[i, j:j+3], "") for i in 1:nrows, j in 1:ncols-3]
    vertical = [join(grid[i:i+3, j], "") for i in 1:nrows-3, j in 1:ncols]
    diagonal1 = [join(diag(grid[i:i+3, j:j+3]), "") for i in 1:nrows-3, j in 1:ncols-3]
    diagonal2 = [join(diag(grid[i+3:-1:i, j:j+3]), "") for i in 1:nrows-3, j in 1:ncols-3]
    sum([
        count(x -> x == "XMAS" || x == "SAMX", forward),
        count(x -> x == "XMAS" || x == "SAMX", vertical),
        count(x -> x == "XMAS" || x == "SAMX", diagonal1),
        count(x -> x == "XMAS" || x == "SAMX", diagonal2)])
end

# Testing this function with our sample data we again get `18`:

xmas(sample)

# ### Working with Actual Data

# Now, we need to perform this same analysis but for a much larger grid of data.

data = read("./day4.txt", String);

# Running our `xmas` function on the read data gives us:

xmas(data)

# ...and `2613` is the correct answer!

# ## Part 2

# ### Working with Sample Data

# It turns out that part 2 may actually be simpler that part 1.
# For part 2, we only need to consider each 3x3 matrix of characters
# in the grid and determine if they match a pattern like this one:

```
M . S 
. A .
M . S
```

# The actual criteria is that 
#
# 1. There is an `A` in the center.
# 2. Of the two characters in opposite corners, one must be
#    an `M` and the other an `S`.

# Let's start be writing a function that checks if this 
# criteria is met for a 3x3 `Matrix{Char}`:

function masx(x)
    diag1 = join([x[1, 1], x[2, 2], x[3, 3]], "")
    diag2 = join([x[1, 3], x[2, 2], x[3, 1]], "")

    return (diag1 == "MAS" || diag1 == "SAM") && (diag2 == "MAS" || diag2 == "SAM")
end

# Now let's check it with a basic example.  This subgrid:

grid[1:3, 2:4]

# contains an example of our pattern.  But does the function work?

masx(grid[1:3, 2:4])

# However, this subgrid does not...

grid[1:3, 1:3]

# And `masx` gets that right too:

masx(grid[1:3, 1:3])

# Now we need to consider every 3x3 subgrid and check if it
# satisfies masx:

[masx(grid[i:i+2, j:j+2]) for i in 1:nrows-2, j in 1:ncols-2]

# The total number of matches is:

sum([masx(grid[i:i+2, j:j+2]) for i in 1:nrows-2, j in 1:ncols-2])

# And, as it turns out, `9` is the correct answer.  Creating a function
# for the entire calculation gives us:

function part2(data)
    grid = transpose(stack([x for x in split(data, '\n')[1:end-1]]))
    (nrows, ncols) = size(grid)
    sum([masx(grid[i:i+2, j:j+2]) for i in 1:nrows-2, j in 1:ncols-2])
end

# Testing our function gives:

part2(sample)

# Hooray!

# ### Working with Actual Data

# Running this on our actual data results in:

part2(data)

# Sure enough, `1905` is the correct answer.  Now on to [Day 5](./day5).