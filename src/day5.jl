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

squeue = parse_queue(sample)

# Now we need to write a function to process the queue data be checking if a
# particular sequence satisfies the order requirements.

function correctly_ordered(order::Vector{Tuple{Int64,Int64}}, seq)
    for (first, second) in order
        fi = findfirst(x -> x == first, seq)
        si = findfirst(x -> x == second, seq)
        if !isnothing(fi) && !isnothing(si) && (fi > si)
            return false
        end
    end
    true
end

# Before moving forward, let's check that this function is working
# properly.  The first set of order requirements are:

squeue.order

# And the first set of page updates are:

squeue.updates[1]

# This update should be correctly ordered:

correctly_ordered(squeue.order, squeue.updates[1])

# ...and sure enough it is!

function correct_updates(queue::PrintQueue)
    filter(x -> correctly_ordered(queue.order, x), queue.updates)
end

function middle_element(seq)
    seq[Int(ceil(length(seq) / 2))]
end

function middle_sum(queue::PrintQueue)
    sum([middle_element(x) for x in correct_updates(queue)])
end

# Let's test our functions.  First, let's determine what the 
# correctly ordered updates are:

correct_updates(squeue)

# Fortunately, these are exactly the updates that we know
# are correct.  Now we simply need to extract the middle numbers 
# from each of these updates and sum them:

sum([middle_element(x) for x in correct_updates(squeue)])

# Sure enough, the expected answer is $143$.  So let's wrap all 
# this up in a function.

function check_data(data)
    queue = parse_queue(data)
    sum([middle_element(x) for x in correct_updates(queue)])
end

# Testing it, we do indeed get $143$:

check_data(sample)

# ### Working with Actual Data

# Now, working with the actual data we get:

data = read("day5.txt", String);

check_data(data)

# ...and $5639$ is the correct answer!

# ## Part 2

# For this section we first have to identify all the _incorrectly_ ordered
# updates.  So we will write a slight variation on a previous function:

function incorrect_updates(queue::PrintQueue)
    filter(x -> !correctly_ordered(queue.order, x), queue.updates)
end

# ### Working with Sample Data

incorrect_updates(squeue)

# Our next step will be to try and identify, among a given 
# sequence of updates, the one that can appear first in the sequence.

function is_first(order::Vector{Tuple{Int64,Int64}}, head::Int64, rest::Vector{Int64})
    for (first, second) in order
        fi = findfirst(x -> x == first, rest)
        if second == head && !isnothing(fi)
            return false
        end
    end
    return true
end

# Let's check this function.  We expect $97$ to be the first element, so 
# let's confirm that it `is_first` returns true:

is_first(squeue.order, 97, squeue.updates[1])

# Now let's write a function that orders a given sequence
# according to the order rules:

function order_seq(order::Vector{Tuple{Int64,Int64}}, seq::Vector{Int64})
    if length(seq) == 1
        return seq
    end
    fi = findfirst(x -> is_first(order, x, seq), seq)
    rest = vcat(seq[1:fi-1], seq[fi+1:end])
    vcat(seq[fi], order_seq(order, rest))
end

# So let's test this on the first sequence:

order_seq(squeue.order, incorrect_updates(squeue)[1])

# It turns out `[97, 75, 47, 61, 53]` is the correct answer.  Now let's apply 
# this to each incorrect sequence and sum the middle elements:

sum([middle_element(order_seq(squeue.order, x)) for x in incorrect_updates(squeue)])

# Putting this all in a function and evaluating it gives us:

function reorder_sum(data)
    queue = parse_queue(data)
    sum([middle_element(order_seq(queue.order, x)) for x in incorrect_updates(queue)])
end

reorder_sum(sample)

# So now trying it with our real data give us:

reorder_sum(data)

# and $5273$ is the correct answer.