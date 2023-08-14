BlockMetaTable = {
    blockIndex = 0,
    nodes = {},
    continuousUpdate = false,
}

function Block(blockIndex, continuousUpdate)
    return BlockMetaTable:new(blockIndex, continuousUpdate)
end
function BlockMetaTable:new(blockIndex, continuousUpdate)

    local o = {}
    setmetatable(o, self)
    self.__index = self

    o.blockId = blockIndex
    o.continuousUpdate = continuousUpdate
    local nodeCount = GetBlockVertexCount(blockIndex)
    for nodeIndex = 0, nodeCount - 1 do
        local nodePos = GetBlockVertexPos(blockIndex, nodeIndex)
        table.insert(o.nodes, nodePos)
    end
    return o
end

function BlockMetaTable:Update()
    if self.continuousUpdate then
        self.nodes = {}
        local nodeCount = GetBlockVertexCount(self.blockIndex)
        for nodeIndex = 0, nodeCount - 1 do
            local nodePos = GetBlockVertexPos(self.blockIndex, nodeIndex)
            table.insert(self.nodes, nodePos)
        end
    end
end
function BlockMetaTable:GetColliderPos()
    return self.colliderPos
end
function BlockMetaTable:GetColliderRadius()
    return self.colliderRadius
end
function BlockMetaTable:GetNodes()
    return self.nodes
end