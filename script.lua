local fileList = dofile(path .. "/filelist.lua")



function Load(gameStart)
    fileList.LoadFiles()

end

function Update(frame)
    Log("Hell")
    collisions.Update()

end