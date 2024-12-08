# # Day 2: Red-Nosed Reports

# ## Part 1

# ### Working with Sample Data

# For day 2, our sample data looks like this:

sample = [
    7 6 4 2 1;
    1 2 7 8 9;
    9 7 6 2 1;
    1 3 2 4 5;
    8 6 4 4 1;
    1 3 6 7 9
]

# Here we need to determine if each row is "safe" which means:

# 1. The levels are either increasing or decreasing
# 2. The absolute value of the difference between successive numbers is at least 1 and no more than 3.

# Let's start by writing a function that determines, for a single row,
# if it is safe.  For now, let us consider the first row:

sample[1, :]

# First we need a way to determine if a given row is either 
# all increasing or all decreasing.  One way to do this is
# to compare the row to the sorted version (both ascending and descending)
# to see if they are the same.  We can express this as functions:

function is_increasing(row)
    return sort(row) == row
end

# ...and...

function is_decreasing(row)
    return sort(row, rev=true) == row
end

# Let's test these on the first row:

is_increasing(sample[1, :])

# 

is_decreasing(sample[1, :])

# So far so good.  Now we need to compute the absolute value of the 
# difference between successive elements of the row.  Manually,
# we can do this:

[abs.(sample[1, 1:end-1] - sample[1, 2:end])]

# Now let's write a function that, given a single row, can determine
# if the row is safe:

function is_safe(row)
    diffs = abs.(row[1:end-1] - row[2:end])
    max_diff = maximum(diffs)
    min_diff = minimum(diffs)
    return (is_increasing(row) || is_decreasing(row)) && (max_diff <= 3) & (min_diff >= 1)
end

# Let's test this on the first row:

is_safe(sample[1, :])

# That looks right, let's check with all the rows:

[is_safe(sample[i, :]) for i in 1:size(sample, 1)]

# Ultimately, what we need to do is count up the number of safe rows
# across the entire data set.  So our function for that would be:

function part1(data)
    return sum([is_safe(data[i, :]) for i in 1:size(data, 1)])
end

# Testing this for our sample data we get:

part1(sample)

# ### Working with Actual Data

# Now we need to try this on our actual data: