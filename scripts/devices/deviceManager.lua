

DeviceManager = {


}

function DeviceManager.Load()
    DeviceManager.IndexAtLoad()
end
function DeviceManager.Update(frame)
    for _, wheel in ipairs(data.wheels) do
        wheel:Update()
        SpawnCircle(wheel:GetPos(), wheel.type:GetRadius(), Blue(), 0.04)
    end
end
function DeviceManager.IndexAtLoad()
    data.wheels = {}
    for side = 0, 2 do
        local deviceCount = GetDeviceCountSide(side)
        for deviceIndex = 0, deviceCount - 1 do
            local id = GetDeviceIdSide(side, deviceIndex)
            local teamId = GetDeviceTeamId(id)
            local wheel = Wheel(id, teamId)
            if wheel then
                table.insert(data.wheels, wheel)
            end
            
        end
    end
end
function DeviceManager.OnDeviceCreated(teamId, deviceId, saveName, nodeA, nodeB, t, upgradedId)
    local wheel = Wheel(deviceId, teamId)
    table.insert(data.wheels, wheel)
end

function DeviceManager.OnDeviceMoved(teamId, deviceId, temporaryDeviceId, saveName)
    DeviceManager.RemoveDevice(deviceId, saveName)
end

function DeviceManager.OnDeviceDeleted(teamId, deviceId, saveName, nodeA, nodeB, t)
    DeviceManager.RemoveDevice(deviceId, saveName)
end

function DeviceManager.OnDeviceDestroyed(teamId, deviceId, saveName, nodeA, nodeB, t)
    DeviceManager.RemoveDevice(deviceId, saveName)
end

function DeviceManager.OnDeviceTeamUpdated(oldTeamId, newTeamId, deviceId, saveName)
    for _, device in ipairs(data.wheels) do
        if device.deviceId == deviceId then
            device:UpdateTeam(newTeamId)
            return
        end
    end
end

function DeviceManager.RemoveDevice(deviceId, saveName)
    DeviceManager.RemoveWheel(deviceId)
end
function DeviceManager.RemoveWheel(deviceId)
    for index, wheel in ipairs(data.wheels) do
        if wheel.deviceId == deviceId then
            table.remove(data.wheels, index)
            return
        end
    end
end