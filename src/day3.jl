# # Day 3: Mull It Over

# ## Part 1 

# ### Working with Sample Data

# This time around, our sample data looks like this:

sample = "xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))"

# This is meant to be a series of instructions to be evaluated/executed but the
# string has been corrupted.  We need to write code to provide the correct
# evaluation.

# Ideally, we'd like to extract all calls to `mul` out of This
# line.  For this, we can use a simple regular expression:

exp = r"mul\((\d+),(\d+)\)"

# Now let's find all the matches...

collect(eachmatch(exp, sample))

# We can extract the numbers and multiple them with:

[parse(Int, m[1]) * parse(Int, m[2]) for m in eachmatch(exp, sample)]

# Now, all that is left is to sum them:

sum([parse(Int, m[1]) * parse(Int, m[2]) for m in eachmatch(exp, sample)])

# Sure enough, `161` is the correct answer.

# Putting all this into a function gives us:

function part1(data)
    exp = r"mul\((\d+),(\d+)\)"
    return sum([parse(Int, m[1]) * parse(Int, m[2]) for m in eachmatch(exp, data)])
end

# And sure enough, this gives us `161` as well:

part1(sample)

# ### Working with Actual Data

# Our actual data is pretty messy (see [here](./day3.txt)).  We can read it in with:

data = read("./day3.txt", String);

# Running our function on this yields:

part1(data)

# ...which is the right answer!

# ## Part 2

# ### Working with Sample Data

# There seems to be a bit of a misprint in the instructions because
# the sample data has changed subtly between part 1 and part 2.  Specifically,
# our sample data is now:

sample = "xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))"

# So, we modify our regexp to catch all three instructions (`do`, `don't` and `mul`)

exp = r"(mul\((\d+),(\d+)\)|do(n\'t)?)"

# Now let's find all the matches...

collect(eachmatch(exp, sample))

# Our evaluation function is a little trickier because it needs to 
# keep track of one element of state, _i.e._ whether multiplies 
# are active.

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

# Let's try it out on the sample data:

part2(sample)

# Excellent, `48` is the expected answer.

# ### Working with Actual Data

# Let's try it out on the actual data:

part2(data)

# Sure enough, `74,361,272` is the expected answer.

# Now, on to [Day 4](./day4).