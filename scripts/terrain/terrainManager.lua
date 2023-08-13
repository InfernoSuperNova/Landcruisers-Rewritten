TerrainManager = {}

function TerrainManager.Load()
    TerrainManager.IndexAtLoad()
end

function TerrainManager.IndexAtLoad()
    data.terrain = {}
    local terrainCount = GetBlockCount()
    for blockIndex = 0, terrainCount - 1 do
        local ignoreBlock = false
        local continuousUpdate = false
        for i = 1, terrainCount do
            if GetTerrainBlockIndex(TerrainConfig.ignoredName) == blockIndex then
                ignoreBlock = true
            end
            if GetTerrainBlockIndex(TerrainConfig.continuousUpdateName) == blockIndex then
                continuousUpdate = true
            end
        end
        if ignoreBlock then continue end
        local block = Block:new(blockIndex, continuousUpdate)
        table.insert(data.terrain, block)
    end
end

function TerrainManager.Update(frame)
    for _, block in pairs(data.terrain) do
        block:Update()
    end
end