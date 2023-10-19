--classes/wheel.lua

WheelMetaTable = {
    deviceId = 0,
    nodeIdA = 0, --platform node
    nodeidB = 0, --platform node
    teamId = 0,
    structureId = 0,
    saveName = "",

    devicePos = Vec3(0,0),
    nodePosA = Vec3(0,0,0),
    nodePosB = Vec3(0,0,0),
    nodeVelA = Vec3(0,0,0),
    nodeVelB = Vec3(0,0,0),
    actualPos = Vec3(0,0,0),
    displacedPos = Vec3(0,0,0),
    previousPos = Vec3(0,0,0),
    angularVelocity = 0,
    type = DefaultWheelDefinition
}

function Wheel(deviceid, teamId)
    return WheelMetaTable:new(deviceid, teamId)
end
function WheelMetaTable:new(deviceId, teamId)
    local o = {}
    setmetatable(o, self)
    self.__index = self

    o.deviceId = deviceId
    o.nodeIdA = GetDevicePlatformA(deviceId)
    o.nodeIdB = GetDevicePlatformB(deviceId)
    o.teamId = teamId
    o.structureId = GetDeviceStructureId(deviceId)
    o.saveName = GetDeviceType(deviceId)
    
    o.devicePos = GetDevicePosition(deviceId)
    o.nodePosA = NodePosition(o.nodeIdA)
    o.nodePosB = NodePosition(o.nodeIdB)
    o.actualPos = Vec3(0,0)
    o.previousPos = Vec3(0,0)
    o.angularVelocity = 0
    o.type = WheelDefinitionHelpers.GetWheelDefinitionBySaveName(o.saveName)
    if not o.type then return nil end
    return o
end



function WheelMetaTable:Update()
    self.previousPos = DeepCopy(self.displacedPos)
    self.devicePos = GetDevicePosition(self.deviceId)
    self.nodePosA = NodePosition(self.nodeIdA)
    self.nodePosB = NodePosition(self.nodeIdB)
    self.nodeVelA = NodeVelocity(self.nodeIdA)
    self.nodeVelB = NodeVelocity(self.nodeIdB)
    
    local platformVector = Vec2Normalize(self.nodePosB - self.nodePosA)
    local platformPerp = Vec2Perp(platformVector)
    local platformOffset = self.type:GetHeight() * platformPerp
    self.actualPos = self.devicePos + platformOffset
    self.displacedPos = self.actualPos

    local newId = GetDeviceStructureId(self.deviceId)
    --this is bad
    if self.structureId ~= newId then
        TrackManager.RemoveWheel(self)
        self.structureId = newId
        TrackManager.AddWheel(self)
    end

    local velocity = 
end

function WheelMetaTable:UpdateTeam(teamId)
    self.teamId = teamId
end

function WheelMetaTable:UpdateStructure(structureId)
    self.structureId = structureId
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
function WheelMetaTable:SetDisplacedPos(displacedPos)
    self.displacedPos = displacedPos
end

function WheelMetaTable:GetDisplacedPos()
    return self.displacedPos
end

function WheelMetaTable:GetPreviousPos()
    return self.previousPos
end
function WheelMetaTable:GetDeviceId()
    return self.deviceId
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
}

--Constructor
function WheelDefinition:new(radius, height, dampening, spring, traction, bearingEnergyLoss, mass, saveName, sprocketSprite, wheelSprite)
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

function WheelDefinition:DeepCopy()
    return WheelDefinition:new(self.radius, self.height, self.dampening, self.spring, self.saveName, self.sprocketSprite, self.wheelSprite)
end


