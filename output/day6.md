# Day 6: Guard Gallivant

## Preliminaries

Once again, we need to read in a string and create a `Matrix` of `Char`s. So
once again we need to use the `LinearAlgebra` package And define transposition
for `Char` types:

````julia
using LinearAlgebra
Base.transpose(c::Char) = c
````

Let's also just create a simple function that reads a string and transposes it
into a `Matrix{Char}` for us:

````julia
function char_mat(str)
    transpose(stack([x for x in split(str, '\n')[1:end-1]]))
end
````

````
char_mat (generic function with 1 method)
````

## Part 1

### Working with Sample Data

For this round, our sample data looks like this:

````julia
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
````

The matrix for this is:

````julia
smat = char_mat(sample)
````

````
10×10 transpose(::Matrix{Char}) with eltype Char:
 '.'  '.'  '.'  '.'  '#'  '.'  '.'  '.'  '.'  '.'
 '.'  '.'  '.'  '.'  '.'  '.'  '.'  '.'  '.'  '#'
 '.'  '.'  '.'  '.'  '.'  '.'  '.'  '.'  '.'  '.'
 '.'  '.'  '#'  '.'  '.'  '.'  '.'  '.'  '.'  '.'
 '.'  '.'  '.'  '.'  '.'  '.'  '.'  '#'  '.'  '.'
 '.'  '.'  '.'  '.'  '.'  '.'  '.'  '.'  '.'  '.'
 '.'  '#'  '.'  '.'  '^'  '.'  '.'  '.'  '.'  '.'
 '.'  '.'  '.'  '.'  '.'  '.'  '.'  '.'  '#'  '.'
 '#'  '.'  '.'  '.'  '.'  '.'  '.'  '.'  '.'  '.'
 '.'  '.'  '.'  '.'  '.'  '.'  '#'  '.'  '.'  '.'
````

We can compute the size of our grid with:

````julia
(height, width) = size(smat)
````

````
(10, 10)
````

The initial position for the guard is:

````julia
(row, col) = Tuple(findfirst(isequal('^'), smat))
````

````
(7, 5)
````

Let's write a function to walk through our grid.  This will mark each space that the
guard visits with an `X`.  We'll continue the walk until the guard leaves
the grid:

````julia
function guard_walk(grid)
    # Get the guard's starting position
    (x, y) = Tuple(findfirst(isequal('^'), grid))
    # Set the initial direction to up
    dir = (-1, 0)
    # Compute the size of our grid
    (height, width) = size(grid)
    # While the guard is still in the grid...
    while 1 <= x <= height && 1 <= y <= width
        # Mark the guard's location with an 'X'
        grid[x, y] = 'X'
        (nx, ny) = (x + dir[1], y + dir[2])
        if 1 <= nx <= height && 1 <= ny <= width && grid[nx, ny] == '#'
            dir = (dir[2], -dir[1])
            (nx, ny) = (x + dir[1], y + dir[2])
        end
        (x, y) = (nx, ny)
    end
end
````

````
guard_walk (generic function with 1 method)
````

Now let's let the guard walk the grid:

````julia
guard_walk(smat)
````

Now let's count the number of `X`s in the grid:

````julia
count(x -> x == 'X', smat)
````

````
41
````

Sure enough, $41$ is the correct answer!

### Working with Actual Data

Now we load our actual data:

````julia
data = read("./day6.txt", String);

grid = char_mat(data)

guard_walk(grid)

count(x -> x == 'X', grid)
````

````
5095
````

...and $5,095$ is the correct answer!

## Part 2

Let's start by resetting our sample data:

````julia
smat = char_mat(sample)
````

````
10×10 transpose(::Matrix{Char}) with eltype Char:
 '.'  '.'  '.'  '.'  '#'  '.'  '.'  '.'  '.'  '.'
 '.'  '.'  '.'  '.'  '.'  '.'  '.'  '.'  '.'  '#'
 '.'  '.'  '.'  '.'  '.'  '.'  '.'  '.'  '.'  '.'
 '.'  '.'  '#'  '.'  '.'  '.'  '.'  '.'  '.'  '.'
 '.'  '.'  '.'  '.'  '.'  '.'  '.'  '#'  '.'  '.'
 '.'  '.'  '.'  '.'  '.'  '.'  '.'  '.'  '.'  '.'
 '.'  '#'  '.'  '.'  '^'  '.'  '.'  '.'  '.'  '.'
 '.'  '.'  '.'  '.'  '.'  '.'  '.'  '.'  '#'  '.'
 '#'  '.'  '.'  '.'  '.'  '.'  '.'  '.'  '.'  '.'
 '.'  '.'  '.'  '.'  '.'  '.'  '#'  '.'  '.'  '.'
````

For part 2 we will need to make a variation of our `guard_walk` function.  It turns
out we will have to be able to deal with cases where the guard
**never leaves the grid**.  So, we'll need to detect such a case.  What
that means, in practice, is that the guard returns to their start location
facing the same direction.  We'll call this new function `is_loop` and we'll
return true if the guard is in a loop and false if the guard leaves
the grid.

