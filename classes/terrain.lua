--classes/terrain.lua

BlockMetaTable = {
    blockIndex = 0,
    nodes = {},
    continuousUpdate = false,
    colliderPos =  Vec3(),
    colliderRadius = 0,
}

function Block(blockIndex, continuousUpdate)
    return BlockMetaTable:new(blockIndex, continuousUpdate)
end
function BlockMetaTable:new(blockIndex, continuousUpdate)
    local o = {}
    setmetatable(o, self)
    self.__index = self

    o.blockIndex = blockIndex
    o.continuousUpdate = continuousUpdate
    local nodeCount = GetBlockVertexCount(blockIndex)
    o.nodes = {}
    for nodeIndex = 0, nodeCount - 1 do
        local nodePos = GetBlockVertexPos(blockIndex, nodeIndex)
        table.insert(o.nodes, nodePos)
    end
    local collider = MinimumCircularBoundary(o.nodes)
    o.colliderPos = Vec3(collider.x, collider.y)
    o.colliderRadius = collider.r
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
        local collider = MinimumCircularBoundary(self.nodes)
        self.colliderPos = Vec3(collider.x, collider.y)
        self.colliderRadius = collider.r
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

