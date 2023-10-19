--scripts/math/dampening.lua

Dampening = {}
function Dampening.SpringDampening(springConst, displacement, dampening, velocity)
    local force = springConst * displacement - dampening * velocity
    return force
end

--velocity as a vector
function Dampening.DirectionalDampening(springConst, displacement, dampening, velocity, directionVector)
    local velocityInDirection = Vec2Dot(velocity, directionVector)
    local force = springConst * displacement - dampening * velocityInDirection * directionVector
    
    return force
end