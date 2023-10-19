--scripts/math/math.lua

function math.sign(x)
    return x > 0 and 1 or x < 0 and -1 or 0
end

DegToRad = math.pi / 180
RadToDeg = 180 / math.pi