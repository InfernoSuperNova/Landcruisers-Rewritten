
--Call debugMagic in script.lua to have to globally wrap everything
dofile(path .. "/debugMagic.lua")
dofile("scripts/forts.lua")
dofile(path .. "/fileList.lua")
FileList.LoadFiles()
dofile(path .. "/BetterLog.lua")
--dofile(path .. "/scripts/wheels/collisions.lua")

function Load(gameStart)
    
    DeviceManager.Load()
    TerrainManager.Load()
end

function Update(frame)
    Collisions.Update(frame)
    DeviceManager.Update(frame)
    UpdateFunction("TerrainManager", "Update", frame)
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




--Call again to ensure functionality
dofile(path .. "/debugMagic.lua")