Block = {
    blockIndex = 0,
    nodes = {},
    continuousUpdate = false,
}

function Block:new(blockIndex, continuousUpdate)

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

function Block:Update()
    if self.continuousUpdate then
        self.nodes = {}
        local nodeCount = GetBlockVertexCount(self.blockIndex)
        for nodeIndex = 0, nodeCount - 1 do
            local nodePos = GetBlockVertexPos(self.blockIndex, nodeIndex)
            table.insert(self.nodes, nodePos)
        end
    end
end