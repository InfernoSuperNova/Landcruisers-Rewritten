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

function Vec2Average(vectors)
    local average = Vec3(0,0)
    for _, vector in pairs(vectors) do

        average = average + vector
    end
    return Vec3(average.x / #vectors, average.y / #vectors)
end

function Vec2Mag(v)
    return math.sqrt(v.x * v.x + v.y * v.y)

end

function Vec2Dot(v1, v2)
    return v1.x * v2.x + v1.y * v2.y
end
function Vec2Invert(v)
    return Vec3(-v.x, -v.y)
end
function Vec2Cross(v1, v2)
    return v1.x * v2.y - v1.y * v2.x
end
--create a minimum sized rectangle around a polygon
function CalculateSquare(points)
    local minX, minY, maxX, maxY = math.huge, math.huge, -math.huge, -math.huge

    for _, point in pairs(points) do
        if point.x < minX then minX = point.x end
        if point.x > maxX then maxX = point.x end
        if point.y < minY then minY = point.y end
        if point.y > maxY then maxY = point.y end
    end
    
    local pointA = Vec3(minX, minY)
    local pointB = Vec3(minX, maxY)
    local pointC = Vec3(maxX, maxY)
    local pointD = Vec3(maxX, minY)
    
    
    return {pointA, pointB, pointC, pointD}
end

  
function MinimumCircularBoundary(points)
    local square = CalculateSquare(points)
    local radius = Vec2Mag(square[3] - square[1]) / 2
    local pos = Vec2Average(square)
    return {
        x = pos.x, y = pos.y, r = radius, square = square
    }
end

function MinimumWheelCircularBoundary(wheels)
    local points = {}
    for _, wheel in pairs(wheels) do
        table.insert(points, wheel:GetPos())
    end
    return MinimumCircularBoundary(points)
end
