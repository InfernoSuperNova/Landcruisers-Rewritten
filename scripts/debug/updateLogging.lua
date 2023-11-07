--scripts/debug/updateLogging.lua


--mostly lifted from landcruisers 1
UpdateLogging = {
    text = "",
    currentLineCount = 0,
}

function UpdateFunction(table, callback, frame)
    if ModDebug.update then
        local prevTime = GetRealTime()
        _G[table][callback](frame)
        local delta = (GetRealTime() - prevTime) * 1000
        UpdateLogging.Log(table .. "." .. callback .. " took " .. string.format("%.2f", delta) .. "ms, " .. string.format("%.1f", delta/(data.updateDelta * 1000) * 100) .. "%")
    else
        _G[table][callback](frame)
    end
end 

function UpdateLogging.Log(string)
    if ModDebug.update then 
        UpdateLogging.text = UpdateLogging.text .. string .. "\n"
    end 
end

function UpdateLogging.Update(frame)
    SetControlFrame(0)
    UpdateLogging.Log("Press Ctrl + Alt + T to hide")

    local lines = UpdateLogging.SplitLines(UpdateLogging.text)
    UpdateLogging.currentLineCount = 0
    for i = 1, #lines do
        local text = lines[i]  
        if not UpdateLogging.ControlExists("debugControl", "debugLine" .. i) then
            AddTextControl("debugControl", "debugLine" .. i, text, ANCHOR_TOP_RIGHT, {x = 0, y = 0 + 9 * i}, false, "Readout")
        else
            SetControlText("debugControl", "debugLine" .. i, text)
        end
        UpdateLogging.currentLineCount = UpdateLogging.currentLineCount + 1
    end
    UpdateLogging.text = ""
end



function UpdateLogging.Load()
    for i = 0, UpdateLogging.currentLineCount do
        DeleteControl("debugControl", "debugLine" .. i)
    end
    DeleteControl("root", "debugControl")
    UpdateLogging.text = ""

    AddTextControl("", "debugControl", "", ANCHOR_TOP_RIGHT, {x = 1050, y = 0}, false, "Console")
    UpdateLogging.updateGraph = Graph.New(850, 100, 200, 100, 20, "%", "Thread Usage")
end


function UpdateLogging.ControlExists(parent, control)
    if GetControlAbsolutePos(parent, control).x == 0 then
        return false
    end
    return true
end

function UpdateLogging.SplitLines(str)
    local lines = {} -- Table to store the lines
    local index = 1  -- Index to track the current line
    for line in str:gmatch("[^\r\n]+") do
        lines[index] = line
        index = index + 1
    end
    return lines
end
