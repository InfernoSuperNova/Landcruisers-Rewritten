--scripts/terrain/terrainManager.lua

TerrainManager = {}

function TerrainManager.Load()
    TerrainManager.IndexAtLoad()
end

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
        local nodes = block:GetNodes()
        local collider = block:GetColliderPos()
        local radius = block:GetColliderRadius()
        if ModDebug.collisions then
            SpawnCircle(Vec3(collider.x, collider.y), radius, Blue(), 0.04)
        end
        
    end
end

