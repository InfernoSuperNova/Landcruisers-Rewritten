function Vec2Perp(v)
    return Vec3(-v.y, v.x)
end

function Vec2Normalize(v)
    local mag = math.sqrt(v.x * v.x + v.y * v.y)
    if mag > 0 then
        v.x = v.x / mag
        v.y = v.y / mag
    end
    return v
end