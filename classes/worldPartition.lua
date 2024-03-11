
WorldPartition = {
    finalPartitionCount = 0,
    partitionLevels = 0,
}

WorldPartitionMetaTable = {
    TopLeft = Vec3(0,0,0),
    BottomRight = Vec3(0,0,0),
    Center = Vec3(0,0,0),
    Width = 0,
    Height = 0,
    Subpartitions = {},
    Terrain = {},
}

function WorldPartition.New(topLeft, bottomRight)
    return WorldPartitionMetaTable:New(topLeft, bottomRight)
end

function WorldPartitionMetaTable:New(topLeft, bottomRight)
    local o = {}
    setmetatable(o, self)
    self.__index = self
    o.TopLeft = topLeft
    o.BottomRight = bottomRight
    o.Center = Vec3Lerp(topLeft, bottomRight, 0.5)
    o.Width = bottomRight.x - topLeft.x
    o.Height = bottomRight.y - topLeft.y
    o.Subpartitions = {}
    o.Terrain = {}
    return o
end

function WorldPartitionMetaTable:Partition()
    if self.Width > WorldPartitionerConfig.finalPartitionMaxSize
    or self.Height > WorldPartitionerConfig.finalPartitionMaxSize then
        --split the partition into 4 subpartitions
        for partX = 0, 1 do
            for partY = 0, 1 do
                
                local topLeft = Vec3(
                    math.lerp(self.TopLeft.x, self.Center.x, partX),
                    math.lerp(self.TopLeft.y, self.Center.y, partY)
                )
                if topLeft == self.TopLeft then topLeft = self.TopLeft end
                --set the pointer to the same memory address for memory efficiency

                local bottomRight = Vec3(
                    math.lerp(self.Center.x, self.BottomRight.x, partX),
                    math.lerp(self.Center.y, self.BottomRight.y, partY)
                )

                if bottomRight == self.BottomRight then bottomRight = self.BottomRight end
                local subpartition = WorldPartition.New(topLeft, bottomRight)
                self.Subpartitions[partX .. partY] = subpartition
                --table.insert(self.Subpartitions, subpartition)
                subpartition:Partition()
            end
        end
    end
end

function WorldPartitionMetaTable:HighlightPartitionForPosition(pos)
    local topLeft = self.TopLeft
    local topRight = {x = self.BottomRight.x, y = self.TopLeft.y}
    local bottomLeft = {x = self.TopLeft.x, y = self.BottomRight.y}
    local bottomRight = self.BottomRight
    SpawnLine(topLeft, topRight, White(), 0.04)
    SpawnLine(topRight, bottomRight, White(), 0.04)
    SpawnLine(bottomRight, bottomLeft, White(), 0.04)
    SpawnLine(bottomLeft, topLeft, White(), 0.04)

    local xKey = BoolToNumber(pos.x > self.Center.x)
    local yKey = BoolToNumber(pos.y > self.Center.y)
    local subpartition = self.Subpartitions[xKey .. yKey]
    if subpartition then
        subpartition:HighlightPartitionForPosition(pos)
    end
end
