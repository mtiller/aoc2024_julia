# Day 2: Red-Nosed Reports

## Part 1

### Working with Sample Data

For day 2, our sample data looks like this:

````julia
sample = [
    7 6 4 2 1;
    1 2 7 8 9;
    9 7 6 2 1;
    1 3 2 4 5;
    8 6 4 4 1;
    1 3 6 7 9
]
````

````
6×5 Matrix{Int64}:
 7  6  4  2  1
 1  2  7  8  9
 9  7  6  2  1
 1  3  2  4  5
 8  6  4  4  1
 1  3  6  7  9
````

Here we need to determine if each row is "safe" which means:

1. The levels are either increasing or decreasing
2. The absolute value of the difference between successive numbers is at least 1 and no more than 3.

Let's start by writing a function that determines, for a single row,
if it is safe.  For now, let us consider the first row:

````julia
sample[1, :]
````

````
5-element Vector{Int64}:
 7
 6
 4
 2
 1
````

First we need a way to determine if a given row is either
all increasing or all decreasing.  One way to do this is
to compare the row to the sorted version (both ascending and descending)
to see if they are the same.  We can express this as functions:

````julia
function is_increasing(row)
    return sort(row) == row
end
````

````
is_increasing (generic function with 1 method)
````

...and...

````julia
function is_decreasing(row)
    return sort(row, rev=true) == row
end
````

````
is_decreasing (generic function with 1 method)
````

Let's test these on the first row:

````julia
is_increasing(sample[1, :])
````

````
false
````

````julia
is_decreasing(sample[1, :])
````

````
true
````

So far so good.  Now we need to compute the absolute value of the
difference between successive elements of the row.  Manually,
we can do this:

````julia
[abs.(sample[1, 1:end-1] - sample[1, 2:end])]
````

````
1-element Vector{Vector{Int64}}:
 [1, 2, 2, 1]
````

Now let's write a function that, given a single row, can determine
if the row is safe:

````julia
function is_safe(row)
    diffs = abs.(row[1:end-1] - row[2:end])
    max_diff = maximum(diffs)
    min_diff = minimum(diffs)
    return (is_increasing(row) || is_decreasing(row)) && (max_diff <= 3) & (min_diff >= 1)
end
````

````
is_safe (generic function with 1 method)
````

Let's test this on the first row:

````julia
is_safe(sample[1, :])
````

````
true
````

That looks right, let's check with all the rows:

````julia
[is_safe(sample[i, :]) for i in 1:size(sample, 1)]
````

````
6-element Vector{Bool}:
 1
 0
 0
 0
 0
 1
````

Ultimately, what we need to do is count up the number of safe rows
across the entire data set.  So our function for that would be:

````julia
function part1(data)
    return sum([is_safe(data[i, :]) for i in 1:size(data, 1)])
end
````

````
part1 (generic function with 1 method)
````

Testing this for our sample data we get:

````julia
part1(sample)
````

````
2
````

### Working with Actual Data

We cannot read the "Red-Nosed Reports" with `readdlm` because it assumes the
data in the file is a matrix.  Specifically, it assumes that every row of data
has the same number of columns.  This is not the case with the "Red-Nosed
Reports".  Instead, we need to read the data in as a vector of vectors.

To start, here is how we can read each line from a file:

````julia
function parsefile(path::AbstractString)
    return open(path) do file
        [line for line in eachline(file)]
    end
end

lines = parsefile("day2.txt");
````

Reading the data like this, we get an array of strings
that look like this:

````julia
lines[1:10]
````

````
10-element Vector{String}:
 "16 17 18 21 23 24 27 24"
 "74 76 79 81 82 85 85"
 "48 51 53 54 55 59"
 "29 31 32 34 36 39 41 46"
 "9 12 9 11 14 16 17 20"
 "65 68 66 67 69 70 73 72"
 "56 58 59 58 61 64 64"
 "21 24 25 27 24 25 29"
 "83 85 88 91 90 96"
 "74 77 78 78 81 83 86 87"
````

To get our vectors, we just split each line, _e.g.,_

````julia
data = [parse.(Int64, split(line)) for line in lines];
````

So now the first few entries in our data look like this:

````julia
data[1:10]
````

````
10-element Vector{Vector{Int64}}:
 [16, 17, 18, 21, 23, 24, 27, 24]
 [74, 76, 79, 81, 82, 85, 85]
 [48, 51, 53, 54, 55, 59]
 [29, 31, 32, 34, 36, 39, 41, 46]
 [9, 12, 9, 11, 14, 16, 17, 20]
 [65, 68, 66, 67, 69, 70, 73, 72]
 [56, 58, 59, 58, 61, 64, 64]
 [21, 24, 25, 27, 24, 25, 29]
 [83, 85, 88, 91, 90, 96]
 [74, 77, 78, 78, 81, 83, 86, 87]
````

Because the "shape" of our data is slightly different (a vector of vectors),
we need to rewrite our `part1` function to account for this.  Fortunately,
this is a very simple change:

````julia
function part1(data)
    return sum([is_safe(data[i]) for i in 1:size(data, 1)])
end

part1(data)
````

````
585
````

As we see here, our result is that $585$ of the rows are considered "safe"
which *is the correct answer*.

---

*This page was generated using [Literate.jl](https://github.com/fredrikekre/Literate.jl).*

