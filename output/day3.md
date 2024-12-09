# Day 3: Mull It Over

## Part 1

### Working with Sample Data

This time around, our sample data looks like this:

````julia
sample = "xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))"
````

````
"xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))"
````

This is meant to be a series of instructions to be evaluated/executed but the
string has been corrupted.  We need to write code to provide the correct
evaluation.

Ideally, we'd like to extract all calls to `mul` out of This
line.  For this, we can use a simple regular expression:

````julia
exp = r"mul\((\d+),(\d+)\)"
````

````
r"mul\((\d+),(\d+)\)"
````

Now let's find all the matches...

````julia
collect(eachmatch(exp, sample))
````

````
4-element Vector{RegexMatch}:
 RegexMatch("mul(2,4)", 1="2", 2="4")
 RegexMatch("mul(5,5)", 1="5", 2="5")
 RegexMatch("mul(11,8)", 1="11", 2="8")
 RegexMatch("mul(8,5)", 1="8", 2="5")
````

We can extract the numbers and multiple them with:

````julia
[parse(Int, m[1]) * parse(Int, m[2]) for m in eachmatch(exp, sample)]
````

````
4-element Vector{Int64}:
  8
 25
 88
 40
````

Now, all that is left is to sum them:

````julia
sum([parse(Int, m[1]) * parse(Int, m[2]) for m in eachmatch(exp, sample)])
````

````
161
````

Sure enough, `161` is the correct answer.

Putting all this into a function gives us:

````julia
function part1(data)
    exp = r"mul\((\d+),(\d+)\)"
    return sum([parse(Int, m[1]) * parse(Int, m[2]) for m in eachmatch(exp, data)])
end
````

````
part1 (generic function with 1 method)
````

And sure enough, this gives us `161` as well:

````julia
part1(sample)
````

````
161
````

### Working with Actual Data

Our actual data is pretty messy (see [here](./day3.txt)).  We can read it in with:

````julia
data = read("./day3.txt", String);
````

Running our function on this yields:

````julia
part1(data)
````

````
175615763
````

...which is the right answer!

## Part 2

### Working with Sample Data

There seems to be a bit of a misprint in the instructions because
the sample data has changed subtly between part 1 and part 2.  Specifically,
our sample data is now:

````julia
sample = "xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))"
````

````
"xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))"
````

So, we modify our regexp to catch all three instructions (`do`, `don't` and `mul`)

````julia
exp = r"(mul\((\d+),(\d+)\)|do(n\'t)?)"
````

````
r"(mul\((\d+),(\d+)\)|do(n\'t)?)"
````

Now let's find all the matches...

````julia
collect(eachmatch(exp, sample))
````

````
6-element Vector{RegexMatch}:
 RegexMatch("mul(2,4)", 1="mul(2,4)", 2="2", 3="4", 4=nothing)
 RegexMatch("don't", 1="don't", 2=nothing, 3=nothing, 4="n't")
 RegexMatch("mul(5,5)", 1="mul(5,5)", 2="5", 3="5", 4=nothing)
 RegexMatch("mul(11,8)", 1="mul(11,8)", 2="11", 3="8", 4=nothing)
 RegexMatch("do", 1="do", 2=nothing, 3=nothing, 4=nothing)
 RegexMatch("mul(8,5)", 1="mul(8,5)", 2="8", 3="5", 4=nothing)
````

Our evaluation function is a little trickier because it needs to
keep track of one element of state, _i.e._ whether multiplies
are active.

````julia
function part2(data)
    exp = r"(mul\((\d+),(\d+)\)|do(n\'t)?)"
    active = true
    sum = 0
    for m in eachmatch(exp, data)
        if m[1] == "do"
            active = true
        elseif m[1] == "don't"
            active = false
        elseif active
            term = parse(Int, m[2]) * parse(Int, m[3])
            if active
                sum += term
            end
        end
    end
    sum
end
````

````
part2 (generic function with 1 method)
````

Let's try it out on the sample data:

````julia
part2(sample)
````

````
48
````

Excellent, `48` is the expected answer.

### Working with Actual Data

Let's try it out on the actual data:

````julia
part2(data)
````

````
74361272
````

Sure enough, `74,361,272` is the expected answer.

Now, on to [Day 4](./day4).

---

*This page was generated using [Literate.jl](https://github.com/fredrikekre/Literate.jl).*

