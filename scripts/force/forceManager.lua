--scripts/force/forceManager.lua

ForceManager = {
    forceTable = {}
}
data.forceTable = {}
function ForceManager.Update(frame)
    for node, force in pairs(data.forceTable) do
        dlc2_ApplyForce(node, force)
    end
    data.forceTable = {}
end

function ApplyForce(node, force)
    data.forceTable[node] = (data.forceTable[node] or Vec3(0,0,0)) + force
end