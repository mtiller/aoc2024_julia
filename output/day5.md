# Day 5: Print Queue

## Part 1

### Working with Sample Data

The sample data for this part is:

````julia
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
````

````
"47|53\n97|13\n97|61\n97|47\n75|29\n61|13\n75|53\n29|13\n97|29\n53|29\n61|53\n97|53\n61|29\n47|13\n75|47\n97|75\n47|61\n75|61\n47|29\n75|13\n53|13\n\n75,47,61,53,29\n97,61,53,29,13\n75,29,13\n75,97,47,61,53\n61,13,29\n97,13,75,29,47\n"
````

The first thing we should do is parse this data into
an easier form:

````julia
parts = split(sample, "\n\n")
````

````
2-element Vector{SubString{String}}:
 "47|53\n97|13\n97|61\n97|47\n75|29\n61|13\n75|53\n29|13\n97|29\n53|29\n61|53\n97|53\n61|29\n47|13\n75|47\n97|75\n47|61\n75|61\n47|29\n75|13\n53|13"
 "75,47,61,53,29\n97,61,53,29,13\n75,29,13\n75,97,47,61,53\n61,13,29\n97,13,75,29,47\n"
````

This splits the data into the two sections.

````julia
parts[1]
````

````
"47|53\n97|13\n97|61\n97|47\n75|29\n61|13\n75|53\n29|13\n97|29\n53|29\n61|53\n97|53\n61|29\n47|13\n75|47\n97|75\n47|61\n75|61\n47|29\n75|13\n53|13"
````

...and...

````julia
parts[2][1:end-1]
````

````
"75,47,61,53,29\n97,61,53,29,13\n75,29,13\n75,97,47,61,53\n61,13,29\n97,13,75,29,47"
````

Now each of these sections needs to be parsed:

````julia
part1 = [(parse(Int, split(x, "|")[1]), parse(Int, split(x, "|")[2])) for x in split(parts[1], "\n")]
````

````
21-element Vector{Tuple{Int64, Int64}}:
 (47, 53)
 (97, 13)
 (97, 61)
 (97, 47)
 (75, 29)
 (61, 13)
 (75, 53)
 (29, 13)
 (97, 29)
 (53, 29)
 (61, 53)
 (97, 53)
 (61, 29)
 (47, 13)
 (75, 47)
 (97, 75)
 (47, 61)
 (75, 61)
 (47, 29)
 (75, 13)
 (53, 13)
````

And the second part:

````julia
part2 = [map(y -> parse(Int, y), split(x, ",")) for x in split(parts[2][1:end-1], "\n")]
````

````
6-element Vector{Vector{Int64}}:
 [75, 47, 61, 53, 29]
 [97, 61, 53, 29, 13]
 [75, 29, 13]
 [75, 97, 47, 61, 53]
 [61, 13, 29]
 [97, 13, 75, 29, 47]
````

For this section, let's create a `struct` for the data:

````julia
struct PrintQueue
    order::Vector{Tuple{Int64,Int64}}
    updates::Vector{Vector{Int64}}
end
````

Now we can write a function to parse the data and return a
`PrintQueue` object:

````julia
function parse_queue(data)
    parts = split(data, "\n\n")
    part1 = [(parse(Int, split(x, "|")[1]), parse(Int, split(x, "|")[2])) for x in split(parts[1], "\n")]
    part2 = [map(y -> parse(Int, y), split(x, ",")) for x in split(parts[2][1:end-1], "\n")]
    return PrintQueue(part1, part2)
end
````

````
parse_queue (generic function with 1 method)
````

Let's test it out with our sample data:

````julia
squeue = parse_queue(sample)
````

````
Main.var"##284".PrintQueue([(47, 53), (97, 13), (97, 61), (97, 47), (75, 29), (61, 13), (75, 53), (29, 13), (97, 29), (53, 29), (61, 53), (97, 53), (61, 29), (47, 13), (75, 47), (97, 75), (47, 61), (75, 61), (47, 29), (75, 13), (53, 13)], [[75, 47, 61, 53, 29], [97, 61, 53, 29, 13], [75, 29, 13], [75, 97, 47, 61, 53], [61, 13, 29], [97, 13, 75, 29, 47]])
````

Now we need to write a function to process the queue data be checking if a
particular sequence satisfies the order requirements.

````julia
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
````

````
correctly_ordered (generic function with 1 method)
````

Before moving forward, let's check that this function is working
properly.  The first set of order requirements are:

````julia
squeue.order
````

````
21-element Vector{Tuple{Int64, Int64}}:
 (47, 53)
 (97, 13)
 (97, 61)
 (97, 47)
 (75, 29)
 (61, 13)
 (75, 53)
 (29, 13)
 (97, 29)
 (53, 29)
 (61, 53)
 (97, 53)
 (61, 29)
 (47, 13)
 (75, 47)
 (97, 75)
 (47, 61)
 (75, 61)
 (47, 29)
 (75, 13)
 (53, 13)
````

And the first set of page updates are:

````julia
squeue.updates[1]
````

````
5-element Vector{Int64}:
 75
 47
 61
 53
 29
````

This update should be correctly ordered:

````julia
correctly_ordered(squeue.order, squeue.updates[1])
````

````
true
````

...and sure enough it is!

````julia
function correct_updates(queue::PrintQueue)
    filter(x -> correctly_ordered(queue.order, x), queue.updates)
end

function middle_element(seq)
    seq[Int(ceil(length(seq) / 2))]
end

function middle_sum(queue::PrintQueue)
    sum([middle_element(x) for x in correct_updates(queue)])
end
````

````
middle_sum (generic function with 1 method)
````

Let's test our functions.  First, let's determine what the
correctly ordered updates are:

````julia
correct_updates(squeue)
````

````
3-element Vector{Vector{Int64}}:
 [75, 47, 61, 53, 29]
 [97, 61, 53, 29, 13]
 [75, 29, 13]
````

Fortunately, these are exactly the updates that we know
are correct.  Now we simply need to extract the middle numbers
from each of these updates and sum them:

````julia
sum([middle_element(x) for x in correct_updates(squeue)])
````

````
143
````

Sure enough, the expected answer is $143$.  So let's wrap all
this up in a function.

````julia
function check_data(data)
    queue = parse_queue(data)
    sum([middle_element(x) for x in correct_updates(queue)])
end
````

````
check_data (generic function with 1 method)
````

Testing it, we do indeed get $143$:

````julia
check_data(sample)
````

````
143
````

### Working with Actual Data

Now, working with the actual data we get:

````julia
data = read("day5.txt", String);

check_data(data)
````

````
5639
````

...and $5639$ is the correct answer!

## Part 2

---

*This page was generated using [Literate.jl](https://github.com/fredrikekre/Literate.jl).*

