# # Day 7: Bride Repair

# ### Working with Sample Data

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

# Here is a function that parses the data:

function parse_calibration(data)
    parts = filter(x -> x != "", split(data, "\n"))
    [(parse(Int64, split(x, ": ")[1]), [parse(Int64, y) for y in split(split(x, ": ")[2], " ")]) for x in parts]
end

parse_calibration(sample)

# Now let's write a function that takes a series of values 
# and determines the possible evaluations of that sequence with 
# different operators

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

# Let's test this with a few simple cases:

possible_evaluations([2, 3])

# Sure enough, 2+3 and 2*3 are the two possible evaluations.  Lets
# try a slightly more complicated case:

possible_evaluations([1, 2, 3])

# This time we get 1+2+3 (6), 1+2*3 (7), 1*2+3 (5), and 1*2*3 (6).  This is the
# correct result.

# One of the real cases we need to worry about is:

possible_evaluations([81, 40, 27])

# So now let's find all the calibrations that we can make work with only `+` and `*`:

function working_calibrations(data)
    parsed = parse_calibration(data)
    filter(x -> x[1] in possible_evaluations(x[2]), parsed)
end

working_calibrations(sample)

# Now let's sum the first elements:

sum([x[1] for x in working_calibrations(sample)])

# Sure enough, $3749$ is the correct answer.  Let's make a function
# for this:

function part1(data)
    sum([x[1] for x in working_calibrations(data)])
end

part1(sample)

# ### Working with Actual Data

data = read("day7.txt", String);

part1(data)

# ...and, fortunately, $3,119,088,655,389$ is the right answer!

# ## Part 2

# ### Working with Sample Data

# Adding the `||` operator, we now compute possible evaluations as follows:

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

# Doing a quick check:

possible_evaluations2([17, 8, 14])

# Now let's filter working calibrations with this new operator:

function working_calibrations2(data)
    parsed = parse_calibration(data)
    filter(x -> x[1] in possible_evaluations2(x[2]), parsed)
end

function part2(data)
    sum([x[1] for x in working_calibrations2(data)])
end

part2(sample)

# Sure enough, $11387$ is the correct answer.

# ### Working with Actual Data

# Now running this on the real data we get:

part2(data)

# and $264,184,041,398,847$ is the correct answer!
