--classes/wireframe/drawableWheel.lua
DrawableWheel = {
    config = {
        spokeCount = 5,
        innerCircleRatio = 0.25,
    }
}
function DrawableWheel.Load() 
    DrawableWheel.config.spokeSpacing = 360 / DrawableWheel.config.spokeCount
end


---Draws a wheel wireframe
---@param pos Vec3
---@param radius number
---@param rotation number
---@param duration number
function DrawableWheel.Draw(pos, radius, rotation, duration)
    SpawnCircle(pos, radius, White(), duration)
    SpawnCircle(pos, radius * DrawableWheel.config.innerCircleRatio, White(), duration)
    for i = 0, 360, DrawableWheel.config.spokeSpacing do
        local spokeStart = Vec3(pos.x + radius * math.cos(math.rad(i + rotation)), pos.y + radius * math.sin(math.rad(i + rotation)))
        local spokeEnd = Vec3(pos.x + radius * DrawableWheel.config.innerCircleRatio * math.cos(math.rad(i + rotation)), pos.y + radius * DrawableWheel.config.innerCircleRatio * math.sin(math.rad(i + rotation)))
        SpawnLine(spokeStart, spokeEnd, White(), duration)
    end
end 