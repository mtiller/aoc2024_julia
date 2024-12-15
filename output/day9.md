# Day 9: Disk Fragmenter

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
    space = false
    id = 0
    ret = ""
    for c in data
        d = parse(Int, c)
        if space
            ret *= "."^d
        else
            ret *= "$(id)"^d
            id += 1
        end
        space = !space
    end
    ret
end

decompress("12345")
````

````
"0..111....22222"
````

Now let's use this function on our sample data:

````julia
decompress(sample)
````

````
"00...111...2...333.44.5555.6666.777.888899"
````

### Working with Actual Data

## Part 2

### Working with Sample Data

### Working with Actual Data

---

*This page was generated using [Literate.jl](https://github.com/fredrikekre/Literate.jl).*

