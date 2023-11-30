--classes/trackSet.lua

TrackSetMetaTable = {
    position = 0,
    wheels = {},
    track = {},
    previousWheelPositions = {},
    previousTrack = {},
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
    o.previousWheelPositions = {}
    o.previousTrack = {}
    return o
end

function TrackSetMetaTable:Update()
    
    self.previousWheelPositions = {}
    for i = 1, #self.wheels do
        local wheel = self.wheels[i]
        table.insert(self.previousWheelPositions, wheel:GetPreviousPos())
    end

    self.previousTrack = {}
    self.previousTrack = self.track
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

function TrackSetMetaTable:Draw(time, duration)
    for i = 1, #self.wheels do
        local oldWheel = self.previousWheelPositions[i]
        local newWheel = self.wheels[i]

        local pos = Vec3Lerp(oldWheel, newWheel:GetDisplacedPos(), time)
        if pos == nil then continue end --I hate this
        if DrawingConfig.drawWheelWireframes then
            local rotation = math.lerp(newWheel:GetPreviousRotation(), newWheel:GetRotation(), time)
            DrawableWheel.Draw(pos, newWheel.type:GetRadius(), rotation, duration * 1.2)
        end
        if DrawingConfig.drawWheelSprites then
            local wheelRotationOld = Vec3FromDegrees(newWheel:GetPreviousRotation())
            local wheelRotationNew = Vec3FromDegrees(newWheel:GetRotation())
            local rotation = Vec3Lerp(wheelRotationOld, wheelRotationNew, time)
            local effect = SpawnEffectEx(newWheel:GetSprocketSprite(), pos, rotation)
        end
    end
    if DrawingConfig.drawTracks then
        for i = 1, #self.track - 1, 2 do
            local oldStraight = self.previousTrack[i + 1]
            local newStraight = self.track[i + 1]
            if oldStraight == nil or newStraight.a == nil or oldStraight.a == nil then return end
            local posA = Vec3Lerp(oldStraight.a, newStraight.a, time)
            local posB = Vec3Lerp(oldStraight.b, newStraight.b, time)
            posA.z = -100
            posB.z = -100
            SpawnLine(posA, posB, {r = 255, g = 255, b = 255, a = 255}, duration * 1.2)
        end
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