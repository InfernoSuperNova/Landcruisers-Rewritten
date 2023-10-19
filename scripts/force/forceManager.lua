--scripts/force/forceManager.lua

ForceManager = {
    forceTable = {}
}

function ForceManager.Update(frame)
    for node, force in pairs(ForceManager.forceTable) do
        dlc2_ApplyForce(node, force)
    end
    ForceManager.forceTable = {}
end

function ApplyForce(node, force)
    ForceManager.forceTable[node] = (ForceManager.forceTable[node] or Vec3(0,0,0)) + force
end