--scripts/force/forceManager.lua

ForceManager = {

}
data.forceTable = {}

function ForceManager.Load()
    data.forceTable = {}
end 
function ForceManager.Update(frame)
    for node, force in pairs(data.forceTable) do
        dlc2_ApplyForce(node, force)
    end
    data.forceTable = {}
end

function ApplyForce(node, force)
    data.forceTable[node] = (data.forceTable[node] or Vec3(0,0,0)) + force
end