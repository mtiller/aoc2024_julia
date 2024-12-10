# Day 4: Ceres Search

## Part 1

For this step, we need to find occurrences of the word XMAS
in an grid of letters.  Our sample data looks like this:

````julia
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
````

We will need the `diag` and `transpose` functions so we need to bring
`LinearAlgebra` into scope.

````julia
using LinearAlgebra
````

For transpose, we need to define how we want a `Char` to be transposed
in order for `LinearAlgebra.transpose` to work.

````julia
Base.transpose(c::Char) = c
````

We can make this into an array of characters with:

````julia
grid = transpose(stack([x for x in split(sample, '\n')[1:end-1]]))
````

````
10×10 transpose(::Matrix{Char}) with eltype Char:
 'M'  'M'  'M'  'S'  'X'  'X'  'M'  'A'  'S'  'M'
 'M'  'S'  'A'  'M'  'X'  'M'  'S'  'M'  'S'  'A'
 'A'  'M'  'X'  'S'  'X'  'M'  'A'  'A'  'M'  'M'
 'M'  'S'  'A'  'M'  'A'  'S'  'M'  'S'  'M'  'X'
 'X'  'M'  'A'  'S'  'A'  'M'  'X'  'A'  'M'  'M'
 'X'  'X'  'A'  'M'  'M'  'X'  'X'  'A'  'M'  'A'
 'S'  'M'  'S'  'M'  'S'  'A'  'S'  'X'  'S'  'S'
 'S'  'A'  'X'  'A'  'M'  'A'  'S'  'A'  'A'  'A'
 'M'  'A'  'M'  'M'  'M'  'X'  'M'  'M'  'M'  'M'
 'M'  'X'  'M'  'X'  'A'  'X'  'M'  'A'  'S'  'X'
````

We can pluck out individual letters using indices, _e.g.,_e

````julia
grid[1, 1]
````

````
'M': ASCII/Unicode U+004D (category Lu: Letter, uppercase)
````

Or pull our ranges or characters, _e.g.,_

````julia
grid[1, 1:4]
````

````
4-element Vector{Char}:
 'M': ASCII/Unicode U+004D (category Lu: Letter, uppercase)
 'M': ASCII/Unicode U+004D (category Lu: Letter, uppercase)
 'M': ASCII/Unicode U+004D (category Lu: Letter, uppercase)
 'S': ASCII/Unicode U+0053 (category Lu: Letter, uppercase)
````

This can be reconstituted back into strings with:

````julia
join(grid[1, 1:4], "")
````

````
"MMMS"
````

number of rows and columns we need to concern ourselves with
would be:

````julia
(nrows, ncols) = size(grid)
````

````
(10, 10)
````

We can compute all the "forward" words in the grid with:

````julia
forward = [join(grid[i, j:j+3], "") for i in 1:nrows, j in 1:ncols-3]
````

````
10×7 Matrix{String}:
 "MMMS"  "MMSX"  "MSXX"  "SXXM"  "XXMA"  "XMAS"  "MASM"
 "MSAM"  "SAMX"  "AMXM"  "MXMS"  "XMSM"  "MSMS"  "SMSA"
 "AMXS"  "MXSX"  "XSXM"  "SXMA"  "XMAA"  "MAAM"  "AAMM"
 "MSAM"  "SAMA"  "AMAS"  "MASM"  "ASMS"  "SMSM"  "MSMX"
 "XMAS"  "MASA"  "ASAM"  "SAMX"  "AMXA"  "MXAM"  "XAMM"
 "XXAM"  "XAMM"  "AMMX"  "MMXX"  "MXXA"  "XXAM"  "XAMA"
 "SMSM"  "MSMS"  "SMSA"  "MSAS"  "SASX"  "ASXS"  "SXSS"
 "SAXA"  "AXAM"  "XAMA"  "AMAS"  "MASA"  "ASAA"  "SAAA"
 "MAMM"  "AMMM"  "MMMX"  "MMXM"  "MXMM"  "XMMM"  "MMMM"
 "MXMX"  "XMXA"  "MXAX"  "XAXM"  "AXMA"  "XMAS"  "MASX"
````

...and all "backward" words with:

````julia
backward = [join(grid[i, j+3:-1:j], "") for i in 1:nrows, j in 1:ncols-3]
````

````
10×7 Matrix{String}:
 "SMMM"  "XSMM"  "XXSM"  "MXXS"  "AMXX"  "SAMX"  "MSAM"
 "MASM"  "XMAS"  "MXMA"  "SMXM"  "MSMX"  "SMSM"  "ASMS"
 "SXMA"  "XSXM"  "MXSX"  "AMXS"  "AAMX"  "MAAM"  "MMAA"
 "MASM"  "AMAS"  "SAMA"  "MSAM"  "SMSA"  "MSMS"  "XMSM"
 "SAMX"  "ASAM"  "MASA"  "XMAS"  "AXMA"  "MAXM"  "MMAX"
 "MAXX"  "MMAX"  "XMMA"  "XXMM"  "AXXM"  "MAXX"  "AMAX"
 "MSMS"  "SMSM"  "ASMS"  "SASM"  "XSAS"  "SXSA"  "SSXS"
 "AXAS"  "MAXA"  "AMAX"  "SAMA"  "ASAM"  "AASA"  "AAAS"
 "MMAM"  "MMMA"  "XMMM"  "MXMM"  "MMXM"  "MMMX"  "MMMM"
 "XMXM"  "AXMX"  "XAXM"  "MXAX"  "AMXA"  "SAMX"  "XSAM"
