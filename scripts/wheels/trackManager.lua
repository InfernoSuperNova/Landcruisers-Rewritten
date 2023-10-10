TrackManager = {
    trackSets = {}
}
function TrackManager.Update()
    for _, trackSet in pairs(TrackManager.trackSets) do
        trackSet:Update()
    end
end

function TrackManager.Load()
    TrackManager.IndexAtLoad()
end

function TrackManager.AddWheel(wheel)
    
    local structureId = wheel.structureId
    local trackSet = TrackManager.trackSets[structureId]
    if not trackSet then
        trackSet = TrackSet({wheel})
        
    else
        trackSet:AddWheel(wheel)
    end
    TrackManager.trackSets[structureId] = trackSet
end

function TrackManager.RemoveWheel(wheel)
    local structureId = wheel.structureId
    local trackSet = TrackManager.trackSets[structureId]
    if not trackSet then
        return
    else
        trackSet:RemoveWheel(wheel)
        if #trackSet.wheels == 0 then
            TrackManager.trackSets[structureId] = nil
        end
    end
end

function TrackManager.IndexAtLoad()
    --Group wheels based on structure id
    local wheelStructures = {}
    for _, wheel in pairs(data.wheels) do
        if wheelStructures[wheel.structureId] == nil then
            wheelStructures[wheel.structureId] = {}
        end
        table.insert(wheelStructures[wheel.structureId], wheel)
    end
    for structure, wheels in pairs(wheelStructures) do
        local trackSet = TrackSet(wheels)
        if not TrackManager.trackSets[structure] then
            TrackManager.trackSets[structure] = {}
        end
        TrackManager.trackSets[structure] = trackSet
    end
end
