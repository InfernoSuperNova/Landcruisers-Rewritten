--fileList.lua


FileList = {

    ["classes"] = {
        
        "terrain",
        "trackSet",
        "graph",
        ["wireframe"] = {
            "drawableWheel",
        },
        ["cruiserComponents"] = {
            "wheel",
            "engine",
        }
    },
    ["config"] = {
        "modDebug",
        "terrain",
        "wheelDefinitions",
        "wheel",
        "drawing",
    },
    ["scripts"] = {
        ["wheels"] = {
            "wheelManager",
            "trackmanager",
        },
        ["devices"] = {
            "deviceManager",
        },
        ["debug"] = {
            "highlighting",
            "updateLogging",
            "mouseWheel",
        },
        ["terrain"] = {
            "terrainManager",
        },
        ["math"] = {
            "vector",
            "dampening",
            "tracks",
            "math",
        },
        ["force"] = {
            "forceManager"
        },
        ["other"] = {
            "json",
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
        elseif type(item) == "string" then
            Log("Landcruisers: Loading ".. RGBAtoHex(50, 150, 50, 255, false)..path.."/"..item..".lua")
            dofile(path .. "/"..item..".lua")
        end
    end
end
function FileList.LoadFiles()
    LoadTableFiles(FileList, path)
end