# Day 7: Bride Repair

### Working with Sample Data

````julia
sample = """
190: 10 19
3267: 81 40 27
83: 17 5
156: 15 6
7290: 6 8 6 15
161011: 16 10 13
192: 17 8 14
21037: 9 7 18 13
292: 11 6 16 20
"""
````

````
"190: 10 19\n3267: 81 40 27\n83: 17 5\n156: 15 6\n7290: 6 8 6 15\n161011: 16 10 13\n192: 17 8 14\n21037: 9 7 18 13\n292: 11 6 16 20\n"
````

Here is a function that parses the data:

````julia
function parse_calibration(data)
    parts = filter(x -> x != "", split(data, "\n"))
    [(parse(Int64, split(x, ": ")[1]), [parse(Int64, y) for y in split(split(x, ": ")[2], " ")]) for x in parts]
end

parse_calibration(sample)
````

````
9-element Vector{Tuple{Int64, Vector{Int64}}}:
 (190, [10, 19])
 (3267, [81, 40, 27])
 (83, [17, 5])
 (156, [15, 6])
 (7290, [6, 8, 6, 15])
 (161011, [16, 10, 13])
 (192, [17, 8, 14])
 (21037, [9, 7, 18, 13])
 (292, [11, 6, 16, 20])
````

Now let's write a function that takes a series of values
and determines the possible evaluations of that sequence with
different operators

````julia
function possible_evaluations(seq)
    if length(seq) == 1
        return Set(seq[1])
    end
    tail = seq[end]
    rest = seq[1:end-1]
    ret = Set{Int64}()
    for x in possible_evaluations(rest)
        push!(ret, tail + x)
        push!(ret, tail * x)
    end
    return ret
end
````

````
possible_evaluations (generic function with 1 method)
````

Let's test this with a few simple cases:

````julia
possible_evaluations([2, 3])
````

````
Set{Int64} with 2 elements:
  5
  6
````

Sure enough, 2+3 and 2*3 are the two possible evaluations.  Lets
try a slightly more complicated case:

````julia
possible_evaluations([1, 2, 3])
````

````
Set{Int64} with 3 elements:
  5
  6
  9
````

This time we get 1+2+3 (6), 1+2*3 (7), 1*2+3 (5), and 1*2*3 (6).  This is the
correct result.

One of the real cases we need to worry about is:

````julia
possible_evaluations([81, 40, 27])
````

````
Set{Int64} with 3 elements:
  3267
  87480
  148
````

So now let's find all the calibrations that we can make work with only `+` and `*`:

````julia
function working_calibrations(data)
    parsed = parse_calibration(data)
    filter(x -> x[1] in possible_evaluations(x[2]), parsed)
end

working_calibrations(sample)
````

````
3-element Vector{Tuple{Int64, Vector{Int64}}}:
 (190, [10, 19])
 (3267, [81, 40, 27])
 (292, [11, 6, 16, 20])
````

Now let's sum the first elements:

````julia
sum([x[1] for x in working_calibrations(sample)])
````

````
3749
````

Sure enough, $3749$ is the correct answer.  Let's make a function
for this:

````julia
function part1(data)
    sum([x[1] for x in working_calibrations(data)])
end

part1(sample)
````

````
3749
````

### Working with Actual Data

````julia
data = read("day7.txt", String);

part1(data)
````

````
3119088655389
````

...and, fortunately, $3,119,088,655,389$ is the right answer!

## Part 2

### Working with Sample Data

Adding the `||` operator, we now compute possible evaluations as follows:

````julia
function possible_evaluations2(seq)
    if length(seq) == 1
        return Set(seq[1])
    end
    tail = seq[end]
    rest = seq[1:end-1]
    ret = Set{Int64}()
    for x in possible_evaluations2(rest)
        push!(ret, tail + x)
        push!(ret, tail * x)
        push!(ret, parse(Int64, "$(x)$(tail)"))
    end
    return ret
end
````

````
possible_evaluations2 (generic function with 1 method)
````

Doing a quick check:

````julia
possible_evaluations2([17, 8, 14])
````

````
Set{Int64} with 9 elements:
  39
  1904
  350
  2492
  13614
  17814
  2514
  192
  150
````

Now let's filter working calibrations with this new operator:

````julia
function working_calibrations2(data)
    parsed = parse_calibration(data)
    filter(x -> x[1] in possible_evaluations2(x[2]), parsed)
end

function part2(data)
    sum([x[1] for x in working_calibrations2(data)])
end

part2(sample)
````

````
11387
````

Sure enough, $11387$ is the correct answer.

### Working with Actual Data

Now running this on the real data we get:

````julia
part2(data)
````

````
264184041398847
````

and $264,184,041,398,847$ is the correct answer!

---

*This page was generated using [Literate.jl](https://github.com/fredrikekre/Literate.jl).*

