--scripts/math/math.lua

function math.sign(x)
    return x > 0 and 1 or x < 0 and -1 or 0
end

function math.clamp(x, min, max)
    return math.min(math.max(x, min), max)
end

DegToRad = math.pi / 180
RadToDeg = 180 / math.pi