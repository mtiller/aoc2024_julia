# # Day 9: Disk Fragmenter

# ## Preliminaries

using BenchmarkTools

# Let's define a function to indicate if a give character represents
# empty space (for this exercise):

isempty = x -> x == "."

# ## Part 1

# ### Working with Sample Data

# Our sample data for the compressed disk map is:

sample = "2333133121414131402"

# Our first step will be to write a function that decompresses
# this disk map.

function decompress(data)
    ret = []
    for (i, c) in enumerate(data)
        if i % 2 == 1
            append!(ret, fill(div(i, 2), parse(Int, c)))
        else
            append!(ret, fill(nothing, parse(Int, c)))
        end
    end
    ret
end

decompress("12345")

# Another important test as is:

decompress("90909")


# Now let's use this function on our sample data:

decompress(sample)

# Now we need to compact the disk map.  Swapping characters in strings can be
# quite expensive because we will constantly have to create new strings. For
# this reason, we'll break the string into an array which will allow us to do
# swaps in place.

function compact(w)
    ## Determine the actual number of sectors that represent data
    n = count(!isnothing, w)

    ## Determine the number of empty sectors
    empty = length(w) - n

    ## Find the first empty sector
    i = findfirst(isnothing, w)

    ## For each empty sector that exists in the data...
    for k in 1:empty
        ## Find the last kth last sector
        j = length(w) - (k - 1)
        ## If it is empty, skip it
        if isnothing(w[j])
            continue
        end
        ## Swap i (first empty sector) with j (last non-empty sector)
        w[i], w[j] = w[j], w[i]
        ## Find the _next_ empty sector
        i = findnext(isnothing, w, i)
    end
    w
end

compact(decompress(sample))

# Fortunately, the compacted data matches the expected answer:
#
# ```
# 0099811188827773336446555566..............
# ```

# Now we need to compute the checksum:

function checksum(decompressed)
    sum([(i - 1) * (isnothing(c) ? 0 : c) for (i, c) in enumerate(decompressed)])
end

checksum(compact(decompress(sample)))

# ### Working with Actual Data

# To ensure correctness, let's create a "checksum" that is position independent.
# We can then use this to ensure that compacting didn't "break" anyting:

function pichecksum(data)
    sum([isnothing(c) ? 0 : c for c in data])
end

# Our actual data is quite lengthy, so let's read it from a file:

data = read("day9.txt", String)[1:end-1];

# Now let's decompress it:

decomp = decompress(data);

# Our position independent checksum is:

pichecksum(decomp)

# Then let's compact it:

comp = compact(decomp);

# After compression, our position independent checksum is:

pichecksum(comp)

# Finally, let's take the checksum:

checksum(comp)

# ## Part 2

# ### Working with Sample Data

# ### Working with Actual Data
