WheelDefinitions = {
    {
        saveName = "smallSuspension",
        height = 75,
        radius = 75,
        spring = 30000,
        dampening = 3000,
        traction = 100,
        mass = 100,
        sprocketSprite = "/effects/track_sprocket.lua",
        wheelSprite = "/effects/wheel.lua"
    },
    {
        saveName = "suspension",
        height = 150,
        radius = 75,
        spring = 30000,
        dampening = 3000,
        traction = 100,
        mass = 100,
        sprocketSprite = "/effects/track_sprocket.lua",
        wheelSprite = "/effects/wheel.lua"
    },
    {
        saveName = "largeSuspension",
        height = 225,
        radius = 150,
        spring = 60000,
        dampening = 3000,
        traction = 100,
        mass = 400,
        sprocketSprite = "/effects/track_sprocket_large.lua",
        wheelSprite = "/effects/wheel_large.lua"
    },
}
LargestWheelRadius = 0

DefaultWheelDefinition = WheelDefinition:new(75, 0, 30000, 3000, 100, 100, "smallSuspension", "/effects/track_sprocket.lua", "/effects/wheel.lua")

WheelDefinitionHelpers = {}


function WheelDefinitionHelpers.GetWheelDefinitionBySaveName(saveName)
    for _, wheelDefinition in ipairs(WheelDefinitions) do
        local definitionSaveName = wheelDefinition:GetSaveName()
        if saveName == definitionSaveName then
           return wheelDefinition
        elseif saveName == definitionSaveName .. WheelConfig.invertedNameTag then
            local wheelDefinition = wheelDefinition:DeepCopy(wheelDefinition)
            wheelDefinition.height = -wheelDefinition.height
            return wheelDefinition
        end
    end 
    return nil
end

function WheelDefinitionHelpers.ConstructWheelDefinitions()
    local newDefinitions = {}
    for _, wheelDefinition in ipairs(WheelDefinitions) do
        local wheel = WheelDefinition:new(wheelDefinition.radius, wheelDefinition.height, wheelDefinition.dampening, wheelDefinition.spring, wheelDefinition.traction,
        wheelDefinition.mass, wheelDefinition.saveName, wheelDefinition.sprocketSprite, wheelDefinition.wheelSprite)
        table.insert(newDefinitions, wheel)
        if wheelDefinition.radius > LargestWheelRadius then LargestWheelRadius = wheelDefinition.radius end
    end
    WheelDefinitions = newDefinitions
end
