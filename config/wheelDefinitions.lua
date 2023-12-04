--config/wheelDefinitions.lua
WheelDefinitions = {
    {
        saveName = "smallSuspension",
        height = 75,
        radius = 75,
        spring = 35000,
        dampening = 3000,
        traction = 100,
        bearingEnergyLoss = 0.01,
        mass = 100,
        sprocketSprite = path .. "/effects/track_sprocket.lua",
        wheelSprite = path .. "/effects/wheel.lua"
    },
    {
        saveName = "suspension",
        height = 150,
        radius = 75,
        spring = 30000,
        dampening = 3000,
        traction = 100,
        bearingEnergyLoss = 0.01,
        mass = 100,
        sprocketSprite = path .. "/effects/track_sprocket.lua",
        wheelSprite = path .. "/effects/wheel.lua"
    },
    {
        saveName = "largeSuspension",
        height = 225,
        radius = 150,
        spring = 60000,
        dampening = 3000,
        traction = 100,
        bearingEnergyLoss = 0.01,
        mass = 450,
        sprocketSprite = path .. "/effects/track_sprocket_large.lua",
        wheelSprite = path .. "/effects/wheel_large.lua"
    },
}
LargestWheelRadius = 0
DefaultWheelDefinition = WheelDefinition:new(75, 0, 30000, 3000, 100, 100, 100, "smallSuspension", "/effects/track_sprocket.lua", "/effects/wheel.lua")

MetaModdingParamName = "LCWheelStats"
NoParamName = "noParams"
WheelDefinitionHelpers = {}


function WheelDefinitionHelpers.GetWheelDefinitionBySaveName(saveName)
    for _, wheelDefinition in ipairs(WheelDefinitions) do
        local definitionSaveName = wheelDefinition.saveName
        if saveName == definitionSaveName then
           return wheelDefinition
        elseif saveName == definitionSaveName .. WheelConfig.invertedNameTag then
            local wheelDefinition = DeepCopy(wheelDefinition)
            wheelDefinition.height = -wheelDefinition.height
            wheelDefinition.isInverted = true
            return wheelDefinition
        end
    end 
    return nil
end

function WheelDefinitionHelpers.ConstructWheelDefinitions()
    BetterLogToFile("///////////////////////////////////////////////////////////////////////////////////////////////////////")
    BetterLogToFile("///////////////////////////////////LANDCRUISERS WHEEL DEFINITIONS//////////////////////////////////////")
    BetterLogToFile("///////////////////////////////////////////////////////////////////////////////////////////////////////")
    local newDefinitions = {}
    for _, wheelDefinition in ipairs(WheelDefinitions) do
        --check if the last character of the saveName is the inverted tag
        local wheel = WheelDefinition:new(wheelDefinition.radius, wheelDefinition.height, wheelDefinition.dampening, wheelDefinition.spring, wheelDefinition.traction,
        wheelDefinition.bearingEnergyLoss, wheelDefinition.mass, wheelDefinition.saveName, wheelDefinition.sprocketSprite, wheelDefinition.wheelSprite, false)
        table.insert(newDefinitions, wheel)
        if wheelDefinition.radius > LargestWheelRadius then LargestWheelRadius = wheelDefinition.radius end --set largest wheel radius
    end
    WheelDefinitions = newDefinitions
    newDefinitions = WheelDefinitionHelpers.ConstructMetaWheelDefinitions(newDefinitions)
    WheelDefinitions = newDefinitions
    LogToFile("Final wheel definitions:")
    BetterLogToFile(WheelDefinitions)
    BetterLogToFile("///////////////////////////////////////////////////////////////////////////////////////////////////////")
    BetterLogToFile("/////////////////////////////////END LANDCRUISERS WHEEL DEFINITIONS////////////////////////////////////")
    BetterLogToFile("///////////////////////////////////////////////////////////////////////////////////////////////////////")
end

--meta modding support
function WheelDefinitionHelpers.ConstructMetaWheelDefinitions(newDefinitions)
    local projectileTypeCount = GetProjectileTypeCount(1)

    for i = 1, projectileTypeCount do
        local metaWheelDefinitionsString = GetProjectileParamStringByIndex(i, 0, MetaModdingParamName, NoParamName)

        if metaWheelDefinitionsString ~= NoParamName then
            local metaWheelDefinitions = Json.decode(metaWheelDefinitionsString)
            for _, metaWheelDefinition in ipairs(metaWheelDefinitions) do
                --check if a wheel definition with the same saveName already exists
                local currentDefinition = WheelDefinitionHelpers.GetWheelDefinitionBySaveName(metaWheelDefinition.saveName)
                
                if currentDefinition ~= nil then
                    LogToFile("Updating wheel definition: " .. metaWheelDefinition.saveName)
                    WheelDefinitionHelpers.UpdateWheelDefinition(currentDefinition, metaWheelDefinition)
                else
                    LogToFile("Creating new wheel definition: " .. metaWheelDefinition.saveName)
                    for key, value in pairs(metaWheelDefinition) do
                        if key:sub(1,1) ~= "_" then
                            LogToFile("    With value " .. key .. ": " .. tostring(value))
                        end
                        
                    end
                    local wheel = WheelDefinition:new(metaWheelDefinition.radius, metaWheelDefinition.height, metaWheelDefinition.dampening, metaWheelDefinition.spring, metaWheelDefinition.traction,
                    metaWheelDefinition.bearingEnergyLoss, metaWheelDefinition.mass, metaWheelDefinition.saveName, metaWheelDefinition.sprocketSprite, metaWheelDefinition.wheelSprite, false)
                    table.insert(newDefinitions, wheel)
                    if metaWheelDefinition.radius > LargestWheelRadius then LargestWheelRadius = metaWheelDefinition.radius end --set largest wheel radius
                end
            end
        end
    end
    return newDefinitions
end

function WheelDefinitionHelpers.UpdateWheelDefinition(currentDefinition, newDefinition)
    for key, value in pairs(newDefinition) do 
        if key ~= "saveName" and key:sub(1,1) ~= "_" then
            LogToFile("    Updated " .. key .. ": was " .. tostring(currentDefinition[key]) .. ", now " .. tostring(value))
            currentDefinition[key] = value
        end
    end
end

