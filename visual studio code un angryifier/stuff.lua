
---@param pos table
---@return table
function ScreenToWorld(pos)
    return Vec3(0,0,0)
end
---@param parent string
---@param name string
---@return Vec3
function GetControlAbsolutePos(parent, name)
    return Vec3(0,0,0)
end

function Vector3()
    return Vec3()
end
function Vector3D()
    return Vec3()
end
---@class Projectile
---@field DeviceDamageBonus number
Projectile = {}

---@class Projectiles
---@type table<string, Projectile>
Projectiles = {}