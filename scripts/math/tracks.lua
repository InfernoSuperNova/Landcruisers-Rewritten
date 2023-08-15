Tracks = {}

-- Helper function to check if three points are clockwise, counterclockwise, or collinear
function Tracks.Orientation(p, q, r)
    local val = (q.pos.y - p.pos.y) * (r.pos.x - q.pos.x) - (q.pos.x - p.pos.x) * (r.pos.y - q.pos.y)
    if val == 0 then
        return 0 -- Collinear
    elseif val > 0 then
        return 1 -- Clockwise
    else
        return 2 -- Counterclockwise
    end
end

function Tracks.Distance(a, b)
    return math.sqrt((a.pos.x - b.pos.x) ^ 2 + (a.pos.y - b.pos.y) ^ 2)
end

function Tracks.GiftWrapping(circles)
    local n = #circles
    if n < 3 then
        return circles -- Invalid input, need at least 3 points
    end

    -- Find the leftmost point
    local leftmost = 1
    for i = 2, n do
        if circles[i].pos.x < circles[leftmost].pos.x then
            leftmost = i
        elseif circles[i].pos.x == circles[leftmost].pos.x and circles[i].pos.y < circles[leftmost].pos.y then
            leftmost = i
        end
    end

    -- Initialize the result list and current point
    local hull = {}
    local p = leftmost
    local q
    local counter = 0
    local maxIterations = n * n
    repeat
        -- Add the current point to the hull
        table.insert(hull, circles[p])

        -- Find the next point on the hull
        q = (p % n) + 1
        for i = 1, n do
            if circles[i].radius > 0 then
                local orientation = Tracks.Orientation(circles[p], circles[i], circles[q])
                if orientation == 2 or (orientation == 0 and circles[i].radius > Tracks.Distance(circles[p], circles[q]) / 2) then
                    q = i
                end
            end
        end

        p = q
        counter = counter + 1
        if counter >= maxIterations then
            break -- Break out of the loop
        end
    until p == leftmost

    return hull
end

function Tracks.GetStraights(hull)
    local straights = {}
    for i = 1, #hull do
        local circA = hull[i]
        local circB = hull[i % #hull + 1]
        local straightVec = circB.pos - circA.pos
        local perp = -Vec2Perp(Vec2Normalize(straightVec))
        local newPosA = circA.pos + perp * circA.radius
        local newPosB = circB.pos + perp * circB.radius
        local straight = TrackStraight(newPosA, newPosB)
        table.insert(straights, straight)
        SpawnLine(straight.a, straight.b, {r = 255, g = 255, b = 255, a = 255}, 0.04)
    end
    return straights
end