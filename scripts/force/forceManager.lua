--scripts/force/forceManager.lua

ForceManager = {
    forceTable = {}
}

function ForceManager.Update(frame)
    local forceTable = DeepCopy(ForceManager.forceTable)
    for node, force in pairs(forceTable) do
        dlc2_ApplyForce(node, force)
        table.remove(ForceManager.nodesToForce, node)
    end
end

function ApplyForce(node, force)
    ForceManager.forceTable[node] = (ForceManager.forceTable[node] or Vec3(0,0,0)) + force
end