# # Day 6: Guard Gallivant 

# ## Preliminaries

# Once again, we need to read in a string and create a `Matrix` of `Char`s. So
# once again we need to use the `LinearAlgebra` package And define transposition
# for `Char` types:

using LinearAlgebra
Base.transpose(c::Char) = c

# Let's also just create a simple function that reads a string and transposes it
# into a `Matrix{Char}` for us:

function char_mat(str)
    transpose(stack([x for x in split(str, '\n')[1:end-1]]))
end

# ## Part 1

# ### Working with Sample Data

# For this round, our sample data looks like this:

sample = """
....#.....
.........#
..........
..#.......
.......#..
..........
.#..^.....
........#.
#.........
......#...
""";

# The matrix for this is:

smat = char_mat(sample)

# We can compute the size of our grid with:

(width, height) = size(smat)

# The initial position for the guard is:

(row, col) = Tuple(findfirst(isequal('^'), smat))

# Let's write a function to walk through our grid.  This will mark each space that the 
# guard visits with an `X`.  We'll continue the walk until the guard leaves
# the grid:

function guard_walk(grid)
    ## Get the guard's starting position
    (x, y) = Tuple(findfirst(isequal('^'), grid))
    ## Set the initial direction to up
    dir = (-1, 0)
    ## Compute the size of our grid
    (width, height) = size(grid)
    ## While the guard is still in the grid...
    while 1 <= x <= height && 1 <= y <= width
        ## Mark the guard's location with an 'X'
        grid[x, y] = 'X'
        (nx, ny) = (x + dir[1], y + dir[2])
        if 1 <= nx <= height && 1 <= ny <= width && grid[nx, ny] == '#'
            dir = (dir[2], -dir[1])
            (nx, ny) = (x + dir[1], y + dir[2])
        end
        (x, y) = (nx, ny)
    end
end

# Now let's let the guard walk the grid:

guard_walk(smat)

# Now let's count the number of `X`s in the grid:

count(x -> x == 'X', smat)

# Sure enough, $41$ is the correct answer!

# ### Working with Actual Data

# Now we load our actual data:

data = read("./day6.txt", String);

grid = char_mat(data)

guard_walk(grid)

count(x -> x == 'X', grid)

# ...and $5,095$ is the correct answer!

# ## Part 2

# Let's start by resetting our sample data:

smat = char_mat(sample)

# For part 2 we will need to make a variation of our `guard_walk` function.  It turns
# out we will have to be able to deal with cases where the guard
# **never leaves the grid**.  So, we'll need to detect such a case.  What 
# that means, in practice, is that the guard returns to their start location 
# facing the same direction.  We'll call this new function `is_loop` and we'll
# return true if the guard is in a loop and false if the guard leaves
# the grid.

function is_loop(g0)
    ## Make a copy of the input data so we don't corrupt it.
    grid = copy(g0)
    ## Get the guard's starting position
    (x, y) = Tuple(findfirst(isequal('^'), grid))
    (x0, y0) = (x, y)
    ## Set the initial direction to up
    dir = (-1, 0)
    ## Compute the size of our grid
    (width, height) = size(grid)
    ## While the guard is still in the grid...
    while 1 <= x <= height && 1 <= y <= width
        ## Mark the guard's location with an 'X'
        grid[x, y] = 'X'
        (nx, ny) = (x + dir[1], y + dir[2])
        if 1 <= nx <= height && 1 <= ny <= width && grid[nx, ny] == '#'
            dir = (dir[2], -dir[1])
            (nx, ny) = (x + dir[1], y + dir[2])
        end
        (x, y) = (nx, ny)
        if x == x0 && y == y0 && dir == (-1, 0)
            return true
        end
    end
    return false
end

# Now let's test our `is_loop` function works for the normal
# case where the guard leaves the grid:

is_loop(smat)

# Let's confirm the original matrix is unchanged:

smat

# Perfect.  Now we need to iterate over every location that currently includes a
# `.` add a '#' there and then see if that forms a loop.  We then need to count 
# how many such cases lead to a loop:

function count_loops(g0)
    count = 0
    for loc in pairs(g0)
        c = loc[2]
        (x, y) = Tuple(loc[1])
        if c == '.'
            grid = copy(g0)
            grid[x, y] = '#'
            if is_loop(grid)
                count += 1
            end
        end
    end
    count
end

# OK, let's count our loops:

count_loops(smat)

# 
