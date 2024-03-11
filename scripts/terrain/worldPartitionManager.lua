WorldPartitionManager = {
    layers = 0,
    finalPartitionCount = 0,
    worldPartition = nil,
}


function WorldPartitionManager.Load()
    local worldExtents = GetWorldExtents()

    local topLeft = Vec3(worldExtents.MinX, worldExtents.MinY, 0)
    local bottomRight = Vec3(worldExtents.MaxX, worldExtents.MaxY, 0)
    local worldPartition = WorldPartition.New(topLeft, bottomRight)


    worldPartition:Partition()
    WorldPartitionManager.worldPartition = worldPartition

    local function CountPartitions(partition, layers)
        local layers = layers or 0
        if partition.Subpartitions["00"] then
            layers = layers + 1
            layers = CountPartitions(partition.Subpartitions["00"], layers)
        end
        return layers
    end
    local layers = CountPartitions(worldPartition)
    
    WorldPartitionManager.layers = layers + 1
    WorldPartitionManager.finalPartitionCount = 4 ^ layers + 1
    BetterLog(WorldPartitionManager.layers)
    BetterLog(WorldPartitionManager.finalPartitionCount)
end

function WorldPartitionManager.Update(frame)
    local mousePos = {x = -19200, y = -12000}
    local startPartitionTime = GetRealTime()
    for i = 1, 1 do
        WorldPartitionManager.worldPartition:HighlightPartitionForPosition(mousePos)
    end
    --WorldPartitionManager.worldPartition:HighlightPartitionForPosition(mousePos)
    local endPartitionTime = GetRealTime()
    local partitionTime = endPartitionTime - startPartitionTime
    --BetterLog(partitionTime)
end