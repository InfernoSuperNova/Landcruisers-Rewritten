
--Call debugMagic in script.lua to have to globally wrap everything
dofile(path .. "/debugMagic.lua")
dofile("scripts/forts.lua")
dofile(path .. "/fileList.lua")
FileList.LoadFiles()
dofile(path .. "/BetterLog.lua")
--dofile(path .. "/scripts/wheels/collisions.lua")

function Load(gameStart)
    
    --  Collisions.Update(frame)
end

function Update(frame)
    Collisions.Update(frame)
end



--Call again to ensure functionality
dofile(path .. "/debugMagic.lua")