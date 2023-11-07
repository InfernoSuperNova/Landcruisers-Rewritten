--scripts/debug/highlighting.lua

Highlighting = {}
function Highlighting.HighlightCoords(coords)
    for k, coord in pairs(coords) do
        SpawnCircle(coord, 50, { r = 255, g = 100, b = 100, a = 255 }, data.updateDelta)
    end
end

function Highlighting.HighlightPolygon(coords, colour1)
    if not colour1 then colour1 = {r = 255, g = 255, b = 255, a = 255} end
    local newCoords = Highlighting.FlattenTable(coords)
    for coord = 1, Highlighting.GetHighestIndex(newCoords) do
        --SpawnCircle(coords[coord], 50, colour1, data.updateDelta)
        newCoords[coord].z = -100
        newCoords[coord % #newCoords + 1].z = -100
        SpawnLine(newCoords[coord], newCoords[coord % #newCoords + 1], colour1, data.updateDelta)
    end
end

function Highlighting.HighlightPolygonWithDisplacement(coords, displacement, colour1)
    local newCoords = {}
    for index = 1, Highlighting.GetHighestIndex(coords) do
        local coord = coords[index]
        if coord and coord.x then
            newCoords[index] = {x = coord.x + displacement.x, y = coord.y + displacement.y}
        end
    end
    Highlighting.HighlightPolygon(newCoords, colour1)
end
--I'm pretty sure this isn't what FlattenTable means. But screw you.
function Highlighting.FlattenTable(tbl) 
    local newTable = {}
    for i = 1, Highlighting.GetHighestIndex(tbl) do
        table.insert(newTable, tbl[i])
    end
    return newTable
end

function Highlighting.HighlightUnitVector(pos, direction, mag, col)
    pos.z = -100
    col = col or {r = 255, g = 255, b= 255, a = 255}
    local pos2 = Vec3( pos.x + direction.x * mag, pos.y + direction.y * mag, -100)
    SpawnLine(pos, pos2, col, 0.04)
    SpawnCircle(pos, Vec3Dist(pos, pos2) / 5, col, 0.04)
end

function Highlighting.GetHighestIndex(tbl)
    local highest = 0
    for k, v in pairs(tbl) do
        if k > highest then
            highest = k
        end
    end
    return highest
end

function Highlighting.HighlightLineWithWidth(p1, p2, width, colour)
    local dirVector = p2 - p1
    local perpVector = Vec2Perp(Vec3Normalize(dirVector)) * width

    local boxPosA = p1 + perpVector
    local boxPosB = p2 + perpVector
    local boxPosC = p2 - perpVector
    local boxPosD = p1 - perpVector
    local coords = {boxPosA, boxPosB, boxPosC, boxPosD}
    Highlighting.HighlightPolygon(coords,colour)
end