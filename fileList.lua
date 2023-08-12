local fileList = {

    ["scripts"] = {
        ["wheels"] = {
            "collision.lua",
        }
    }
}

local function RGBAtoHex(r, g, b, a, UTF16)
    local hex = string.format("%02X%02X%02X%02X", r, g, b, a)
    if UTF16 == true then
        return L"[HL=" .. towstring(hex) .. L "]"
    else
        return "[HL=" .. hex .. "]"
    end
end
function LoadTableFiles(table, path)
    for folder, item in pairs(table) do
        if type(item) == "table" then
            LoadTableFiles(item, path.."/"..folder)
        else
            Log("Landcruisers: Loading ".. RGBAtoHex(50, 150, 50, 255, false)..path.."/"..item..".lua")
            _G[item] = dofile(path .. "/"..item..".lua")
        end
    end
end
function LoadFiles()
    LoadTableFiles(fileList, path)
end
