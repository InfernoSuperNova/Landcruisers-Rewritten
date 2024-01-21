--classes/wheel.lua

WheelMetaTable = {
    framesSinceCreation = 0,
    deviceId = 0,
    nodeIdA = 0, --platform node
    nodeIdB = 0, --platform node
    linkPos = 0,
    teamId = 0,
    structureId = 0,
    saveName = "",
    onGround = false,

    devicePos = Vec3(0,0),
    nodePosA = Vec3(0,0,0),
    nodePosB = Vec3(0,0,0),
    nodeVelA = Vec3(0,0,0),
    nodeVelB = Vec3(0,0,0),
    actualPos = Vec3(0,0,0),
    displacedPos = Vec3(0,0,0),
    blockCollisionCandidates = {},
    previousDisplacedPos = Vec3(0,0,0),
    velocityVector = Vec3(0,0,0),
    velocity = 0,
    angularVelocity = 0,
    rotation = 0,
    previousRotation = 0,
    direction = 0,
    groundVector = Vec3(0,0,0),
    groundFactor = 0,
    type = DefaultWheelDefinition,
    soundEffect = 0,
    shouldUpdate = true,
}

function Wheel(deviceid, teamId)
    return WheelMetaTable:new(deviceid, teamId)
end
function WheelMetaTable:new(deviceId, teamId)
    local o = {}
    setmetatable(o, self)
    self.__index = self
    o.framesSinceCreation = 0
    o.deviceId = deviceId
    o.teamId = teamId
    if deviceId and teamId then
        o.nodeIdA = GetDevicePlatformA(deviceId)
        o.nodeIdB = GetDevicePlatformB(deviceId)
        o.linkPos = GetDeviceLinkPosition(deviceId)
        o.structureId = GetDeviceStructureId(deviceId)
        o.saveName = GetDeviceType(deviceId)
        o.devicePos = GetDevicePosition(deviceId)
        o.nodePosA = NodePosition(o.nodeIdA)
        o.nodePosB = NodePosition(o.nodeIdB)
        o.type = WheelDefinitionHelpers.GetWheelDefinitionBySaveName(o.saveName)
    end
    
    o.onGround = false
    o.actualPos = o.devicePos
    o.displacedPos = o.devicePos
    o.blockCollisionCandidates = {}
    o.previousDisplacedPos = o.devicePos
    o.velocity = 0
    o.velocityVector = Vec3(0,0,0)
    o.angularVelocity = 0
    o.rotation = 0
    o.previousRotation = 0
    o.direction = 0
    o.groundVector = Vec3(0,0,0)
    o.groundFactor = 0
    o.soundEffect = 0
    o.shouldUpdate = true
    if not o.type and deviceId then return nil end
    
    return o
end



function WheelMetaTable:Update()
    if not self.shouldUpdate then return end
    self.framesSinceCreation = self.framesSinceCreation + 1
    self.previousDisplacedPos = DeepCopy(self.displacedPos)
    --self.devicePos = GetDevicePosition(self.deviceId)
    self.nodePosA = NodePosition(self.nodeIdA)
    self.nodePosB = NodePosition(self.nodeIdB)
    self.devicePos = Vec3Lerp(self.nodePosA, self.nodePosB, self.linkPos)
    self.nodeVelA = NodeVelocity(self.nodeIdA)
    self.nodeVelB = NodeVelocity(self.nodeIdB)
    
    local platformVector = Vec2Normalize(self.nodePosB - self.nodePosA)
    local platformPerp = Vec2Perp(platformVector)
    local platformOffset = self.type:GetHeight() * platformPerp
    self.actualPos = self.devicePos + platformOffset
    self.displacedPos = self.actualPos
    self.blockCollisionCandidates = {}
    local newId = GetDeviceStructureId(self.deviceId)
    --this is bad
    if self.structureId ~= newId then
        TrackManager.RemoveWheel(self)
        self.structureId = newId
        TrackManager.AddWheel(self)
    end
    self:UpdateAngularVelocity()
end

function WheelMetaTable:UpdateAngularVelocity()
    local vehicleForce = Vec3(0,0,0)
    if self.onGround then
        local normalGroundVector = Vec2Perp(self.groundVector)
        local perpendicularPlatformVector = Vec2Perp(self.nodePosB - self.nodePosA)

        --multiply by sign of dot product of velocity and ground vector to get direction
        local velocitySign = math.sign(Vec2Dot(self.velocityVector, normalGroundVector))
        --multiply by sign of dot product of wheel up vector and ground vector perp to get direction
        local upSign = math.sign(Vec2Dot(perpendicularPlatformVector, self.groundVector))
        local invertedSign = 1
        if self.type:GetIsInverted() then
            invertedSign = -1
        end
        local vehicleVelocity = self.velocity * velocitySign * upSign * invertedSign * -1
        local wheelVelocity = self.angularVelocity * DegToRad * self.type:GetRadius()
        local delta = vehicleVelocity - wheelVelocity

         --divide by radius and multiply by radtodeg to get angular velocity
        local wheelGain = (self.type:GetTraction() * self.groundFactor) / self.type:GetMass()  --more mass means more time to make a change
        local vehicleGain = (self.type:GetTraction() * self.groundFactor) * 150 * velocitySign

        self.angularVelocity = self.angularVelocity + (delta * wheelGain) * RadToDeg / self.type:GetRadius()
        --As well as slowing down the wheel, we should apply a force to the vehicle to speed it up to meet the wheel

        vehicleForce = vehicleGain * delta * Vec3Normalize(self.velocityVector)
        
        
        self.onGround = false
    end
    self:ApplyForce(vehicleForce)
    --For animation
    self.previousRotation = self.rotation
    
    --Energy loss through friction over time
    local angularVelocitySign = math.sign(self.angularVelocity)
    self.angularVelocity = math.max(0, math.abs(self.angularVelocity) - self.type:GetBearingEnergyLoss()) * angularVelocitySign
    self.rotation = self.rotation + math.abs(self.angularVelocity) % 360 * math.sign(self.angularVelocity)
