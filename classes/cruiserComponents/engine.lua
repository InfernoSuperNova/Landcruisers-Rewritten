

EngineMetaTable = {
    framesSinceCreation = 0,
    deviceId = 0,
    nodeIdA = 0, --platform node
    nodeidB = 0, --platform node
    teamId = 0,
    structureId = 0,
    saveName = "",

    -- devicePos = Vec3(0,0),
    -- nodePosA = Vec3(0,0,0),
    -- nodePosB = Vec3(0,0,0),
    -- nodeVelA = Vec3(0,0,0),
    -- nodeVelB = Vec3(0,0,0),
    type = DefaultEngineDefinition
}




function Engine(deviceid, teamId)
    return EngineMetaTable:new(deviceid, teamId)
end

function EngineMetaTable:new(deviceId, teamId)
    local o = {}
    setmetatable(o, self)
    self.__index = self
    o.framesSinceCreation = 0
    o.deviceId = deviceId
    o.nodeIdA = GetDevicePlatformA(deviceId)
    o.nodeIdB = GetDevicePlatformB(deviceId)
    o.teamId = teamId
    o.structureId = GetDeviceStructureId(deviceId)
    o.saveName = GetDeviceType(deviceId)

   
    o.type = EngineDefinitionHelpers.GetEngineDefinitionBySaveName(o.saveName)
    if not o.type then return nil end
    return o
end

function EngineMetaTable:Update()
    self.framesSinceCreation = self.framesSinceCreation + 1
    

    local newId = GetDeviceStructureId(self.deviceId)
    --this is bad
    if self.structureId ~= newId then
        self.structureId = newId
    end
end