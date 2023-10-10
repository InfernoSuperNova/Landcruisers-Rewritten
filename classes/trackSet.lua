TrackSetMetaTable = {
    prevPosition = 0, --For interpolation
    position = 0,
    wheels = {},
    track = {},
}

function TrackSet(wheels)
    return TrackSetMetaTable:new(wheels)
end

function TrackSetMetaTable:new(wheels)
    local o = {}
    setmetatable(o, self)
    self.__index = self
    o.wheels = wheels
    o.track = {}
    return o
end

function TrackSetMetaTable:Update()
    self.track = {}
    local circles = {}
    for _, wheel in pairs(self.wheels) do
        local pos = wheel:GetDisplacedPos()
        local radius = wheel.type:GetRadius()
        table.insert(circles, {pos = pos, radius = radius})
    end
    local hull = Tracks.GiftWrapping(circles)
    local straightSegments = Tracks.GetStraights(hull)
    for i = 1, #self.wheels do
        table.insert(self.track, self.wheels[i])
        table.insert(self.track, straightSegments[i])
    end
end

function TrackSetMetaTable:AddWheel(wheel)
    table.insert(self.wheels, wheel)
end


function TrackSetMetaTable:RemoveWheel(wheel)
    for i = 1, #self.wheels do
        if self.wheels[i] == wheel then
            table.remove(self.wheels, i)
            return
        end
    end
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