````

We could also do this with:

````julia
map(reverse, forward)
````

````
10×7 Matrix{String}:
 "SMMM"  "XSMM"  "XXSM"  "MXXS"  "AMXX"  "SAMX"  "MSAM"
 "MASM"  "XMAS"  "MXMA"  "SMXM"  "MSMX"  "SMSM"  "ASMS"
 "SXMA"  "XSXM"  "MXSX"  "AMXS"  "AAMX"  "MAAM"  "MMAA"
 "MASM"  "AMAS"  "SAMA"  "MSAM"  "SMSA"  "MSMS"  "XMSM"
 "SAMX"  "ASAM"  "MASA"  "XMAS"  "AXMA"  "MAXM"  "MMAX"
 "MAXX"  "MMAX"  "XMMA"  "XXMM"  "AXXM"  "MAXX"  "AMAX"
 "MSMS"  "SMSM"  "ASMS"  "SASM"  "XSAS"  "SXSA"  "SSXS"
 "AXAS"  "MAXA"  "AMAX"  "SAMA"  "ASAM"  "AASA"  "AAAS"
 "MMAM"  "MMMA"  "XMMM"  "MXMM"  "MMXM"  "MMMX"  "MMMM"
 "XMXM"  "AXMX"  "XAXM"  "MXAX"  "AMXA"  "SAMX"  "XSAM"
````

Alternatively, we could just search for matches to `XMAS` and `SAMX`
in whatever words we extract.

As a result, we really only need to create 4 different collections of words.
Those that are horizontal, vertical, diagonal (top left to bottom right) and
diagonal (top right to bottom left).  We already did `forward`, but doing the
vertical words can be done as follows:

````julia
vertical = [join(grid[i:i+3, j], "") for i in 1:nrows-3, j in 1:ncols]
````

````
7×10 Matrix{String}:
 "MMAM"  "MSMS"  "MAXA"  "SMSM"  "XXXA"  "XMMS"  "MSAM"  "AMAS"  "SSMM"  "MAMX"
 "MAMX"  "SMSM"  "AXAA"  "MSMS"  "XXAA"  "MMSM"  "SAMX"  "MASA"  "SMMM"  "AMXM"
 "AMXX"  "MSMX"  "XAAA"  "SMSM"  "XAAM"  "MSMX"  "AMXX"  "ASAA"  "MMMM"  "MXMA"
 "MXXS"  "SMXM"  "AAAS"  "MSMM"  "AAMS"  "SMXA"  "MXXS"  "SAAX"  "MMMS"  "XMAS"
 "XXSS"  "MXMA"  "AASX"  "SMMA"  "AMSM"  "MXAA"  "XXSS"  "AAXA"  "MMSA"  "MASA"
 "XSSM"  "XMAA"  "ASXM"  "MMAM"  "MSMM"  "XAAX"  "XSSM"  "AXAM"  "MSAM"  "ASAM"
 "SSMM"  "MAAX"  "SXMM"  "MAMX"  "SMMA"  "AAXX"  "SSMM"  "XAMA"  "SAMS"  "SAMX"
````

Now we can extract each submatrix and then extract its diagonal.  It isn't the
most efficient way since it has to allocate a bunch of (small) matrices along the
way, but it keeps this as a one liner:

````julia
diagonal1 = [join(diag(grid[i:i+3, j:j+3]), "") for i in 1:nrows-3, j in 1:ncols-3]
````

````
7×7 Matrix{String}:
 "MSXM"  "MASA"  "MMXS"  "SXMM"  "XMAS"  "XSAM"  "MMMX"
 "MMAS"  "SXMA"  "ASAM"  "MXSX"  "XMMA"  "MASM"  "SAMM"
 "ASAM"  "MASM"  "XMAX"  "SAMX"  "XSXA"  "MMAM"  "ASMA"
 "MMAM"  "SAMS"  "ASMA"  "MAXS"  "AMXX"  "SXAS"  "MAMS"
 "XXSA"  "MAMM"  "AMSA"  "SMAS"  "AXSA"  "MXXA"  "XASA"
 "XMXM"  "XSAM"  "AMMX"  "MSAM"  "MASM"  "XSAM"  "XXAM"
 "SAMX"  "MXMA"  "SAMX"  "MMXM"  "SAMA"  "ASMS"  "SAMX"
````

The other diagonal is a little

