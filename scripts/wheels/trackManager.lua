TrackManager = {}
function TrackManager.Update()
    local wheelStructures = TrackManager.IndexWheels()
    for _, wheels in pairs(wheelStructures) do
        TrackSet(wheels)
    end
    
    
    
end

function TrackManager.IndexWheels()
    --Group wheels based on structure id
    local wheelStructures = {}
    for _, wheel in pairs(data.wheels) do
        if wheelStructures[wheel.structureId] == nil then
            wheelStructures[wheel.structureId] = {}
        end
        table.insert(wheelStructures[wheel.structureId], wheel)
    end
    return wheelStructures
end
