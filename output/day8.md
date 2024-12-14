# Day 8: Resonating Collinearity

## Premable

````julia
using LinearAlgebra
Base.transpose(c::Char) = c
parse_grid = x -> transpose(stack([x for x in split(x, '\n')[1:end-1]]))
````

````
#1 (generic function with 1 method)
````

## Part 1

### Working with Sample Data

The sample data for this problem is:

````julia
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
````

````
12×12 transpose(::Matrix{Char}) with eltype Char:
 '.'  '.'  '.'  '.'  '.'  '.'  '.'  '.'  '.'  '.'  '.'  '.'
 '.'  '.'  '.'  '.'  '.'  '.'  '.'  '.'  '0'  '.'  '.'  '.'
 '.'  '.'  '.'  '.'  '.'  '0'  '.'  '.'  '.'  '.'  '.'  '.'
 '.'  '.'  '.'  '.'  '.'  '.'  '.'  '0'  '.'  '.'  '.'  '.'
 '.'  '.'  '.'  '.'  '0'  '.'  '.'  '.'  '.'  '.'  '.'  '.'
 '.'  '.'  '.'  '.'  '.'  '.'  'A'  '.'  '.'  '.'  '.'  '.'
 '.'  '.'  '.'  '.'  '.'  '.'  '.'  '.'  '.'  '.'  '.'  '.'
 '.'  '.'  '.'  '.'  '.'  '.'  '.'  '.'  '.'  '.'  '.'  '.'
 '.'  '.'  '.'  '.'  '.'  '.'  '.'  '.'  'A'  '.'  '.'  '.'
 '.'  '.'  '.'  '.'  '.'  '.'  '.'  '.'  '.'  'A'  '.'  '.'
 '.'  '.'  '.'  '.'  '.'  '.'  '.'  '.'  '.'  '.'  '.'  '.'
 '.'  '.'  '.'  '.'  '.'  '.'  '.'  '.'  '.'  '.'  '.'  '.'
````

Let's create an empty grid of the same size to hold
the antinode locations:

````julia
antinodes = zeros(Int, size(grid))
````

````
12×12 Matrix{Int64}:
 0  0  0  0  0  0  0  0  0  0  0  0
 0  0  0  0  0  0  0  0  0  0  0  0
 0  0  0  0  0  0  0  0  0  0  0  0
 0  0  0  0  0  0  0  0  0  0  0  0
 0  0  0  0  0  0  0  0  0  0  0  0
 0  0  0  0  0  0  0  0  0  0  0  0
 0  0  0  0  0  0  0  0  0  0  0  0
 0  0  0  0  0  0  0  0  0  0  0  0
 0  0  0  0  0  0  0  0  0  0  0  0
 0  0  0  0  0  0  0  0  0  0  0  0
 0  0  0  0  0  0  0  0  0  0  0  0
 0  0  0  0  0  0  0  0  0  0  0  0
````

For such a grid, we can compute the number of antinodes
present with a simple sum:

````julia
sum(antinodes)
````

````
0
````

Now let's write a function to iterate over every location and
then every _other_ location and determine if the same frequency
antenna exists at both and, if so, plot the two antinodes:

````julia
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
````

````
find_antinodes (generic function with 1 method)
````

Trying this out for a simple case, we can see that the
antinodes end up where they should

````julia
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
````

````
10×10 Matrix{Int64}:
 0  0  0  0  0  0  0  0  0  0
 0  0  0  1  0  0  0  0  0  0
 0  0  0  0  0  0  0  0  0  0
 0  0  0  0  0  0  0  0  0  0
 0  0  0  0  0  0  0  0  0  0
 0  0  0  0  0  0  0  0  0  0
 0  0  0  0  0  0  0  0  0  0
 0  0  0  0  0  0  1  0  0  0
 0  0  0  0  0  0  0  0  0  0
 0  0  0  0  0  0  0  0  0  0
````

Now looking at the complete data set we find the antinodes here:

````julia
find_antinodes(sample)
````

````
12×12 Matrix{Int64}:
 0  0  0  0  0  0  1  0  0  0  0  1
 0  0  0  1  0  0  0  0  0  0  0  0
 0  0  0  0  1  0  0  0  0  0  1  0
 0  0  1  0  0  0  0  0  0  0  0  0
 0  0  0  0  0  0  0  0  0  1  0  0
 0  1  0  0  0  0  1  0  0  0  0  0
 0  0  0  1  0  0  0  0  0  0  0  0
 1  0  0  0  0  0  0  1  0  0  0  0
 0  0  0  0  0  0  0  0  0  0  0  0
 0  0  0  0  0  0  0  0  0  0  0  0
 0  0  0  0  0  0  0  0  0  0  1  0
 0  0  0  0  0  0  0  0  0  0  1  0
````

Adding these up, we see that we get the expected $14$:

````julia
sum(find_antinodes(sample))
````

````
14
````

### Working with Actual Data

````julia
data = read("day8.txt", String)

sum(find_antinodes(data))
````

````
359
````

It turns out $359$ is the correct answer!

## Part 2

Now for the twist...we need to consider harmonics.  This means
that we will have repeating antinodes.  Let's create a function
that generates all antinodes within a given grid for
two points:

````julia
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
````

````
6-element Vector{CartesianIndex{2}}:
 CartesianIndex(3, 3)
 CartesianIndex(1, 1)
 CartesianIndex(5, 5)
 CartesianIndex(7, 7)
 CartesianIndex(9, 9)
 CartesianIndex(11, 11)
````

So we have to modify `find_antinodes` as follows:

````julia
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
````

````
10×10 Matrix{Int64}:
 1  0  0  0  0  1  0  0  0  0
 0  0  0  1  0  0  0  0  0  0
 0  1  0  0  0  0  1  0  0  0
 0  0  0  0  0  0  0  0  0  1
 0  0  1  0  0  0  0  0  0  0
 0  0  0  0  0  0  0  0  0  0
 0  0  0  1  0  0  0  0  0  0
 0  0  0  0  0  0  0  0  0  0
 0  0  0  0  1  0  0  0  0  0
 0  0  0  0  0  0  0  0  0  0
````

Trying this with our original sample data giveS:

````julia
find_antinodes2(sample)
````

````
12×12 Matrix{Int64}:
 1  1  0  0  0  0  1  0  0  0  0  1
 0  1  0  1  0  0  0  0  1  0  0  0
 0  0  1  0  1  1  0  0  0  0  1  0
 0  0  1  1  0  0  0  1  0  0  0  0
 0  0  0  0  1  0  0  0  0  1  0  0
 0  1  0  0  0  1  1  0  0  0  0  1
 0  0  0  1  0  0  1  0  0  0  0  0
 1  0  0  0  0  1  0  1  0  0  0  0
 0  0  1  0  0  0  0  0  1  0  0  0
 0  0  0  0  1  0  0  0  0  1  0  0
 0  1  0  0  0  0  0  0  0  0  1  0
 0  0  0  1  0  0  0  0  0  0  1  1
````

Which contains the expected $34$ antinodes:

````julia
sum(find_antinodes2(sample))
````

````
34
````

### Working with Actual Data

So now let's use our real data and see how many anti nodes we get:

````julia
sum(find_antinodes2(data))
````

````
1293
````

And, as it turns out, $1,293$ is exactly what we expect!

---

*This page was generated using [Literate.jl](https://github.com/fredrikekre/Literate.jl).*

