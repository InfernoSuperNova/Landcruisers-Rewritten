WheelManager = {}

function WheelManager.Update(frame)
    --Group wheels by structureId
    local wheelStructureGroups = {}
    for _, wheel in ipairs(data.wheels) do
        if wheelStructureGroups[wheel.structureId] == nil then
            wheelStructureGroups[wheel.structureId] = {}
        end
        table.insert(wheelStructureGroups[wheel.structureId], wheel)
    end
    for _, wheelGroup in pairs(wheelStructureGroups) do
        local wheelCollider = WheelManager.GetWheelCollider(wheelGroup)
        local collidingBlocks = WheelManager.CheckWheelGroupCollisions(wheelCollider)
        
        for _, block in pairs(collidingBlocks) do
            WheelManager.CheckWheelGroupOnSegmentColliders(wheelGroup, wheelCollider, block)
        end
        
    end
end

function WheelManager.GetWheelCollider(wheelGroup)
    local wheelGroupBoundary = MinimumWheelCircularBoundary(wheelGroup)
    wheelGroupBoundary.r = wheelGroupBoundary.r + LargestWheelRadius
    if ModDebug.collisions then
        SpawnCircle(wheelGroupBoundary, wheelGroupBoundary.r, Red(), 0.04)
    end
    return wheelGroupBoundary
end

function WheelManager.CheckWheelGroupCollisions(wheelCollider)
    local colliding = {}
    for _, block in pairs(data.terrain) do
        local blockCollider = block:GetColliderPos()
        local blockRadius = block:GetColliderRadius()
        local colliderPos = Vec3(wheelCollider.x, wheelCollider.y)
        local distance = Vec2Mag(blockCollider - colliderPos)
        if distance < blockRadius + wheelCollider.r then
            table.insert(colliding, block)
        end
    end
    return colliding
end

function WheelManager.CheckWheelGroupOnSegmentColliders(wheelGroup, wheelCollider, block)
    local blockNodes = block:GetNodes()
    for index, nodePos in pairs(blockNodes) do
        local nodeA = nodePos
        local nodeB = blockNodes[index + 1 % #blockNodes]
        local segment = {nodeA, nodeB}
        local nextSegmentEnd = blockNodes[index + 2 % #blockNodes]
        local prevSegmentStart = blockNodes[(index - 2) % #blockNodes + 1]
        

        local segmentCollider = MinimumCircularBoundary(segment)
        local segmentColliderPos = Vec3(segmentCollider.x, segmentCollider.y)
        local wheelColliderPos = Vec3(wheelCollider.x, wheelCollider.y)
        local distance = Vec3Dist(segmentColliderPos, wheelColliderPos)
        if distance < segmentCollider.r + wheelCollider.r then
            CheckWheelsOnSegmentCollider(wheelGroup, segmentCollider, segment, prevSegmentStart, nextSegmentEnd)
        end
        
    end
end

function CheckWheelsOnSegmentCollider(wheelGroup, segmentCollider, segment, prevSegmentStart, nextSegmentEnd)
    for _, wheel in pairs(wheelGroup) do
        local wheelPos = wheel:GetPos()
        local segmentColliderPos = Vec3(segmentCollider.x, segmentCollider.y)
        local distance = Vec3Dist(wheelPos, segmentColliderPos)
        
        if distance < segmentCollider.r + wheel.type:GetRadius() then
            if ModDebug.collisions then
                SpawnLine(wheelPos, segmentColliderPos, White(), 0.04)
            end
            CheckWheelOnSegment(wheel, segment, prevSegmentStart, nextSegmentEnd)
        end
    end
end

function CheckWheelOnSegment(wheel, segment, prevSegmentStart, nextSegmentEnd)
    local wheelPos = wheel:GetPos()
    local segmentStart = segment[1]
    local segmentEnd = segment[2]
    local segmentDir = segmentEnd - segmentStart
    local segmentNormal = Vec2Normalize(Vec2Perp(segmentDir))  -- Calculate the perpendicular vector
    local wheelToSegment = segmentStart - wheelPos
    local distance = Vec2Dot(wheelToSegment, segmentNormal)
    local radius = wheel.type:GetRadius()
    local terrainValue = 0


    local prevSegmentNormal = Vec2Normalize(Vec2Perp(segmentStart - prevSegmentStart))
    local nextSegmentNormal = Vec2Normalize(Vec2Perp(nextSegmentEnd - segmentEnd))
    local prevSegmentBoundary = -Vec2Average({prevSegmentNormal, segmentNormal})
    local nextSegmentBoundary = -Vec2Average({nextSegmentNormal, segmentNormal})
    local segment1ToWheel = wheelPos - segmentStart
    local segment2ToWheel = wheelPos - segmentEnd

    if ModDebug.collisions then
        Highlighting.HighlightDirectionalVector(segmentStart, prevSegmentBoundary, 500, Green())
        Highlighting.HighlightDirectionalVector(segmentEnd, nextSegmentBoundary, 500, Green())
    end
    if Vec2Cross(segment1ToWheel, prevSegmentBoundary) > 0 
    or Vec2Cross(segment2ToWheel, nextSegmentBoundary) < 0 
    then return end
    if distance > radius then
        return
    else
        terrainValue = (radius - distance)
    end
    
    -- if terrainValue == 0 then
    --     return
    -- end
    
    local displacement = terrainValue * -1 * segmentNormal
    wheel:SetDisplacedPos(wheelPos + displacement)
    local velA = wheel:GetNodeVelA()
    local velB = wheel:GetNodeVelB()
    local vel = Vec2Average({velA, velB})
    local force = {
        x = Dampening.SpringDampening(wheel.type.spring, displacement.x, wheel.type.dampening * math.abs(segmentNormal.x) ^ math.pi, vel.x ),
        y = Dampening.SpringDampening(wheel.type.spring, displacement.y, wheel.type.dampening * math.abs(segmentNormal.y) ^ math.pi, vel.y )
    }
    if ModDebug.collisions then
        SpawnCircle(wheelPos + displacement, radius, Red(), 0.04)
        Highlighting.HighlightDirectionalVector(wheelPos, force, 0.01, Red())
    end
    
    dlc2_ApplyForce(wheel.nodeIdA, force)
    dlc2_ApplyForce(wheel.nodeIdB, force)
end