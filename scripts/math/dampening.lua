Dampening = {}
function Dampening.SpringDampening(springConst, displacement, dampening, velocity)
    local force = springConst * displacement - dampening * velocity
    return force
end
