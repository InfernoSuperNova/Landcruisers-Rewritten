--classes/terrain.lua

BlockMetaTable = {
    blockIndex = 0,
    nodes = {},
    segments = {},
    continuousUpdate = false,
    colliderPos =  Vec3(),
    colliderRadius = 0,
    colliderCorners = {},
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
    o.colliderCorners = collider.square

    o.segments = {}
    for index, nodePos in ipairs(o.nodes) do
        local prevSegmentStart = o.nodes[(index - 2) % #o.nodes + 1]  --index - 1
        local nodeA = nodePos                                               --index
        local nodeB = o.nodes[index % #o.nodes + 1]                   --index + 1
        local nextSegmentEnd = o.nodes[(index + 2 - 1) % #o.nodes + 1]--index + 2


        local segmentStart = nodeA
        local segmentEnd = nodeB
        local segmentDir = segmentEnd - segmentStart
        local segmentNormal = Vec2Normalize(Vec2Perp(segmentDir))  -- Calculate the perpendicular vector
        local prevSegmentNormal = Vec2Normalize(Vec2Perp(segmentStart - prevSegmentStart))
        local nextSegmentNormal = Vec2Normalize(Vec2Perp(nextSegmentEnd - segmentEnd))
        local prevSegmentBoundary = -Vec2Average({prevSegmentNormal, segmentNormal})
        local nextSegmentBoundary = -Vec2Average({nextSegmentNormal, segmentNormal})


        local segment = {nodeA = nodeA, nodeB = nodeB, segmentStart = segmentStart, segmentEnd = segmentEnd, 
        segmentDir = segmentDir, segmentNormal = segmentNormal, prevSegmentNormal = prevSegmentNormal,
        nextSegmentNormal = nextSegmentNormal, prevSegmentBoundary = prevSegmentBoundary, nextSegmentBoundary = nextSegmentBoundary}
        table.insert(o.segments, segment)
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
function BlockMetaTable:GetColliderCorners()
    return self.colliderCorners
end
function BlockMetaTable:GetNodes()
    return self.nodes
end

function BlockMetaTable:GetSegments()
    return self.segments
end

