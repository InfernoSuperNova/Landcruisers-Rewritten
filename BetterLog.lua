--BetterLog.lua
--- forts script API ---
--use BetterLog for improved log function (convert to string and log tables)
----------------------------------------------------------------------------------------------------------------
--Improved Log functions----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------
--Function LogTables
--Log the given table in game format
--Table : table to log
--IndentLevel : indentation level of the table content (ex : 1 if it's the first time the function is called)

function LogTables(Table, IndentLevel, ToFile)

    if Table == nil then
        LogOption("nil", ToFile)
    else
        IndentLevel = IndentLevel or 1
        local indent = string.rep("    ", IndentLevel)
        local indentinf = string.rep("    ", IndentLevel-1)
        local metatable = getmetatable(Table)
        if metatable and metatable.__tostring then
            LogOption(indent .. tostring(Table) .. ",", ToFile)
        else
            LogOption(indentinf .. "{", ToFile)
            for k, v in pairs(Table) do
                if type(k) == "number" then
                    if type(v) == "table" then
                        LogOption(indent .. "[" .. tostring(k) .. "] = ", ToFile)
                        LogTables(v, IndentLevel + 1, ToFile)
                    elseif type(v) == "function" then
                        LogFunction(v, indent, ToFile)
                    elseif type(v) == "string" then
                        LogOption(indent .. "[" .. tostring(k) .. '] = "' .. v .. '",', ToFile)
                    else
                        LogOption(indent .. "[" .. tostring(k) .. "] = " .. tostring(v) .. ",", ToFile)
                    end
                else
                    if type(v) == "table" then
                        LogOption(indent .. tostring(k) .. " = ", ToFile)
                        LogTables(v, IndentLevel + 1, ToFile)
                    elseif type(v) == "function" then
                        LogFunction(v, indent, ToFile)
                    elseif type(v) == "string" then
                        LogOption(indent .. tostring(k) .. ' = "' .. v .. '",', ToFile)
                    else
                        LogOption(indent .. tostring(k) .. " = " .. tostring(v) .. ",", ToFile)
                    end
                end
            end
            if IndentLevel > 1 then
                LogOption(indentinf .. "},", ToFile)
            else
                LogOption(indentinf .. "}", ToFile)
            end
        end
    end
end


function LogOption(str, ToFile)
    if ToFile then
        LogToFile(str)
    else
        Log(str)
    end
end

----------------------------------------------------------------------------------------------------------------
--Function LogFunction
--If FindFunctionName is present, logs the name of the function (instead of the memory adress)

function LogFunction(Func, indent, ToFile)
    if FindFunctionName and FindFunctionName(Func) then
        LogOption(indent .. "function : " .. FindFunctionName(Func), ToFile)
    else
        LogOption(tostring(Func), ToFile)
    end
end

----------------------------------------------------------------------------------------------------------------
--Function BetterLog
--Log the argument in the approriate format. convert it automatically to a string if needed.
--v : variable to log (any type)

function BetterLog(v)
    if type(v) == "table" then
        local metatable = getmetatable(v) --metatables are a lua feature to modify how table behave (mainly operators). Vec3 has one allowing you to use + and * on them like a mathematical vector
        if metatable and metatable.__tostring then --if the table has a built in print method, use it
            Log(tostring(v))
        else
            LogTables(v, 1, false) --otherwise use the default method of tables
        end
    elseif type(v) == "function" then
        LogFunction(v, "", false)
    else
        Log(tostring(v))
    end
end


function BetterLogToFile(v)
    if type(v) == "table" then
        local metatable = getmetatable(v) --metatables are a lua feature to modify how table behave (mainly operators). Vec3 has one allowing you to use + and * on them like a mathematical vector
        if metatable and metatable.__tostring then --if the table has a built in print method, use it
            LogToFile(tostring(v))
        else
            LogTables(v, 1, true) --otherwise use the default method of tables
        end
    elseif type(v) == "function" then
        LogFunction(v, "", true)
    else
        LogToFile(tostring(v))
    end
end