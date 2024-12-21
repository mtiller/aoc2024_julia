# Day 14: Restroom Redoubt

## Part 1

````julia
sample = """
p=0,4 v=3,-3
p=6,3 v=-1,-3
p=10,3 v=-1,2
p=2,0 v=2,-1
p=0,0 v=1,3
p=3,0 v=-2,-2
p=7,6 v=-1,-3
p=3,0 v=-1,-2
p=9,3 v=2,3
p=7,3 v=-1,2
p=2,4 v=2,-3
p=9,5 v=-3,-3
"""

@kwdef struct Robot
    x0::Int
    y0::Int
    vx::Int
    vy::Int
end

function parse_robots(data)
    robots = []
    lines = split(data, "\n")
    for line in lines
        if startswith(line, "p=")
            (pos, vel) = split(line, " ")
            (x0, y0) = split(pos[3:end], ",")
            (vx, vy) = split(vel[3:end], ",")
            r = Robot(parse(Int, x0), parse(Int, y0), parse(Int, vx), parse(Int, vy))
            push!(robots, r)
        end
    end
    robots
end

parse_robots(sample)
````

````
12-element Vector{Any}:
 Main.var"##329".Robot(0, 4, 3, -3)
 Main.var"##329".Robot(6, 3, -1, -3)
 Main.var"##329".Robot(10, 3, -1, 2)
 Main.var"##329".Robot(2, 0, 2, -1)
 Main.var"##329".Robot(0, 0, 1, 3)
 Main.var"##329".Robot(3, 0, -2, -2)
 Main.var"##329".Robot(7, 6, -1, -3)
 Main.var"##329".Robot(3, 0, -1, -2)
 Main.var"##329".Robot(9, 3, 2, 3)
 Main.var"##329".Robot(7, 3, -1, 2)
 Main.var"##329".Robot(2, 4, 2, -3)
 Main.var"##329".Robot(9, 5, -3, -3)
````

### Working with Sample Data

### Working with Actual Data

## Part 2

### Working with Sample Data

### Working with Actual Data

---

*This page was generated using [Literate.jl](https://github.com/fredrikekre/Literate.jl).*