````julia
function is_loop(g0)
    # Make a copy of the input data so we don't corrupt it.
    grid = copy(g0)
    # Get the guard's starting position
    (x, y) = Tuple(findfirst(isequal('^'), grid))
    # Set the initial direction to up
    dir = (-1, 0)
    # Compute the size of our grid
    (height, width) = size(grid)
    # Record changes in direction
    turns = Set{String}()

    # While the guard is still in the grid...
    while 1 <= x <= height && 1 <= y <= width
        # Mark the guard's location with an 'X'
        grid[x, y] = 'X'
        # Compute what our next location would be moving in the
        # same direction
        (nx, ny) = (x + dir[1], y + dir[2])

        # As long as we run into a wall with our next move,
        # keep turning right (don't use an `if` here!)
        while 1 <= nx <= height && 1 <= ny <= width && grid[nx, ny] == '#'
            # Construct our current state
            state = "$(x),$(y),$(dir[1]),$(dir[2])"
            # If we have been in this state before, we are in a loop
            if state in turns
                return true
            end
            # Otherwise, record this state
            push!(turns, state)
            # Change direction
            dir = (dir[2], -dir[1])
            # And compute where we will end up after our turn
            (nx, ny) = (x + dir[1], y + dir[2])
        end

        # Update our position
        (x, y) = (nx, ny)
    end
    return false
end
````

````
is_loop (generic function with 1 method)
````

Now let's test our `is_loop` function works for the normal
case where the guard leaves the grid:

````julia
is_loop(smat)
````

````
false
````

Let's confirm the original matrix is unchanged:

````julia
smat
````

````
10×10 transpose(::Matrix{Char}) with eltype Char:
 '.'  '.'  '.'  '.'  '#'  '.'  '.'  '.'  '.'  '.'
 '.'  '.'  '.'  '.'  '.'  '.'  '.'  '.'  '.'  '#'
 '.'  '.'  '.'  '.'  '.'  '.'  '.'  '.'  '.'  '.'
 '.'  '.'  '#'  '.'  '.'  '.'  '.'  '.'  '.'  '.'
 '.'  '.'  '.'  '.'  '.'  '.'  '.'  '#'  '.'  '.'
 '.'  '.'  '.'  '.'  '.'  '.'  '.'  '.'  '.'  '.'
 '.'  '#'  '.'  '.'  '^'  '.'  '.'  '.'  '.'  '.'
 '.'  '.'  '.'  '.'  '.'  '.'  '.'  '.'  '#'  '.'
 '#'  '.'  '.'  '.'  '.'  '.'  '.'  '.'  '.'  '.'
 '.'  '.'  '.'  '.'  '.'  '.'  '#'  '.'  '.'  '.'
````

Perfect.  Now we need to iterate over every location that currently includes a
`.` add a '#' there and then see if that forms a loop.  We then need to count
how many such cases lead to a loop:

````julia
function count_loops(g0)
    # Keep track of the locations of all obstacles that create a loop
    obstacles = Vector{CartesianIndex{2}}()

    # Iterate over all positions in the grid
    for loc in pairs(g0)
        # Get the character at that location
        c = loc[2]
        # And the cartesian index for that location
        (x, y) = Tuple(loc[1])
        # Check that there is currently a `.` at that location
        if c == '.'
            # Make a copy of the grid
            grid = copy(g0)
            # Add a `#` to the copy
            grid[x, y] = '#'
            # Check if the grid now has a loop in it
            if is_loop(grid)
                # If so, record the location of the obstacle
                push!(obstacles, CartesianIndex(x, y))
            end
        end
    end
    # Return the number of loops found
    obstacles
end
````

````
count_loops (generic function with 1 method)
````

OK, let's determine all the locations where an obstacle would
form a loop:

````julia
count_loops(smat)
````

````
6-element Vector{CartesianIndex{2}}:
 CartesianIndex(9, 2)
 CartesianIndex(7, 4)
 CartesianIndex(9, 4)
 CartesianIndex(8, 7)
 CartesianIndex(8, 8)
 CartesianIndex(10, 8)
````

We can see there are six locations.  Not only is that the correct number
but these are the correct locations as well (`(9, 2)`, `(7, 4)`, `(9, 4)`,
`(8, 7)`, `(8, 8)`, `(10, 8)`).

### Working with Actual Data

Now let's run this for our real data:

````julia
data = read("./day6.txt", String);

grid = char_mat(data);
````

There are too many locations to print out, but we can
count them:

````julia
length(count_loops(grid))
````

````
1933
````

Hurray, $1933$ is the correct answer!  Note, if you get 1833, you aren't
considering the case where you bump into a wall and turn *into another wall.*.

# Potential Improvements

Use complex numbers for coordinates!  Then rotation because multiplying by 0+j

---

*This page was generated using [Literate.jl](https://github.com/fredrikekre/Literate.jl).*

