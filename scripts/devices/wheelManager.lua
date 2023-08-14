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

