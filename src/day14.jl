# # Day 14: Restroom Redoubt

# ## Part 1

# ### Working with Sample Data

# This is the sample data that we've been given:

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

# This is a single robot that we can use to test our simulation of movement.

single = """
p=2,4 v=2,-3
"""

# This is a struct to capture the information we need about each individual 
# robot.

@kwdef struct Robot
    ## These are the position of the robot
    x::Int
    y::Int
    ## These represent the velocity of the robot
    vx::Int
    vy::Int
end

# This function parses our data into a vector of robots
function parse_robots(data)
    robots = []
    lines = split(data, "\n")
    for line in lines
        if startswith(line, "p=")
            (pos, vel) = split(line, " ")
            (x, y) = split(pos[3:end], ",")
            (vx, vy) = split(vel[3:end], ",")
            r = Robot(parse(Int, x), parse(Int, y), parse(Int, vx), parse(Int, vy))
            push!(robots, r)
        end
    end
    robots
end

# Let's parse our sample robot information and check that it looks right:

parse_robots(sample)

# This function updates our robots to their new positions after `t` seconds.

function after(robots, t, width, height)
    for i in 1:t
        robots = [Robot(mod(r.x + r.vx, width), mod(r.y + r.vy, height), r.vx, r.vy) for r in robots]
    end
    robots
end

# Write a function to count how many robots are in each location:

function tally_robots(robots, width, height)
    grid = fill(0, height, width)
    for r in robots
        grid[r.y+1, r.x+1] += 1
    end
    grid
end

# This function is useful for visualizing a collection of robots.

function visualize(robots, width, height)
    grid = tally_robots(robots, width, height)
    mx = div(width - 1, 2)
    my = div(height - 1, 2)
    rows = []
    for i in 1:height
        if i == my + 1
            push!(rows, "="^(width + 2))
        end
        push!(rows, "$(join(grid[i, 1:mx-1], ""))|$(grid[i, mx])|$(join(grid[i, mx+1:end], ""))")
        if i == my + 1
            push!(rows, "="^(width + 2))
        end
    end
    rows
end

# These are the first few frames of simulation of the single robot:

visualize(after(parse_robots(single), 0, 11, 7), 11, 7)

# After one second, the robot is here:

visualize(after(parse_robots(single), 1, 11, 7), 11, 7)

# After two seconds:

visualize(after(parse_robots(single), 2, 11, 7), 11, 7)

# After three seconds:

visualize(after(parse_robots(single), 3, 11, 7), 11, 7)

# After four seconds:

visualize(after(parse_robots(single), 4, 11, 7), 11, 7)

# After five seconds:

visualize(after(parse_robots(single), 5, 11, 7), 11, 7)


# This function computes the safety factor required to solve part 1.

function safety_factor(robots, t, width, height)
    robots = after(robots, t, width, height)
    q1 = 0
    q2 = 0
    q3 = 0
    q4 = 0
    mx = div(width - 1, 2)
    my = div(height - 1, 2)
    for r in robots
        if r.x < mx && r.y < my
            q1 += 1
        end
        if r.x > mx && r.y < my
            q2 += 1
        end
        if r.x < mx && r.y > my
            q3 += 1
        end
        if r.x > mx && r.y > my
            q4 += 1
        end
    end
    (q1 * q2 * q3 * q4, q1, q2, q3, q4)
end

safety_factor(parse_robots(sample), 0, 11, 7)

# After 100 seconds the robots are in the following position:

sample_robots = parse_robots(sample)
robots100 = after(sample_robots, 100, 11, 7)

# When visualized, their locations look like this:

visualize(robots100, 11, 7)

# The safety factor would then be:

safety_factor(parse_robots(sample), 100, 11, 7)

# ### Working with Actual Data

# Now let's load our actual data and compute the safety factor for that:

data = read("day14.txt", String);

safety_factor(parse_robots(data), 100, 101, 103)

# Fantastic, the answer is $233709840$.

# ## Part 2

actual_robots = parse_robots(data);

# Now we need to figure out how much time needs to elapse before the
# robots form a christmas tree.

function time_to_tree(data)
    actual_robots = parse_robots(data)
    best = copy(actual_robots)
    best_total = 1
    best_time = 0

    for t in 1:100000
        actual_robots = after(actual_robots, 1, 101, 103)
        tally = tally_robots(actual_robots, 101, 103)
        unique = count(x -> x === 1, tally)
        if unique > best_total
            best = copy(actual_robots)
            best_total = unique
            best_time = t
        end
    end
    (best_time, best)
end

(tree_time, tree) = time_to_tree(data)

tree_time

# The time at which the robots form a christmas tree is $6620$ seconds and this 
# is the tree:

visualize(tree, 101, 103)

# ### Working with Sample Data

# ### Working with Actual Data