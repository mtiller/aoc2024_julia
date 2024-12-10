# # Day 5: Print Queue

# ## Part 1 

# ### Working with Sample Data

# The sample data for this part is:

sample = """
47|53
97|13
97|61
97|47
75|29
61|13
75|53
29|13
97|29
53|29
61|53
97|53
61|29
47|13
75|47
97|75
47|61
75|61
47|29
75|13
53|13

75,47,61,53,29
97,61,53,29,13
75,29,13
75,97,47,61,53
61,13,29
97,13,75,29,47
"""

# The first thing we should do is parse this data into
# an easier form:

parts = split(sample, "\n\n")

# This splits the data into the two sections.

parts[1]

# ...and...

parts[2][1:end-1]

# Now each of these sections needs to be parsed:

part1 = [(parse(Int, split(x, "|")[1]), parse(Int, split(x, "|")[2])) for x in split(parts[1], "\n")]

# And the second part:

part2 = [map(y -> parse(Int, y), split(x, ",")) for x in split(parts[2][1:end-1], "\n")]

# For this section, let's create a `struct` for the data:

struct PrintQueue
    order::Vector{Tuple{Int64,Int64}}
    updates::Vector{Vector{Int64}}
end

# Now we can write a function to parse the data and return a 
# `PrintQueue` object:

function parse_queue(data)
    parts = split(data, "\n\n")
    part1 = [(parse(Int, split(x, "|")[1]), parse(Int, split(x, "|")[2])) for x in split(parts[1], "\n")]
    part2 = [map(y -> parse(Int, y), split(x, ",")) for x in split(parts[2][1:end-1], "\n")]
    return PrintQueue(part1, part2)
end

# Let's test it out with our sample data:

parse_queue(sample)

# Now we need to write a function to process the queue data:


# ## Part 2
