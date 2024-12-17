# # Day 11: Plutonian Pebbles

# ## Part 1

# ### Working with Sample Data

s1 = "0 1 10 99 999"

# First let's write a function to parse our input:
function parse_stones(data)
    [parse(Int, x) for x in split(data, " ")]
end

parse_stones(s1)

# Now we need to write a function to map a given number into
# one or more numbers

function process_stone(n)
    if n == 0
        return [1]
    end
    str = "$(n)"
    if length(str) % 2 == 0
        first = str[1:div(end, 2)]
        second = str[div(end, 2)+1:end]
        return [parse(Int, first), parse(Int, second)]
    end
    return [n * 2024]
end

# Let's run a few test cases:

[process_stone(x) for x in parse_stones(s1)]

# Looks good, now let's write a function to do this and then flatten
# them:

function next_stones(stones)
    vcat([process_stone(x) for x in stones]...)
end

next_stones(parse_stones(s1))

function next_n_stones(stones, n)
    for i in 1:n
        stones = next_stones(stones)
    end
    stones
end

# Now let's write a function to perform `n` iterations of this process.

function iter_stones(stones, n)
    tasks = map(stones) do stone
        Threads.@spawn next_n_stones([stone], n)
    end
    vcat(fetch.(tasks)...)
end

s2 = "125 17"

join(iter_stones(parse_stones(s2), 5), " ")

# Woohoo!  After 5 blinks we expect exactly:

# ```
# "1036288 7 2 20 24 4048 1 4048 8096 28 67 60 32"
# ```

# How many stones will we have after 25 iterations?

length(iter_stones(parse_stones(s2), 25))

# Perfect, $55312$ is the expected number of stones!

# ### Working with Actual Data

# For once, our actual data is pretty simple:

data = "510613 358 84 40702 4373582 2 0 1584"

# But how many stones will we get after 25 iterations with this seed?

length(iter_stones(parse_stones(data), 25))

# Bingo!  $217812$ is the right answer!

# ## Part 2

# Part 2 looks simple.  We just need to run *75* iterations.  But the problem 
# here is that the size of the vector gets larger and larger.  But it turns out we 
# never actually need to assemble the complete list.  We only need to compute 
# how many elements will result.  Also, because this is all order preserving we 
# can actually deal with this serially and recursively which will save tons
# of memory allocations.

# We will need a function to compute the number of digits in a number:
function ndigits(x)
    ceil(Int, log10(x + 1))
end

# So we need to formulate the problem a different way so that we use recursion to 
# just perform a simple tree traversal.  Given an initial collection of `stones`,
# how many stones will we have after `n` iterations.

function count_stone(stone, n)
    ## If there are no more iterations, then there is just this one stone
    if n == 0
        return 1
    end
    ## If the stone value is zero, then it becomes a 1 and iterates n-1 more times
    if stone == 0
        return count_stone(1, n - 1)
    end


    ## In this section, we need to check to see if the stone value has
    ## an even number of digits.  
    nd = ndigits(stone)
    if nd % 2 == 0
        factor = 10^div(nd, 2)
        n1 = div(stone, factor)
        n2 = mod(stone, factor)
        return count_stone(n1, n - 1) + count_stone(n2, n - 1)
    end

    ## If we get here, it means that our stone is not 0 and does not have
    ## an even number of digits.  In this case, we multiple it by 2024 and
    ## then iterate n-1 times on that value.
    return count_stone(stone * 2024, n - 1)
end

# Let's try this on our sample data:

sum([count_stone(x, 25) for x in parse_stones(s2)])

# As expected, we get $55312$.

# And again with our real data:

sum([count_stone(x, 25) for x in parse_stones(data)])

# Again, we get the expected answer of $217812$.

# Seems fast enough, so let's try it with 75 iterations:

# count_stones(parse_stones(data), 75)

# Tada! 

# This is still a bit slow, so let's create a version that can
# exploit multiple threads by parallelizing the calculation at
# the root of the tree:

function pcount_stones(stones, n)
    if n == 0
        return length(stones)
    end
    tasks = map(stones) do stone
        Threads.@spawn count_stone(stone, n)
    end
    chunks = fetch.(tasks)
    sum(chunks)
end

# Let's try this on our sample data and see if we get $55312$:

pcount_stones(parse_stones(s2), 25)

# And again with our real data and see if we get $217812$:

pcount_stones(parse_stones(data), 25)

# OK, now let's try this for the full 75 iterations

# pcount_stones(parse_stones(data), 75)