end

function WheelMetaTable:UpdateTeam(teamId)
    self.teamId = teamId
end

function WheelMetaTable:UpdateStructure(structureId)
    self.structureId = structureId
end

function WheelMetaTable:RefreshNodes()
    self.nodeIdA = GetDevicePlatformA(self.deviceId)
    self.nodeIdB = GetDevicePlatformB(self.deviceId)
end

function WheelMetaTable:UpdateNodes(nodeId, nodeIdNew) 
    --we cannot use nodeIdNew because we don't know for certain if it is the new node
    if self.nodeIdA == nodeId then
        self.nodeIdA = GetDevicePlatformA(self.deviceId)
        self.nodeVelA = NodeVelocity(nodeIdNew)
    end
    if self.nodeIdB == nodeId then
        self.nodeIdB = GetDevicePlatformB(self.deviceId)
        self.nodeVelB = NodeVelocity(nodeIdNew)
    end
end
function WheelMetaTable:ApplyForce(force)
    ApplyForce(self.nodeIdA, force)
    ApplyForce(self.nodeIdB, force)
end

function WheelMetaTable:GetPos()
    return self.actualPos
end
function WheelMetaTable:GetNodeVelA()
    return self.nodeVelA
end
function WheelMetaTable:GetNodeVelB()
    return self.nodeVelB
end
function WheelMetaTable:GetNodeVels()
    return (self.nodeVelA + self.nodeVelB) / 2
end
function WheelMetaTable:SetDisplacedPos(displacedPos)
    self.displacedPos = displacedPos
end

function WheelMetaTable:AddBlockCollisionCandidate(displacedPos, segmentNormal, intersectionValue, force)

    local blockCollisionCandidate = {
        displacedPos = displacedPos,
        segmentNormal = segmentNormal,
        intersectionValue = intersectionValue,
        force = force
    }
    table.insert(self.blockCollisionCandidates, blockCollisionCandidate)
end

function WheelMetaTable:GetBlockCollisionCandidates()
    return self.blockCollisionCandidates
end

function WheelMetaTable:CalculateVelocity()
    if self.previousDisplacedPos == Vec3(0,0,0) then return end
    self.velocityVector = self.displacedPos - self.previousDisplacedPos
    --why don't I just use node velocity?
    self.velocity = Vec2Mag(self.velocityVector)
end
function WheelMetaTable:GetDisplacedPos()
    return self.displacedPos
end
function WheelMetaTable:SetOnGround(onGround)
    self.onGround = onGround
end

function WheelMetaTable:GetPreviousPos()
    return self.previousDisplacedPos
end
function WheelMetaTable:GetVelocityVector()
    return self.velocityVector
end
function WheelMetaTable:GetPreviousRotation()
    return self.previousRotation
end
function WheelMetaTable:GetDeviceId()
    return self.deviceId
end

function WheelMetaTable:GetSprocketSprite()
    return self.type.sprocketSprite
end

function WheelMetaTable:GetRotation()
    return self.rotation
end

function WheelMetaTable:SetGroundVector(groundVector)
    self.groundVector = groundVector
end

function WheelMetaTable:SetInGroundFactor(groundFactor)
    self.groundFactor = groundFactor / self.type:GetRadius() + 0.5
end



--WHEEL TYPES


--Wheel statistics, eg small medium large
WheelDefinition = {
    radius = 0,
    height = 0,
    dampening = 0,
    spring = 0,
    traction = 0,
    bearingEnergyLoss = 0,
    mass = 0,
    sprocketSprite = "",
    wheelSprite = "",
    saveName = "",
    isInverted = false,
}

--Constructor
function WheelDefinition:new(radius, height, dampening, spring, traction, bearingEnergyLoss, mass, saveName, sprocketSprite, wheelSprite, isInverted)
    local o = {}
    setmetatable(o, self)
    self.__index = self

    o.radius = radius
    o.height = height
    o.dampening = dampening
    o.spring = spring
    o.traction = traction
    o.bearingEnergyLoss = bearingEnergyLoss
    o.mass = mass
    o.saveName = saveName
    o.sprocketSprite = sprocketSprite
    o.wheelSprite = wheelSprite
    o.isInverted = isInverted
    return o
end
--Getters
function WheelDefinition:GetRadius()
    return self.radius
end

function WheelDefinition:GetHeight()
    return self.height
end

function WheelDefinition:GetDampening()
    return self.dampening
end

function WheelDefinition:GetSpring()
    return self.spring
end

function WheelDefinition:GetTraction()
    return self.traction
end

function WheelDefinition:GetBearingEnergyLoss()
    return self.bearingEnergyLoss
end

function WheelDefinition:GetMass()
    return self.mass
end

function WheelDefinition:GetSaveName()
    return self.saveName
end

function WheelDefinition:GetIsInverted()
    return self.isInverted
end




