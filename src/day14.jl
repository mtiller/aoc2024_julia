# # Day 14: Restroom Redoubt

# ## Part 1

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

# ### Working with Sample Data

# ### Working with Actual Data

# ## Part 2

# ### Working with Sample Data

# ### Working with Actual Data