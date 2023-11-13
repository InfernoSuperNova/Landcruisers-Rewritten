--scripts/terrain/terrainManager.lua

TerrainManager = {}

function TerrainManager.Load()
    TerrainManager.IndexAtLoad()
end
data.terrain = {}
function TerrainManager.IndexAtLoad()
    data.terrain = {}
    local terrainCount = GetBlockCount()
    --loop through all blocks
    for blockIndex = 0, terrainCount - 1 do
        local ignoreBlock = false
        local continuousUpdate = false
        --Check if ignored
        for i = 1, terrainCount do
            if GetTerrainBlockIndex(TerrainConfig.ignoredName) == blockIndex then
                ignoreBlock = true
            end
            if GetTerrainBlockIndex(TerrainConfig.continuousUpdateName) == blockIndex then
                continuousUpdate = true
            end
        end
        if ignoreBlock then continue end
        local block = Block(blockIndex, continuousUpdate)
        table.insert(data.terrain, block)
    end
end


function TerrainManager.Update(frame)

    for _, block in pairs(data.terrain) do

        block:Update()
        
        if ModDebug.collisions then
            local nodes = block:GetNodes()
            local collider = block:GetColliderPos()
            local radius = block:GetColliderRadius()
            local corners = block:GetColliderCorners()
            SpawnCircle(Vec3(collider.x, collider.y), radius, {r = 50, g = 150, b = 200, a = 255}, 0.04)
            Highlighting.HighlightPolygon(corners, {r = 200, g = 150, b = 0, a = 255})
            for i = 1, #nodes do
                local nodeA = nodes[i]
                local nodeB = nodes[i % #nodes + 1]
                Highlighting.HighlightLineWithWidth(nodeA, nodeB, 3, {r = 100, g = 100, b = 150, a = 255})
                
            end
        end
        
    end
end

