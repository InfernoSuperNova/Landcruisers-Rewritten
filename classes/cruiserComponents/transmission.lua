

TransmissionMetaTable = {
    framesSinceCreation = 0,
    deviceId = 0,
    nodeIdA = 0, --platform node
    nodeidB = 0, --platform node
    teamId = 0,
    structureId = 0,
    saveName = "",
    soundEffect = 0,

    -- devicePos = Vec3(0,0),
    -- nodePosA = Vec3(0,0,0),
    -- nodePosB = Vec3(0,0,0),
    -- nodeVelA = Vec3(0,0,0),
    -- nodeVelB = Vec3(0,0,0),
    type = DefaultTransmissionDefinition
}

function Transmission(deviceid, teamId)
    return TransmissionMetaTable:new(deviceid, teamId)
end


function TransmissionMetaTable:new(deviceId, teamId)
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
    o.soundEffect = 0
   
    o.type = TransmissionDefinitionHelpers.GetTransmissionDefinitionBySaveName(o.saveName)
    if not o.type then return nil end
    return o
end

function TransmissionMetaTable:Update()
    self.framesSinceCreation = self.framesSinceCreation + 1
    

    local newId = GetDeviceStructureId(self.deviceId)
    --this is bad
    if self.structureId ~= newId then
        self.structureId = newId
    end
end

function TransmissionMetaTable:UpdateTeam(teamId)
    self.teamId = teamId
end

function TransmissionMetaTable:UpdateStructure(structureId)
    self.structureId = structureId
end

function TransmissionMetaTable:GetDeviceId()
    return self.deviceId
end


TransmissionDefinition = {
    GearRatio = 0,
    SwitchSpeed = 0,
    EnergyLoss = 0,
    SoundEvent = ""
}

--Constructor
function TransmissionDefinition:new(GearRatio, SwitchSpeed, EnergyLoss, SoundEvent)
    local o = {}
    setmetatable(o, self)
    self.__index = self

    o.GearRatio = GearRatio
    o.SwitchSpeed = SwitchSpeed
    o.EnergyLoss = EnergyLoss
    o.SoundEvent = SoundEvent
    return o
end