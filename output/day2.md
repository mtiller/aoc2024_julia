# Day 2

## Working with Sample Data

Again, we start with the sample data but this time we want to
compute the similarity score.  Here is the sample data again:

````julia
sample = [
    3 4;
    4 3;
    2 5;
    1 3;
    3 9;
    3 3
]
````

````
6×2 Matrix{Int64}:
 3  4
 4  3
 2  5
 1  3
 3  9
 3  3
````

To compute the similarity score we need to take each number on the left, in
turn, and multiple it by the number of times it appears on the right, _i.e.,_

````julia
["$(x) * $(count(==(x), sample[:, 2])) = $(x * count(==(x), sample[:, 2]))" for x in sample[:, 1]]
````

````
6-element Vector{String}:
 "3 * 3 = 9"
 "4 * 1 = 4"
 "2 * 0 = 0"
 "1 * 0 = 0"
 "3 * 3 = 9"
 "3 * 3 = 9"
````

The products themselves are just:

````julia
[x * count(==(x), sample[:, 2]) for x in sample[:, 1]]
````

````
6-element Vector{Int64}:
 9
 4
 0
 0
 9
 9
````

And their sum is:

````julia
sum([x * count(==(x), sample[:, 2]) for x in sample[:, 1]])
````

````
31
````

And, as the [instructions for Day 2](https://adventofcode.com/2024/day/1#part2) tell us,
the answer should be $31$.

## Working with Actual Data

Our next step is to write a function that can do this calculation for
an arbitrary data set.  In Julia, such a function can be written as:

````julia
function day2(data)
    return sum([x * count(==(x), data[:, 2]) for x in data[:, 1]])
end
````

````
day2 (generic function with 1 method)
````

Let's test our function on the sample data just to make sure we got that
correct:

````julia
day2(sample)
````

````
31
````

Hurray!  Now, let's it on our actual data:

````julia
using DelimitedFiles
data = readdlm("day1.txt", Int64)

day2(data)
````

````
20719933
````

Excellent, another gold start, the expected answer is indeed `20719933`.

---

*This page was generated using [Literate.jl](https://github.com/fredrikekre/Literate.jl).*

