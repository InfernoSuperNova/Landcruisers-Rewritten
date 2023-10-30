--classes/graph.lua

Graph = {
    graphs = {}

}

function Graph.Update()
    local realTime = GetRealTime()
    for _, graph in pairs(Graph.graphs) do
        graph:Update(realTime)
    end

end



GraphMetaTable = {
    pos = Vec3(0,0,0),
    width = 0,
    height = 0,
    prevTime = 0,
    maxTime = 0,
    data = {},
    unit = "",
    graphUI = nil,
}




function GraphMetaTable:Update(time)
    local delta = time - self.prevTime
    self.prevTime = time
    
    local newPoints = {}
    for _, point in pairs(self.data) do
        point.time = point.time + delta
        if point.time < self.maxTime then
            table.insert(newPoints, point)
        end
    end
    self.data = newPoints
    self:Draw(delta)



    if #self.data == 1 then
        AddTextControl("", self.graphUI, self.graphUI, ANCHOR_TOP_RIGHT, self.pos + Vec3(-20, 0, 0), false, "Console")
        AddTextControl(self.graphUI, "graphCurrentValue", "", ANCHOR_TOP_RIGHT, Vec3(0,20,0), false, "Readout")
        
    else
        SetControlText(self.graphUI, "graphCurrentValue", self.data[#self.data].value .. " " .. self.unit)
    end

    
    
end

function GraphMetaTable:Draw(delta)
    if delta > 1 then
        return
    end
    local transformedPos = ScreenToWorld(self.pos)
    local zoomLevel = GetCameraZoom()
    local corners = {
        topLeft = Vec3(transformedPos.x, transformedPos.y, 0),
        topRight = Vec3(transformedPos.x + self.width * zoomLevel, transformedPos.y, 0),
        bottomLeft = Vec3(transformedPos.x, transformedPos.y + self.height * zoomLevel, 0),
        bottomRight = Vec3(transformedPos.x + self.width * zoomLevel, transformedPos.y + self.height * zoomLevel, 0)
    }
    SpawnLine(corners.topLeft, corners.topRight, {r = 255, g = 255, b = 255, a = 255}, delta * 1.1)
    SpawnLine(corners.topRight, corners.bottomRight, White(), delta * 1.1)
    SpawnLine(corners.bottomRight, corners.bottomLeft, White(), delta * 1.1)
    SpawnLine(corners.bottomLeft, corners.topLeft, White(), delta * 1.1)

    local largestValue = 0
    for _, point in pairs(self.data) do
        if point.value > largestValue then
            largestValue = point.value
        end
    end
    local scale = self.height * zoomLevel / largestValue
    local prevPoint = nil
    for _, point in pairs(self.data) do
        local x = transformedPos.x + (point.time / self.maxTime) * self.width * zoomLevel
        local y = transformedPos.y + self.height * zoomLevel - (point.value * scale)
        local currentPoint = Vec3(x, y, 0)
        if prevPoint then
            SpawnLine(prevPoint, currentPoint, White(), delta * 1.1)
        end
        prevPoint = currentPoint
    end
end

function GraphMetaTable:Log(height, time)
    local delta = time - self.prevTime
    table.insert(self.data, GraphPoint(height, delta))
end

function NewGraph(pos, width, height, maxTime, unit, name)
    local graph = GraphMetaTable:new(pos, width, height, maxTime, unit, name)
    table.insert(Graph.graphs, graph)
    return graph
end

-- Define the constructor for the Graph class
function GraphMetaTable:new(pos, width, height, maxTime, unit, name)
    local graph = {
        pos = pos,
        width = width,
        height = height,
        prevTime = 0,
        maxTime = maxTime,
        data = {},
        unit = unit,
        graphUI = name
    }
    setmetatable(graph, self)
    self.__index = self
    return graph
end







GraphPointMetaTable = {
    value = 0,
    time = 0
}
function GraphPoint(value, time)
    return GraphPointMetaTable:new(value, time)
end

function GraphPointMetaTable:new(value, time)
    local point = {
        value = value,
        time = time
    }
    setmetatable(point, self)
    self.__index = self
    return point
end
