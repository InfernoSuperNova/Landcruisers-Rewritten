TrackSetMetaTable = {
    straights = {}
}

function TrackSet(wheels)
    return TrackSetMetaTable:new(wheels)
end

function TrackSetMetaTable:new(wheels)
    local o = {}
    setmetatable(o, self)
    self.__index = self
    local circles = {}
    for _, wheel in pairs(wheels) do
        local pos = wheel:GetDisplacedPos()
        local radius = wheel.type:GetRadius()
        table.insert(circles, {pos = pos, radius = radius})
    end
    local hull = Tracks.GiftWrapping(circles)
    o.straights = Tracks.GetStraights(hull)
end




TrackStraightMetaTable = {
    a = Vec3(),
    b = Vec3(),
}
function TrackStraight(a, b)
    return TrackStraightMetaTable:new(a, b)
end

function TrackStraightMetaTable:new(a, b)


    local o = {}
    setmetatable(o, self)
    self.__index = self
    o.a = a
    o.b = b
    return o
end