

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
    type = DefaultEngineDefinition,
    soundEffect = 0,
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
    o.soundEffect = 0
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

function EngineMetaTable:UpdateTeam(teamId)
    self.teamId = teamId
end

function EngineMetaTable:UpdateStructure(structureId)
    self.structureId = structureId
end

function EngineMetaTable:GetDeviceId()
    return self.deviceId
end




EngineDefinition = {
    Torque = 0,
    SoundEvent = ""

}

--Constructor
function EngineDefinition:new(Torque, SoundEvent)
    local o = {}
    setmetatable(o, self)
    self.__index = self

    o.Torque = Torque
    o.SoundEvent = SoundEvent
    return o
end