````julia
diagonal2 = [join(diag(grid[i+3:-1:i, j:j+3]), "") for i in 1:nrows-3, j in 1:ncols-3]
````

````
7×7 Matrix{String}:
 "MMAS"  "SXMX"  "ASXX"  "MXMM"  "AMSA"  "SAMS"  "MASM"
 "XSXM"  "MASX"  "AMXM"  "SAMS"  "ASAM"  "MMAS"  "XSMA"
 "XMAS"  "XAMX"  "ASAM"  "MASA"  "MMMA"  "XXSM"  "XAMM"
 "SXAM"  "MASA"  "SMAS"  "MMMM"  "SXXS"  "AXAM"  "SAMX"
 "SMAS"  "ASMA"  "XMMM"  "ASXX"  "MAXA"  "ASAM"  "SXMM"
 "MASM"  "AXMM"  "MASX"  "MMAX"  "MASA"  "XSXM"  "MASA"
 "MAXM"  "XMAS"  "MMMA"  "XMAS"  "AXSX"  "XMAS"  "MMAS"
````

Now with those four collections we can determine the number of
occurrences of `XMAS` (or `SAMX`) with

````julia
sum([
    count(x -> x == "XMAS" || x == "SAMX", forward),
    count(x -> x == "XMAS" || x == "SAMX", vertical),
    count(x -> x == "XMAS" || x == "SAMX", diagonal1),
    count(x -> x == "XMAS" || x == "SAMX", diagonal2)])
````

````
18
````

````julia
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
````

````
xmas (generic function with 1 method)
````

Testing this function with our sample data we again get `18`:

````julia
xmas(sample)
````

````
18
````

### Working with Actual Data

Now, we need to perform this same analysis but for a much larger grid of data.

````julia
data = read("./day4.txt", String);
````

Running our `xmas` function on the read data gives us:

````julia
xmas(data)
````

````
2613
````

...and `2613` is the correct answer!

## Part 2

It turns out that part 2 may actually be simpler that part 1.
For part 2, we only need to consider each 3x3 matrix of characters
in the grid and determine if they match a pattern like this one:

````julia
```
M . S
. A .
M . S
```
````

````
`M . S . A . M . S`
````

The actual criteria is that

1. There is an `A` in the center.
2. Of the two characters in opposite corners, one must be
   an `M` and the other an `S`.

Let's start be writing a function that checks if this
criteria is met for a 3x3 `Matrix{Char}`:

````julia
function masx(x)
    diag1 = join([x[1, 1], x[2, 2], x[3, 3]], "")
    diag2 = join([x[1, 3], x[2, 2], x[3, 1]], "")

    return (diag1 == "MAS" || diag1 == "SAM") && (diag2 == "MAS" || diag2 == "SAM")
end
````

````
masx (generic function with 1 method)
````

Now let's check it with a basic example.  This subgrid:

````julia
grid[1:3, 2:4]
````

````
3×3 Matrix{Char}:
 'M'  'M'  'S'
 'S'  'A'  'M'
 'M'  'X'  'S'
````

contains an example of our pattern.  But does the function work?

````julia
masx(grid[1:3, 2:4])
````

````
true
````

However, this subgrid does not...

````julia
grid[1:3, 1:3]
````

````
3×3 Matrix{Char}:
 'M'  'M'  'M'
 'M'  'S'  'A'
 'A'  'M'  'X'
````

And `masx` gets that right too:

````julia
masx(grid[1:3, 1:3])
````

````
false
````

Now we need to consider every 3x3 subgrid and check if it
satisfies masx:

````julia
[masx(grid[i:i+2, j:j+2]) for i in 1:nrows-2, j in 1:ncols-2]
````

````
8×8 Matrix{Bool}:
 0  1  0  0  0  0  0  0
 0  0  0  0  0  1  1  0
 0  1  0  1  0  0  0  0
 0  0  0  0  0  0  0  0
 0  0  0  0  0  0  0  0
 0  0  0  0  0  0  0  0
 1  0  1  0  1  0  1  0
 0  0  0  0  0  0  0  0
````

The total number of matches is:

````julia
sum([masx(grid[i:i+2, j:j+2]) for i in 1:nrows-2, j in 1:ncols-2])
````

````
9
````

And, as it turns out, `9` is the correct answer.  Creating a function
for the entire calculation gives us:

````julia
function part2(data)
    grid = transpose(stack([x for x in split(data, '\n')[1:end-1]]))
    (nrows, ncols) = size(grid)
    sum([masx(grid[i:i+2, j:j+2]) for i in 1:nrows-2, j in 1:ncols-2])
end
````

````
part2 (generic function with 1 method)
````

Testing our function gives:

````julia
part2(sample)
````

````
9
````

Hooray!

### Working with Actual Data

Running this on our actual data results in:

````julia
part2(data)
````

````
1905
````

Sure enough, `1905` is the correct answer.  Now on to [Day 5](./day5).

---

*This page was generated using [Literate.jl](https://github.com/fredrikekre/Literate.jl).*

