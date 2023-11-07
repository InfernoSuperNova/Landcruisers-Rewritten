--script.lua

-----------------DOFILES-----------------
dofile(path .. "/debugMagic.lua")
dofile("scripts/forts.lua")
--dofile("scripts/core.lua")           -- Already Loaded
--dofile("scripts/core_utility.lua")   -- Already Loaded
dofile(path .. "/BetterLog.lua")
dofile(path .. "/fileList.lua")
FileList.LoadFiles()

---------------API EVENTS----------------
---@type GraphMetaTable
TheGraph = nil
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
    TheGraph:Log(gcinfo(), GetRealTime())
    ModLoop(frame)
end

function OnInstantReplaySystem()
    for i = 0, 255, 40 do
        Notice(RgbaToHex(i, 255, 255 - i, 255, false) .. "Warning: Instant replays are currently broken in Landcruisers, please view from the replay menu instead.")
    end
    
end
function OnUpdate()
    ModDraw()
end
function OnDraw()

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

function LoadMod()
    WheelDefinitionHelpers.ConstructWheelDefinitions()
    DeviceManager.Load()
    TrackManager.Load()
    TerrainManager.Load()
    ForceManager.Load()
    TheGraph = Graph.New(850, 200, 200, 100, 20, "kB / 100,000 kB", "Memory Usage")
    UpdateLogging.Load()
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
        if (UpdateLogging.updateGraph) then
            UpdateLogging.updateGraph:Log(delta/(data.updateDelta * 1000) * 100, endUpdateTime)
        end

        UpdateLogging.Log("Mod loop took " .. string.format("%.2f", delta) .. "ms, " .. string.format("%.1f", delta/(data.updateDelta * 1000) * 100) .. "%")
    end

end
PreviousDrawTime = 0
function ModDraw()
        local newDrawTime = GetRealTime()
        TrackManager.Draw(PreviousUpdateTime, newDrawTime, PreviousDrawTime)
        PreviousDrawTime = newDrawTime
        Graph.Update()
end


function RgbaToHex(r, g, b, a, UTF16)
    local hex = string.format("%02X%02X%02X%02X", r, g, b, a)
    if UTF16 == true then 
      return L"[HL="..towstring(hex)..L"]" 
    else
      return "[HL="..hex.."]"
    end
  end
dofile(path .. "/debugMagic.lua")