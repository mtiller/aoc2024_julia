# Day 2: Red-Nosed Reports

## Part 1

### Working with Sample Data

For day 2, our sample data looks like this:

````julia
sample = [
    [7, 6, 4, 2, 1],
    [1, 2, 7, 8, 9],
    [9, 7, 6, 2, 1],
    [1, 3, 2, 4, 5],
    [8, 6, 4, 4, 1],
    [1, 3, 6, 7, 9]
]
````

````
6-element Vector{Vector{Int64}}:
 [7, 6, 4, 2, 1]
 [1, 2, 7, 8, 9]
 [9, 7, 6, 2, 1]
 [1, 3, 2, 4, 5]
 [8, 6, 4, 4, 1]
 [1, 3, 6, 7, 9]
````

Note that this data is *not* a `Matrix` (in the Julia sense).  It is, instead,
a vector of vectors.  We'll see why this is important shortly.

Here we need to determine if each row is "safe" which means:

1. The levels are either increasing or decreasing
2. The absolute value of the difference between successive numbers is at least
   1 and no more than 3.

Let's start by writing a function that determines, for a single row, if it is
safe.  For now, let us consider the first row:

````julia
sample[1]
````

````
5-element Vector{Int64}:
 7
 6
 4
 2
 1
````

First we need a way to determine if a given row is either all increasing or
all decreasing.  One way to do this is to compare the row to the sorted
version (both ascending and descending) to see if they are the same.  We can
express this as functions:

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
is_increasing(sample[1])
````

````
false
````

````julia
is_decreasing(sample[1])
````

````
true
````

So far so good.  Now we need to compute the absolute value of the difference
between successive elements of the row.  Manually, we can do this:

````julia
[abs.(sample[1][1:end-1] - sample[1][2:end])]
````

````
1-element Vector{Vector{Int64}}:
 [1, 2, 2, 1]
````

Now let's write a function that, given a single row, can determine if the row
is safe:

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
is_safe(sample[1])
````

````
true
````

That looks right, let's check with all the rows:

````julia
[is_safe(sample[i]) for i in 1:size(sample, 1)]
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

Ultimately, what we need to do is count up the number of safe rows across the
entire data set.  So our function for that would be:

````julia
function part1(data)
    return sum([is_safe(data[i]) for i in 1:size(data, 1)])
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

Recall earlier how we made the point that our sample data was a vector of
vectors and not a matrix?  This is why.  Note that each row in this data set
can potentially have a different size.  That's not possible with a `Matrix`
which is why we had to use a slightly different data structure for this
particular problem.

So lets run our `part1` function on the actual data:

````julia
part1(data)
````

````
585
````

As we see here, our result is that $585$ of the rows are considered "safe"
which *is the correct answer*.

## Part 2

In part 2, we need to see if eliding a single value from each row would make
the report safe.  If that is the case, then the row is actually safe.
Let us consider the first row of our data:

````julia
sample[1]
````

````
5-element Vector{Int64}:
 7
 6
 4
 2
 1
````

We can generate the list of variations where one element has been
removed using the following construct:

````julia
[sample[1][1:end.!=i] for i in 1:length(sample[1])]
````

````
5-element Vector{Vector{Int64}}:
 [6, 4, 2, 1]
 [7, 4, 2, 1]
 [7, 6, 2, 1]
 [7, 6, 4, 1]
 [7, 6, 4, 2]
````

We can determine if these are safe by modifying this slightly:

````julia
[is_safe(sample[1][1:end.!=i]) for i in 1:length(sample[1])]
````

````
5-element Vector{Bool}:
 1
 1
 0
 1
 1
````

And we can find out if any value is safe by applying `|` element-wise:

````julia
reduce(|, [is_safe(sample[1][1:end.!=i]) for i in 1:length(sample[1])])
````

````
true
````

Making a function for this calculation could be done as follows:

````julia
function any_safe(row)
    reduce(|, [is_safe(row[1:end.!=i]) for i in 1:length(row)])
end
````

````
any_safe (generic function with 1 method)
````

Now we can write our function for part 2 as:

````julia
function part2(data)
    return sum([any_safe(data[i]) for i in 1:size(data, 1)])
end
````

````
part2 (generic function with 1 method)
````

Running this on the actual data gives us:

````julia
part2(data)
````

````
626
````

And, as it turns out, `626` is the correct answer for this data set!  Well, on
to [Day 3](./day3).

---

*This page was generated using [Literate.jl](https://github.com/fredrikekre/Literate.jl).*

