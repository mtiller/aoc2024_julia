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

## Part 2

### Working with Sample Data

### Working with Actual Data

---

*This page was generated using [Literate.jl](https://github.com/fredrikekre/Literate.jl).*

