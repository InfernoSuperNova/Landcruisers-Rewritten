--scripts/wheels/wheelManager.lua

WheelManager = {}
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
end

--Get the collider for a given set of wheels
function WheelManager.GetWheelCollider(wheelGroup)
    local wheelGroupBoundary = MinimumWheelCircularBoundary(wheelGroup)
    wheelGroupBoundary.r = wheelGroupBoundary.r + LargestWheelRadius
    if ModDebug.collisions then
        SpawnCircle(wheelGroupBoundary, wheelGroupBoundary.r, Red(), 0.04)
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
                SpawnLine(wheelPos, segmentCollider, {r = 255, g = 128, b = 0, a = 255}, 0.04)
            end
            WheelManager.CheckWheelOnSegment(wheel, segment)
        end
    end
end

--Final step: Check individual wheels on segments
function WheelManager.CheckWheelOnSegment(wheel, segment)
    local wheelPos = wheel:GetPos()
    local wheelToSegment = segment.nodeA - wheelPos
    local distance = Vec2Dot(wheelToSegment, segment.segmentNormal)
    local radius = wheel.type:GetRadius()
    --remove this check to enable sticky wheels or set radius to *2
    if math.abs(distance) > radius then
        return
    end
    wheel:SetOnGround(true)
    local intersectionValue = (radius - distance)
    local segment1ToWheel = wheelPos - segment.nodeA
    local segment2ToWheel = wheelPos - segment.nodeB
    if Vec2Cross(segment1ToWheel, segment.prevSegmentBoundary) > 0 or
        Vec2Cross(segment2ToWheel, segment.nextSegmentBoundary) < 0 then
        return
    end
    WheelManager.CalculateResponseForce(intersectionValue, segment.segmentNormal, wheel, wheelPos)
    if ModDebug.collisions then
        Highlighting.HighlightUnitVector(segment.nodeA, segment.prevSegmentBoundary, 500, Green())
        Highlighting.HighlightUnitVector(segment.nodeB, segment.nextSegmentBoundary, 500, Green())
        SpawnLine(wheelPos, segment.nodeA, { r = 255, g = 128, b = 0, a = 100 }, 0.04)
        SpawnLine(wheelPos, segment.nodeB, { r = 255, g = 128, b = 0, a = 100 }, 0.04)
    end
end


function WheelManager.CalculateResponseForce(intersectionValue, segmentNormal, wheel, wheelPos)
    local displacement = intersectionValue * -1 * segmentNormal
    wheel:SetDisplacedPos(wheelPos + displacement)
    wheel:SetGroundVector(segmentNormal)
    wheel:SetInGroundFactor(intersectionValue)
    wheel:CalculateVelocity()
    local velocity = (wheel:GetNodeVelA() + wheel:GetNodeVelB()) / 2
    local force = Dampening.DirectionalDampening(wheel.type.spring, displacement, wheel.type.dampening, velocity, segmentNormal)
    wheel:ApplyForce(force)
end


--function CalculateFrictionForce
