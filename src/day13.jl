# # Day 13: Claw Contraption

# ## Part 1

sample = """
Button A: X+94, Y+34
Button B: X+22, Y+67
Prize: X=8400, Y=5400

Button A: X+26, Y+66
Button B: X+67, Y+21
Prize: X=12748, Y=12176

Button A: X+17, Y+86
Button B: X+84, Y+37
Prize: X=7870, Y=6450

Button A: X+69, Y+23
Button B: X+27, Y+71
Prize: X=18641, Y=10279
"""

# Let's start by writing a function to parse this data:

@kwdef struct Machine
    ax::Int
    ay::Int
    bx::Int
    by::Int
    px::Int
    py::Int
end

ba = r"^Button A: X\+(\d+), Y\+(\d+)$"
bb = r"^Button B: X\+(\d+), Y\+(\d+)$"
pr = r"^Prize: X=(\d+), Y=(\d+)$"

function parse_machines(data)
    machines = []
    lines = split(data, "\n")
    while length(lines) > 0
        if lines[1] == ""
            lines = lines[2:end]
            continue
        end
        (ax, ay) = match(ba, lines[1])
        (bx, by) = match(bb, lines[2])
        (px, py) = match(pr, lines[3])
        m = Machine(parse(Int, ax), parse(Int, ay), parse(Int, bx), parse(Int, by), parse(Int, px), parse(Int, py))
        lines = lines[4:end]
        push!(machines, m)
    end
    machines
end

# ### Working with Sample Data

sm = parse_machines(sample)

# For each machine, we need to solve the following *integer* equation:
#
# $$p_x = n_a a_x + n_b b_x$$
#
# $$p_y = n_a a_y + n_b b_y$$

# A simple way to solve this is to first derive an equation for $n_a$ in terms
# of $n_b$:

# $$n_a = \frac{p_x - n_b b_x}{a_x}$$

# Now we can substitute this formula for $n_a$ into the seccond equation:

# $$p_y = \frac{p_x - n_b b_x}{a_x} a_y + n_b b_y$$

# Expand terms gives us:

# $$p_y = \frac{p_x a_y}{a_x} - n_b \frac{b_x a_y}{a_x} + n_b b_y$$

# Now combining terms again:

# $$p_y = \frac{p_x a_y}{a_x} + n_b \left(b_y - \frac{b_x a_y}{a_x}\right)$$

# Now we can rearrange to solve for $n_b$:

# $$n_b = \frac{p_y - \frac{p_x a_y}{a_x}}{b_y - \frac{b_x a_y}{a_x}}$$

# So the following function takes a machine as its argument and tells
# us how may times we need to press each button in order to get the prize.
# In the case where $n_a$ and/or $n_b$ are not integers, it returns
# `nothing`.

function tokens(m::Machine)
    nb = (m.py - (m.px * m.ay) / m.ax) / (m.by - (m.bx * m.ay) / m.ax)
    na = (m.px - nb * m.bx) / m.ax
    println("na = $na, nb = $nb")
    nai = Int64(round(na))
    nbi = Int64(round(nb))

    cpx = nai * m.ax + nbi * m.bx
    cpy = nai * m.ay + nbi * m.by

    if (cpx === m.px && cpy === m.py)
        return (nai, nbi)
    else
        return nothing
    end
end

tokens.(sm)

# Now we need to compute the cost to win all possible prizes:

function cost(data)
    machines = parse_machines(data)
    cost = 0
    for m in machines
        t = tokens(m)
        if !isnothing(t)
            (na, nb) = t
            cost += na * 3 + nb
        end
    end
    cost
end

# So the cost to win all prizes for these machines should be $480$ tokens:

cost(sample)

# ### Working with Actual Data

data = read("day13.txt", String);

# Computing the cost to win all possible prizes with our actual data
# gives us:

cost(data)

# Woohoo! the cost is, in fact, $35729$ tokens.

# ## Part 2

# For the second part, we need to adjust the prize locations by $10000000000000$ units.
# Can do this pretty easily by just transforming the machine data:

function adjust_machine(m::Machine)
    Machine(m.ax, m.ay, m.bx, m.by, m.px + 10000000000000, m.py + 10000000000000)
end

# If our cost function makes this adjustment, we get:

function cost(data)
    machines = [adjust_machine(m) for m in parse_machines(data)]
    cost = 0
    for m in machines
        t = tokens(m)
        if !isnothing(t)
            (na, nb) = t
            cost += na * 3 + nb
        end
    end
    cost
end

# ### Working with Actual Data

# Now the cost (in tokens) to win all possible prizes is:

cost(data)

# Fortunately, the costs matches the expected answer of $88584689879723$ tokens.

