# Day 9: Disk Fragmenter

## Preliminaries

````julia
using BenchmarkTools
````

Let's define a function to indicate if a give character represents
empty space (for this exercise):

````julia
isempty = x -> x == "."
````

````
#1 (generic function with 1 method)
````

## Part 1

### Working with Sample Data

Our sample data for the compressed disk map is:

````julia
sample = "2333133121414131402"
````

````
"2333133121414131402"
````

Our first step will be to write a function that decompresses
this disk map.

````julia
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
````

````
15-element Vector{Any}:
 0
  nothing
  nothing
 1
 1
 1
  nothing
  nothing
  nothing
  nothing
 2
 2
 2
 2
 2
````

Another important test as is:

````julia
decompress("90909")
````

````
27-element Vector{Any}:
 0
 0
 0
 0
 0
 0
 0
 0
 0
 1
 1
 1
 1
 1
 1
 1
 1
 1
 2
 2
 2
 2
 2
 2
 2
 2
 2
````

Now let's use this function on our sample data:

````julia
decompress(sample)
````

````
42-element Vector{Any}:
 0
 0
  nothing
  nothing
  nothing
 1
 1
 1
  nothing
  nothing
  nothing
 2
  nothing
  nothing
  nothing
 3
 3
 3
  nothing
 4
 4
  nothing
 5
 5
 5
 5
  nothing
 6
 6
 6
 6
  nothing
 7
 7
 7
  nothing
 8
 8
 8
 8
 9
 9
````

Now we need to compact the disk map.  Swapping characters in strings can be
quite expensive because we will constantly have to create new strings. For
this reason, we'll break the string into an array which will allow us to do
swaps in place.

````julia
function compact(w)
    # Determine the actual number of sectors that represent data
    n = count(!isnothing, w)

    # Determine the number of empty sectors
    empty = length(w) - n

    # Find the first empty sector
    i = findfirst(isnothing, w)

    # For each empty sector that exists in the data...
    for k in 1:empty
        # Find the last kth last sector
        j = length(w) - (k - 1)
        # If it is empty, skip it
        if isnothing(w[j])
            continue
        end
        # Swap i (first empty sector) with j (last non-empty sector)
        w[i], w[j] = w[j], w[i]
        # Find the _next_ empty sector
        i = findnext(isnothing, w, i)
    end
    w
end

compact(decompress(sample))
````

````
42-element Vector{Any}:
 0
 0
 9
 9
 8
 1
 1
 1
 8
 8
 8
 2
 7
 7
 7
 3
 3
 3
 6
 4
 4
 6
 5
 5
 5
 5
 6
 6
  nothing
  nothing
  nothing
  nothing
  nothing
  nothing
  nothing
  nothing
  nothing
  nothing
  nothing
  nothing
  nothing
  nothing
````

Fortunately, the compacted data matches the expected answer:

```
0099811188827773336446555566..............
```

Now we need to compute the checksum:

````julia
function checksum(decompressed)
    sum([(i - 1) * (isnothing(c) ? 0 : c) for (i, c) in enumerate(decompressed)])
end

checksum(compact(decompress(sample)))
````

````
1928
````

### Working with Actual Data

To ensure correctness, let's create a "checksum" that is position independent.
We can then use this to ensure that compacting didn't "break" anyting:

````julia
function pichecksum(data)
    sum([isnothing(c) ? 0 : c for c in data])
end
````

````
pichecksum (generic function with 1 method)
````

Our actual data is quite lengthy, so let's read it from a file:

````julia
data = read("day9.txt", String)[1:end-1];
````

Now let's decompress it:

````julia
decomp = decompress(data);
````

Our position independent checksum is:

````julia
pichecksum(decomp)
````

````
249258318
````

Then let's compact it:

````julia
comp = compact(decomp);
````

After compression, our position independent checksum is:

````julia
pichecksum(comp)
````

````
249258318
````

Finally, let's take the checksum:

````julia
checksum(comp)
````

````
6332189866718
````

...and the correct answer *is* $6332189866718$.

## Part 2

For this part, the compacting works differently because we want to keep the
files together.  So we will attempt to move the highest ID file (_not_ the
largest file) to left most space of free sectors but *only if possible*.

For this exercise, it will be useful to enumerate all free spaces in terms of their size
and where they start.

````julia
function blanks(data)
    ret = []
    id = 0
    i = findfirst(isnothing, data)
    while i != nothing
        j = findnext(!isnothing, data, i)
        if !isnothing(j)
            push!(ret, (i, j - i))
            i = findnext(isnothing, data, j)
        else
            break
        end
    end
    ret
end
````

````
blanks (generic function with 1 method)
````

Our compact function then becomes:

````julia
function compact2(d)
    # Copy the data
    data = copy(d)
    # Find out the largest file id present on the disk
    maxid = max(filter(!isnothing, data)...)
    # Find the _end_ of the file with the largest id
    kend = findlast(x -> x == maxid, data)

    spaces = blanks(data)
    # Iterate over the file ids from largest to smallest
    for k in maxid:-1:1
        # Find the _start_ of the file with id `k`
        kstart = findprev(x -> x != k, data, kend) + 1
        # Determine the side of the file
        space = (kend - kstart) + 1
        # Find the next blank space that could hold this file
        blank = findfirst(x -> x[2] >= space, spaces)
        # If the free space is big enough to accommodate file `k` and
        # we are moving it to a space that is left of it, then
        # move it there
        if !isnothing(blank) && kstart > spaces[blank][1]
            loc = spaces[blank]
            for l in 0:space-1
                data[loc[1]+l] = k
                data[kstart+l] = nothing
            end
        end
        kend = findprev(x -> x == k - 1, data, kstart + 1)
        spaces = blanks(data)
    end
    return data
end
````

````
compact2 (generic function with 1 method)
````

### Working with Sample Data

Let's recompute our decompressed sample data:

````julia
sdecomp = decompress(sample)
````

````
42-element Vector{Any}:
 0
 0
  nothing
  nothing
  nothing
 1
 1
 1
  nothing
  nothing
  nothing
 2
  nothing
  nothing
  nothing
 3
 3
 3
  nothing
 4
 4
  nothing
 5
 5
 5
 5
  nothing
 6
 6
 6
 6
  nothing
 7
 7
 7
  nothing
 8
 8
 8
 8
 9
 9
````

First, let's test our `blanks` function:

````julia
blanks(sdecomp)
````

````
8-element Vector{Any}:
 (3, 3)
 (9, 3)
 (13, 3)
 (19, 1)
 (22, 1)
 (27, 1)
 (32, 1)
 (36, 1)
````

Rendering it as a string gives:

````julia
function render(data)
    join([isnothing(c) ? "." : string(c) for c in data], " ")
end

render(sdecomp)
````

````
"0 0 . . . 1 1 1 . . . 2 . . . 3 3 3 . 4 4 . 5 5 5 5 . 6 6 6 6 . 7 7 7 . 8 8 8 8 9 9"
````

Compacting our sample data then gives us:

````julia
render(compact2(decompress(sample)))
````

````
"0 0 9 9 2 1 1 1 7 7 7 . 4 4 . 3 3 3 . . . . 5 5 5 5 . 6 6 6 6 . . . . . 8 8 8 8 . ."
````

### Working with Actual Data

---

*This page was generated using [Literate.jl](https://github.com/fredrikekre/Literate.jl).*

