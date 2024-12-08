OK, this is day one of Advent of Code 2024.  I'm creating my solutions in
Julia. I'm no Julia expert, so this is just good practice for me to sharpen my
Julia skills.

Let's get started.  The [instructions for day 1](https://adventofcode.com/2024/day/1) give the following
sample input:

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

The goal of this project is to effectively come up with a metric for the
computing the distance between the two columns.  Compared to something like a
straight $L_2$ norm or something, for this exercise we first sort each column
(*independently*) in ascending order.  As a result, we get this for the first
column:

````julia
col1 = sort(sample[:, 1])
````

````
6-element Vector{Int64}:
 1
 2
 3
 3
 3
 4
````

and then for the second column we get:

````julia
col2 = sort(sample[:, 2])
````

````
6-element Vector{Int64}:
 3
 3
 3
 4
 5
 9
````

Now, we want to take sum up the absolute value of the difference between each
row in each of these columns.  First, let's write an expression that computes the
difference between each column.  This can be expressed in Julia quite simply
as:

````julia
col1 .- col2
````

````
6-element Vector{Int64}:
 -2
 -1
  0
 -1
 -2
 -5
````

Now, let's say we wanted the absolute value of each of these.  We can express
that by wrapping the whole expression with `abs.(...)`:

````julia
abs.(col1 .- col2)
````

````
6-element Vector{Int64}:
 2
 1
 0
 1
 2
 5
````

Finally, if we want to sum these numbers we would get:

````julia
sum(abs.(col1 .- col2))
````

````
11
````

Note the answer we get is $11$ which, according to the instructions is the correct
answer.  Now let's write a general function that can take in our original data and
return this sum to us:

````julia
function day1(data)
    col1 = sort(data[:, 1])
    col2 = sort(data[:, 2])
    return sum(abs.(col1 .- col2))
end
````

````
day1 (generic function with 1 method)
````

...testing this on the test data set gives us:

````julia
day1(sample)
````

````
11
````

Voila!  Our function works.  Now let's use the function the compute the solutions
for day one.  For _me_, the input data for day 1 can be found in [this file](./day1.txt).
We can read that data into Julia with:

````julia
using DelimitedFiles
data = readdlm("day1.txt", Int64);
````

Using our function to compute the result we get:

````julia
day1(data)
````

````
2164381
````

Sure enough, `2,164,381` is the correct answer for day 1!

---

*This page was generated using [Literate.jl](https://github.com/fredrikekre/Literate.jl).*

