# # Day 9: Disk Fragmenter

# ## Preliminaries

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
    join([(i % 2 == 1 ? "$(div(i,2))"^parse(Int, c) : "."^parse(Int, c)) for (i, c) in enumerate(data)], "")
end

decompress("12345")

# Now let's use this function on our sample data:

decompress(sample)

# Now we need to compact the disk map.  Swapping characters in strings can be
# quite expensive because we will constantly have to create new strings. For
# this reason, we'll break the string into an array which will allow us to do
# swaps in place.

function compact(data)
    ## Now break the data into an array
    w = split(data, "")

    ## Determine the actual number of characters that represent data
    n = count(!isempty, w)
    iters = length(w) - n

    ## As long as there is an empty space in the first `n` entries
    ## of the array, we can still compress the data further.
    while count(isempty, w[1:n]) > 0
        ## Find the index of the first empty space
        i = findfirst(isempty, w)
        ## ...and then the index of the last non-empty space
        j = findlast(!isempty, w)
        ## Swap these two
        w[i], w[j] = w[j], w[i]
    end
    ## When we are all done, convert the array back to a string
    join(w, "")
end

@btime compact(decompress(sample))

# Now we need to compute the checksum:

function checksum(decompressed)
    sum([(i - 1) * (c == '.' ? 0 : parse(Int, c)) for (i, c) in enumerate(decompressed)])
end

checksum(compact(decompress(sample)))

# ### Working with Actual Data

# Our actual data is quite lengthy, so let's read it from a file:

# data = read("day9.txt", String)[1:end-1];

# # Now let's decompress it:

# decomp = decompress(data);

# # # Then let's compact it:

# comp = compact(decomp);

# # Finally, let's take the checksum:

# checksum(compact(decompress(data)))

# ## Part 2

# ### Working with Sample Data

# ### Working with Actual Data
