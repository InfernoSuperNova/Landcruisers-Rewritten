--script.lua

-----------------DOFILES-----------------
dofile(path .. "/debugMagic.lua")
dofile("scripts/forts.lua")
dofile("scripts/core.lua")
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
function OnInstantReplay()
    LoadMod()
end
function Update(frame)

    ModLoop(frame)
end
function OnUpdate()
    ModDraw()
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
    TrackManager.Load()
    TerrainManager.Load()
    --UpdateLogging.Load()
end
PreviousUpdateTime = 0
UpdateDelta = 0
function ModLoop(frame)
    
    local currentTime = GetRealTime()
    local difference = currentTime - PreviousUpdateTime
    UpdateDelta = math.floor(difference * 100 + 0.5) / 100
    PreviousUpdateTime = currentTime
    UpdateFunction("UpdateLogging", "Update", frame)
    UpdateFunction("TerrainManager", "Update", frame)
    UpdateFunction("DeviceManager", "Update", frame)
    UpdateFunction("WheelManager", "Update", frame)
    UpdateFunction("TrackManager", "Update", frame)
    UpdateFunction("ForceManager", "Update", frame)

    if ModDebug.update then
        local endUpdateTime = GetRealTime()
        local delta = (endUpdateTime - currentTime) * 1000
        UpdateLogging.Log("Mod loop took " .. string.format("%.2f", delta) .. "ms, " .. string.format("%.1f", delta/(data.updateDelta * 1000) * 100) .. "%")
    end
    
end
PreviousDrawTime = 0
function ModDraw()
        local newDrawTime = GetRealTime()
        TrackManager.Draw(PreviousUpdateTime, newDrawTime, PreviousDrawTime)
        PreviousDrawTime = newDrawTime
end





function DeepCopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[DeepCopy(orig_key)] = DeepCopy(orig_value)
        end
        setmetatable(copy, DeepCopy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end


dofile(path .. "/debugMagic.lua")