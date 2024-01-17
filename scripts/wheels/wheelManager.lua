--scripts/wheels/wheelManager.lua

WheelManager = {
}
data.wheels = {}
function WheelManager.AddWheel(wheel)
    table.insert(data.wheels, wheel)
end
--Main wheel manager entrypoint, called every update frame
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


    --final step of collisions: Calculate forces
    for _, wheel in pairs(data.wheels) do
        WheelManager.DetermineBlockCollision(wheel)
    end
end

--Get the collider for a given set of wheels
function WheelManager.GetWheelCollider(wheelGroup)
    local wheelGroupBoundary = MinimumWheelCircularBoundary(wheelGroup)
    wheelGroupBoundary.r = wheelGroupBoundary.r + LargestWheelRadius
    if ModDebug.collisions then
        SpawnCircle(wheelGroupBoundary, wheelGroupBoundary.r, Red(), data.updateDelta * 1.2)
    end
    return wheelGroupBoundary
end

--First step: Check if the wheel group collider is colliding with the colliders around blocks
function WheelManager.CheckWheelGroupCollisions(wheelCollider)
    local colliding = {}
    for _, block in pairs(data.terrain) do
        local blockColliderPos = block:GetColliderPos()
        local blockRadius = block:GetColliderRadius()
        local wheelColliderPos = Vec3(wheelCollider.x, wheelCollider.y)
        if IsWithinDistance(blockColliderPos, wheelColliderPos, blockRadius + wheelCollider.r) then
            table.insert(colliding, block)
        end
    end
    return colliding
end


--Second step: Check if the wheel group collider is colliding with the colliders around individual segments on blocks
function WheelManager.CheckWheelGroupOnSegmentColliders(wheelGroup, wheelCollider, block)
    local blockNodes = block:GetNodes()
    local blockSegments = block:GetSegments()
    for index, nodePos in pairs(blockNodes) do
        local segment = blockSegments[index]
        local segmentCollider = MinimumCircularBoundary({segment.nodeA, segment.nodeB})
        if IsWithinDistance(segmentCollider, wheelCollider, segmentCollider.r + wheelCollider.r) then
            CheckWheelsOnSegmentCollider(wheelGroup, segmentCollider, segment)
        end
    end
end

--Third step: Check individual wheels on segment colliders
function CheckWheelsOnSegmentCollider(wheelGroup, segmentCollider, segment)
    for _, wheel in pairs(wheelGroup) do
        local wheelPos = wheel:GetPos()
        if IsWithinDistance(wheelPos, segmentCollider, segmentCollider.r + wheel.type:GetRadius()) then
            if ModDebug.collisions then
                wheelPos.z = -100
                segmentCollider.z = -100
            end
            WheelManager.CheckWheelOnSegment(wheel, segment)
        end
    end
end

--Final step: Check individual wheels on segments
function WheelManager.CheckWheelOnSegment(wheel, segment)
    local wheelPos = wheel:GetPos()
    
    
    local wheelToSegment = segment.nodeA - wheelPos
    local distanceToTerrainSegment = Vec2Dot(wheelToSegment, segment.segmentNormal)
    local radius = wheel.type:GetRadius()
    local intersectionValue = (radius - distanceToTerrainSegment)
    --If not touching terrain then return - remove this check to enable sticky wheels or set radius to *2
    if math.abs(distanceToTerrainSegment) > radius then
        return
    end 

    local segment1ToWheel = wheelPos - segment.nodeA
    local segment2ToWheel = wheelPos - segment.nodeB
    local distToSegmentStart = Vec2Cross(segment1ToWheel, segment.segmentNormal)
    local distToSegmentEnd = Vec2Cross(segment2ToWheel, segment.segmentNormal)


    if (distToSegmentStart < 0 and Vec2Cross(segment1ToWheel, segment.prevSegmentNormal) < 0) or (distToSegmentEnd > 0 and Vec2Cross(segment2ToWheel, segment.nextSegmentNormal) > 0) then
        return
    end

    if distToSegmentStart < 0 then
        wheel:SetOnGround(true)
        local wheelToNode = segment.nodeA - wheelPos
        WheelManager.CalculateResponseForceSimplified(wheelToNode, segment.segmentNormal, wheel)
        return
    end

    if distToSegmentEnd > 0 then
        wheel:SetOnGround(true)
        local wheelToNode = segment.nodeB - wheelPos
        WheelManager.CalculateResponseForceSimplified(wheelToNode, segment.segmentNormal, wheel)
        return
    end
    
    wheel:SetOnGround(true)
    WheelManager.CalculateResponseForce(intersectionValue, segment.segmentNormal, wheel)
    if ModDebug.collisions then
        Highlighting.HighlightUnitVector(segment.nodeA, -segment.segmentNormal, 500, Green())
        Highlighting.HighlightUnitVector(segment.nodeB, -segment.segmentNormal, 500, Green())
        wheelPos.z = -100
        segment.nodeA.z = -100
        segment.nodeB.z = -100
    end
end


function WheelManager.CalculateResponseForce(intersectionValue, segmentNormal, wheel)
    local displacement = intersectionValue * -1 * segmentNormal
    local displacedWheelPos = displacement + wheel:GetPos()
    -- wheel:SetDisplacedPos(displacedWheelPos)
    -- wheel:SetGroundVector(segmentNormal)
    -- wheel:SetInGroundFactor(intersectionValue)
    -- wheel:CalculateVelocity()
    local velocity = (wheel:GetNodeVelA() + wheel:GetNodeVelB()) / 2
    local force = Dampening.DirectionalDampening(wheel.type.spring, displacement, wheel.type.dampening, velocity, segmentNormal)
    -- wheel:ApplyForce(force)

    wheel:AddBlockCollisionCandidate(displacedWheelPos, segmentNormal, intersectionValue, force)
end



function WheelManager.CalculateResponseForceSimplified(wheelToNode, segmentNormal, wheel)

    
    local intersectionValue = wheel.type:GetRadius() - Vec2Mag(wheelToNode)
    local displacement = intersectionValue * -Vec2Normalize(wheelToNode)
    local displacedWheelPos = displacement + wheel:GetPos()
    
    -- wheel:SetDisplacedPos(displacedWheelPos)
    -- wheel:SetGroundVector(segmentNormal)
    -- wheel:SetInGroundFactor(intersectionValue)
    -- wheel:CalculateVelocity()
    local velocity = (wheel:GetNodeVelA() + wheel:GetNodeVelB()) / 2
    local force = Dampening.DirectionalDampening(wheel.type.spring, displacement, wheel.type.dampening, velocity, segmentNormal) / 2
    -- wheel:ApplyForce(force)
    
    wheel:AddBlockCollisionCandidate(displacedWheelPos, segmentNormal, intersectionValue, force)
end



function WheelManager.DetermineBlockCollision(wheel)
    local blockCandidates = wheel:GetBlockCollisionCandidates()
    local highestIntersectionValue = 0
    local highest = {}
    for _, blockCandidate in pairs(blockCandidates) do
        if blockCandidate.intersectionValue > highestIntersectionValue then
            highestIntersectionValue = blockCandidate.intersectionValue
            highest = blockCandidate
        end
    end
    if highestIntersectionValue == 0 then return end
    wheel:SetDisplacedPos(highest.displacedPos)
    wheel:SetGroundVector(highest.segmentNormal)
    wheel:SetInGroundFactor(highest.intersectionValue)
    wheel:CalculateVelocity()
    wheel:ApplyForce(highest.force)
end

--function CalculateFrictionForce




