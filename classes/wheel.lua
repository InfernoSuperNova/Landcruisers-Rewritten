WheelMetatable = {
    deviceId = 0,
    nodeIdA = 0, --platform node
    nodeidB = 0, --platform node
    teamId = 0,
    structureId = 0,

    saveName = "",

    devicePos = Vec3(0,0),
    nodePosA = Vec3(0,0,0),
    nodePosB = Vec3(0,0,0),
    actualPos = Vec3(0,0,0),
    type = DefaultWheelDefinition
}

function Wheel(deviceid, teamId)
    return WheelMetatable:new(deviceid, teamId)
end
function WheelMetatable:new(deviceId, teamId)
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
    o.type = WheelDefinitionHelpers.GetWheelDefinitionBySaveName(o.saveName)
    if not o.type then return nil end
    return o
end



function WheelMetatable:Update()
    self.devicePos = GetDevicePosition(self.deviceId)
    self.nodePosA = NodePosition(self.nodeIdA)
    self.nodePosB = NodePosition(self.nodeIdB)
    local platformVector = Vec2Normalize(self.nodePosB - self.nodePosA)
    local platformPerp = Vec2Perp(platformVector)
    local platformOffset = self.type:GetHeight() * platformPerp
    self.actualPos = self.devicePos + platformOffset
    
end

function WheelMetatable:UpdateTeam(teamId)
    self.teamId = teamId
end

function WheelMetatable:UpdateStructure(structureId)
    self.structureId = structureId
end


function WheelMetatable:GetPos()
    return self.actualPos
end
--Wheel statistics, eg small medium large
WheelDefinition = {
    radius = 0,
    height = 0,
    dampening = 0,
    spring = 0,
    sprocketSprite = "",
    wheelSprite = "",
    saveName = "",

    
}


function WheelDefinition:new(radius, height, dampening, spring, saveName, sprocketSprite, wheelSprite)
    local o = {}
    setmetatable(o, self)
    self.__index = self

    o.radius = radius
    o.height = height
    o.dampening = dampening
    o.spring = spring
    o.saveName = saveName
    o.sprocketSprite = sprocketSprite
    o.wheelSprite = wheelSprite

    return o
end

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

function WheelDefinition:GetSaveName()
    return self.saveName
end

function WheelDefinition:DeepCopy()
    return WheelDefinition:new(self.radius, self.height, self.dampening, self.spring, self.saveName, self.sprocketSprite, self.wheelSprite)
end


