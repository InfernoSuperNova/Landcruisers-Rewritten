-----------------DOFILES-----------------
dofile(path .. "/debugMagic.lua")
dofile("scripts/forts.lua")
dofile(path .. "/fileList.lua")
dofile(path .. "/BetterLog.lua")
FileList.LoadFiles()

---------------API EVENTS----------------
function Load(gameStart)
    LoadMod()
end
function OnRestart()
    LoadMod()
end
function OnSeek()
    LoadMod()
end
function OnSeekStart()
    LoadMod()
end
function Update(frame)
    ModLoop(frame)
end
function OnDeviceCreated(teamId, deviceId, saveName, nodeA, nodeB, t, upgradedId)
    DeviceManager.OnDeviceCreated(teamId, deviceId, saveName, nodeA, nodeB, t, upgradedId)
end
function OnDeviceMoved(teamId, deviceId, temporaryDeviceId, saveName)
    DeviceManager.OnDeviceMoved(teamId, deviceId, temporaryDeviceId, saveName)
end
function OnDeviceDeleted(teamId, deviceId, saveName, nodeA, nodeB, t)
    DeviceManager.OnDeviceDeleted(teamId, deviceId, saveName, nodeA, nodeB, t)
end
function OnDeviceDestroyed(teamId, deviceId, saveName, nodeA, nodeB, t)
    DeviceManager.OnDeviceDestroyed(teamId, deviceId, saveName, nodeA, nodeB, t)
end
function OnDeviceTeamUpdated(oldTeamId, newTeamId, deviceId, saveName)
    DeviceManager.OnDeviceTeamUpdated(oldTeamId, newTeamId, deviceId, saveName)
end

-----------------MOD-------------------

data.wheels = {}
data.terrain = {}
function LoadMod()
    WheelDefinitionHelpers.ConstructWheelDefinitions()
    DeviceManager.Load()
    TerrainManager.Load()
end

function ModLoop(frame)
    local startUpdateTime
    if ModDebug.update then
        startUpdateTime = GetRealTime()
    end
    UpdateFunction("UpdateLogging", "Update", frame)
    UpdateFunction("TerrainManager", "Update", frame)
    UpdateFunction("DeviceManager", "Update", frame)
    UpdateFunction("WheelManager", "Update", frame)
    UpdateFunction("TrackManager", "Update", frame)

    if ModDebug.update then
        local endUpdateTime = GetRealTime()
        local delta = (endUpdateTime - startUpdateTime) * 1000
        UpdateLogging.Log("Mod loop took " .. string.format("%.2f", delta) .. "ms, " .. string.format("%.1f", delta/(data.updateDelta * 1000) * 100) .. "%")
    end
    
end

dofile(path .. "/debugMagic.lua")