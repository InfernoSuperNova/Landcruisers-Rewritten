Polygon = {}

function Polygon.GetIntersecting(shapeA, shapeB)
    for i = 1, #shapeA do
        for j = 1, #shapeB do
            local p1 = shapeA[i]
            local q1 = shapeA[i % #shapeA + 1]
            local p2 = shapeB[j]
            local q2 = shapeB[j % #shapeB + 1]
            if Line.DoIntersect(p1, q1, p2, q2) then
                return true
            end
        end
    end
    return false
end

function Polygon.GetIntersectingEdges(shapeA, shapeB)
    local hasIntersect = false
    local EdgesShapeA = {}
    local EdgesShapeB = {}

    local intersectPointsShapeB = {} -- Store the intersecting points for each point of shape B
    for i = 1, #shapeA do -- loop through all points on shape 1...
        --BetterLog("Shape A node " .. i .. " of " .. #shapeA)
        local p1 = shapeA[i] -- ...and get the current point and the next point
        local q1 = shapeA[i % #shapeA + 1]
        local intersectPoints = {} -- Store the intersecting edges stemming from p1
        table.insert(intersectPoints, q1)

        for j = 1, #shapeB do -- loop through all points on shape 2...
            --BetterLog("Shape B node " .. j .. " of " .. #shapeB)
            local p2 = shapeB[j] -- ...and get the current point and the next point
            local q2 = shapeB[j % #shapeB + 1]

            if Line.DoIntersect(p1, q1, p2, q2) then
                --BetterLog("intersect between " .. i .. " and " .. j .. "")
                hasIntersect = true
                local intersectPoint = Line.IntersectPoint(p1, q1, p2, q2)
                
                table.insert(intersectPoints, intersectPoint)

                if not intersectPointsShapeB[j] then -- if we haven't seen this point before, create a table for it
                    intersectPointsShapeB[j] = {}
                end
                table.insert(intersectPointsShapeB[j], intersectPoint)
            end
        end

        -- sort intersecting points by distance to p1
        table.sort(intersectPoints, function (a, b) return Vec3SquareDistance(p1, a) < Vec3SquareDistance(p1, b) end)


        local newEdge2 = {current = shapeA[i], next = intersectPoints[1]}
        table.insert(EdgesShapeA, newEdge2)
        -- construct edges between each intersecting point
        for j = 1, #intersectPoints - 1 do
            local newEdge = {current = intersectPoints[j], next = intersectPoints[j % #intersectPoints + 1]}
            table.insert(EdgesShapeA, newEdge) -- add the edge to the list of edges
        end 
    end

    for point = 1, #shapeB do

        if not intersectPointsShapeB[point] then 
            intersectPointsShapeB[point] = {}
        end
        table.insert(intersectPointsShapeB[point], shapeB[point % #shapeB + 1]) --add the next point to the list of intersecting points

        local intersectPoints = intersectPointsShapeB[point]
        table.sort(intersectPoints, function (a, b) return Vec3SquareDistance(shapeB[point], a) < Vec3SquareDistance(shapeB[point], b) end)
        
        local newEdge2 = {current = shapeB[point], next = intersectPoints[1]}
        table.insert(EdgesShapeB, newEdge2)
        for j = 1, #intersectPoints - 1 do
            local newEdge = {current = intersectPoints[j], next = intersectPoints[j % #intersectPoints + 1]}
            table.insert(EdgesShapeB, newEdge) -- add the edge to the list of edges
        end 
    end

    --BetterLog(EdgesShapeB)
    return {EdgesShapeA, EdgesShapeB, hasIntersect = hasIntersect}
end

function Polygon.GetIntersectingPoints(shapeA, shapeB)
    local intersectingEdges = Polygon.GetIntersectingEdges(shapeA, shapeB)

    local newShapeA = {}
    local newShapeB = {}

    for _, edge in pairs(intersectingEdges[1]) do
        table.insert(newShapeA, edge[1])
    end
    for _, edge in pairs(intersectingEdges[2]) do
        table.insert(newShapeB, edge[1])
    end

    return {newShapeA, newShapeB, hasIntersect = intersectingEdges.hasIntersect}
end

function Polygon.GetIndexOfMinimumPoint(shape)
    local minX = math.huge
    local minY = math.huge
    for _, point in pairs(shape) do
        if point.x < minX then
            minX = point.x
        end
        if point.y < minY then
            minY = point.y
        end
    end
    local squareBottomLeft = Vec3(minX, minY)
    local minSquareDistance = math.huge
    local minPoint = 0

    for index, point in pairs(shape) do
        local squareDistance = Vec3SquareDistance(squareBottomLeft, point)

        if squareDistance < minSquareDistance then
            minSquareDistance = squareDistance
            minPoint = index
        end
    end
    return minPoint
end
function Polygon.GetMinimumPointOfShapes(shape1, shape2)
    local minX = math.huge
    local minY = math.huge
    for _, point in pairs(shape1) do

        if point.x < minX then
            minX = point.x
        end
        if point.y < minY then
            minY = point.y
        end
    end
    for _, point in pairs(shape2) do
        if point.x < minX then
            minX = point.x
        end
        if point.y < minY then
            minY = point.y
        end
    end

    local squareBottomLeft = Vec3(minX, minY)
    local minSquareDistance = math.huge
    local minPoint = Vec3(0,0,0)

    for index, point in pairs(shape1) do
        local squareDistance = Vec3SquareDistance(squareBottomLeft, point)
        squareDistance = squareDistance * squareDistance

        if squareDistance < minSquareDistance then
            minSquareDistance = squareDistance
            minPoint = point
        end
    end
    for index, point in pairs(shape2) do
        local squareDistance = Vec3SquareDistance(squareBottomLeft, point)
        squareDistance = squareDistance * squareDistance

        if squareDistance < minSquareDistance then
            minSquareDistance = squareDistance
            minPoint = point
        end
    end
    return minPoint
end
function Polygon.ConstructUnionContour(shapeA, shapeB, firstPoint)
    local newShape = {}
    table.insert(newShape, firstPoint)
    local currentPoint = firstPoint

    local safetyCheck = 0
    repeat
        table.insert(newShape, currentPoint)
        local shapeAPointIndex = Polygon.GetShapeContainsPoint(shapeA, currentPoint)
        local shapeBPointIndex = Polygon.GetShapeContainsPoint(shapeB, currentPoint)

        if shapeAPointIndex ~= 0 and shapeBPointIndex ~= 0 then
            if IsConcave(shapeA[shapeAPointIndex].next, currentPoint, shapeB[shapeBPointIndex].next) then
                currentPoint = shapeA[shapeAPointIndex].next
            else
                currentPoint = shapeB[shapeBPointIndex].next
            end
            
        elseif shapeAPointIndex ~= 0 then
            currentPoint = shapeA[shapeAPointIndex].next
        else
            currentPoint = shapeB[shapeBPointIndex].next
        end

        if currentPoint == firstPoint then
            break
        end
        if safetyCheck > #shapeA * 2 + #shapeB * 2 then -- bad if we loop forever
            BetterLog("Error: exceeded maximum iteration count in Polygon.ConstructUnionContour.")
            break
        end
        safetyCheck = safetyCheck + 1
    until false

    return newShape
end


function Polygon.GetShapeContainsPoint(shape, point)
    for index, edge in pairs(shape) do
        if edge.current == point and edge.current ~= edge.next then
            return index
        end
    end
    return 0
end


function Polygon.GetIndexOfEdgeContainingPoint(shape, point)
    for index, edge in pairs(shape) do
        if edge[1] == point then
            return index
        end
    end
    return 0
end

function Polygon.Union(shapeA, shapeB)
    local edges = Polygon.GetIntersectingEdges(shapeA, shapeB)
    local firstPoint = Polygon.GetMinimumPointOfShapes(shapeA, shapeB)
    local newShape = Polygon.ConstructUnionContour(edges[1], edges[2], firstPoint)
    return newShape
end