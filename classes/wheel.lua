--Forts mod api
Wheel = {
    deviceId = 0,
    nodeIdA = 0, --platform node
    nodeidB = 0, --platform node
    teamId = 0,
    structureId = 0,

    saveName = "",

    devicePos = Vec3(0,0,0),
    nodePosA = Vec3(0,0,0),
    nodePosB = Vec3(0,0,0),
    actualPos = Vec3(0,0,0),
    
    type = WheelType,
}

function Wheel:new(deviceId, teamId)
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

    o.actualPos = Vec3(0,0,0) --to be added later

    return o
end

function Wheel:Update()
    self.devicePos = GetDevicePosition(self.deviceId)
    self.nodePosA = NodePosition(self.nodeIdA)
    self.nodePosB = NodePosition(self.nodeIdB)
end

function Wheel:UpdateTeam(teamId)
    self.teamId = teamId
end

function Wheel:UpdateStructure(structureId)
    self.structureId = structureId
end

function Wheel:CalculateActualPos()

end

--Wheel statistics, eg small medium large
WheelType = {
    radius = 0,
    height = 0,
    dampening = 0,
    spring = 0,
}
