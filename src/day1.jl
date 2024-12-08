# # Day 1: Historian Hysteria

# ## Part 1

# ### Working with Sample Data

# OK, this is day one of Advent of Code 2024.  I'm creating my solutions in
# Julia. I'm no Julia expert, so this is just good practice for me to sharpen my
# Julia skills.

# Let's get started.  The [instructions for day 1](https://adventofcode.com/2024/day/1) give the following
# sample input:

sample = [
    3 4;
    4 3;
    2 5;
    1 3;
    3 9;
    3 3
]

# The goal of this project is to effectively come up with a metric for the
# computing the distance between the two columns.  Compared to something like a
# straight $L_2$ norm or something, for this exercise we first sort each column
# (*independently*) in ascending order.  As a result, we get this for the first
# column:

col1 = sort(sample[:, 1])

# and then for the second column we get:

col2 = sort(sample[:, 2])

# Now, we want to take sum up the absolute value of the difference between each
# row in each of these columns.  First, let's write an expression that computes the 
# difference between each column.  This can be expressed in Julia quite simply
# as:

col1 .- col2

# Now, let's say we wanted the absolute value of each of these.  We can express 
# that by wrapping the whole expression with `abs.(...)`:

abs.(col1 .- col2)

# Finally, if we want to sum these numbers we would get:

sum(abs.(col1 .- col2))

# Note the answer we get is $11$ which, according to the instructions is the correct
# answer.  Now let's write a general function that can take in our original data and
# return this sum to us:

function part1(data)
    col1 = sort(data[:, 1])
    col2 = sort(data[:, 2])
    return sum(abs.(col1 .- col2))
end

# ...testing this on the test data set gives us:

part1(sample)

### Working with Actual Data

# Voila!  Our function works.  Now let's use the function the compute the solutions
# for day one.  For _me_, the input data for day 1 can be found in [this file](./day1.txt).
# We can read that data into Julia with:

using DelimitedFiles
data = readdlm("day1.txt", Int64);

# Using our function to compute the result we get:

part1(data)

# Sure enough, `2,164,381` is the correct answer for day 1!

### Visualization 

# Let's visualize what is going on here.  First, let's plot both of
# the columns...

using Plots
plot([col1, col2], label=["Column 1", "Column 2"])

# What we are interested in is the difference between these two data sets.
# So let's break this down into the lower of the two values and the
# upper for the two values:

lower = min.(col1, col2)

# and the upper values:

upper = max.(col1, col2)

# Now, let's plot these two values:

plot(upper, fillrange=lower, fillstyle=:/)

# We can generate a similar plot for our actual data:

plot([sort(data[:, 1]), sort(data[:, 2])], label=["Column 1", "Column 2"])

# So our calculation of `2,164,381` is the sum of the differences between
# these two lines.

# ## Part 2

# But wait, there is more.  Now we have to compute a *similarity score*.

# ### Working with Sample Data

# Again, we start with the sample data but this time we want to 
# compute the similarity score.  Here is the sample data again:

sample = [
    3 4;
    4 3;
    2 5;
    1 3;
    3 9;
    3 3
]

# To compute the similarity score we need to take each number on the left, in
# turn, and multiple it by the number of times it appears on the right, _i.e.,_

["$(x) * $(count(==(x), sample[:, 2])) = $(x * count(==(x), sample[:, 2]))" for x in sample[:, 1]]

# The products themselves are just:

[x * count(==(x), sample[:, 2]) for x in sample[:, 1]]

# And their sum is:

sum([x * count(==(x), sample[:, 2]) for x in sample[:, 1]])

# And, as the [instructions for Day 2](https://adventofcode.com/2024/day/1#part2) tell us, 
# the answer should be $31$.

# ### Working with Actual Data

# Our next step is to write a function that can do this calculation for 
# an arbitrary data set.  In Julia, such a function can be written as:

function part2(data)
    return sum([x * count(==(x), data[:, 2]) for x in data[:, 1]])
end

# Let's test our function on the sample data just to make sure we got that
# correct:

part2(sample)

# Hurray!  Now, let's it on our actual data:

part2(data)

# Excellent, another gold start, the expected answer is indeed `20719933`.  Now on to [Day 2](./day2).