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
    if node == nil or force == nil then
        return
    end
    SpawnCircle(NodePosition(node), 50, Red(), data.updateDelta * 1.2)
    data.forceTable[node] = (data.forceTable[node] or Vec3(0,0,0)) + force
end