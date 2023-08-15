TrackSetMetaTable = {
    straights = {}
}

function TrackSet(points)
    return TrackSetMetaTable:new(points)
end

function TrackSetMetaTable:new(points)
    local o = {}
    setmetatable(o, self)
    self.__index = self
end




TrackStraightMetaTable = {
    a = Vec3(),
    b = Vec3(),
}
function TrackStraight(a, b)
    return TrackSetMetaTable:new(a, b)
end

function TrackStraightMetaTable:new(a, b)
    local o = {}
    setmetatable(o, self)
    self.__index = self
    o.a = a
    o.b = b
    return o
end