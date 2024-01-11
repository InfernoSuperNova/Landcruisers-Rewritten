MouseWheel = {
    wheel = {},
    previousMousePos = Vec3(0,0,0)
}



function MouseWheel.Load()
    MouseWheel.wheel = Wheel(nil, nil)
    MouseWheel.wheel.type = WheelDefinitionHelpers.GetWheelDefinitionBySaveName("largeSuspension")
    MouseWheel.wheel.structureId = 2000000000
    MouseWheel.wheel.shouldUpdate = false
    WheelManager.AddWheel(MouseWheel.wheel)
    TrackManager.AddWheel(MouseWheel.wheel)
end

function MouseWheel.Update()
    local mousePos = ProcessedMousePos()
    local delta = mousePos - MouseWheel.previousMousePos
    MouseWheel.previousMousePos = mousePos
    if MouseWheel.wheel then
        MouseWheel.wheel.previousDisplacedPos = MouseWheel.wheel.displacedPos
        MouseWheel.wheel.devicePos = mousePos
        MouseWheel.wheel.actualPos = mousePos
        MouseWheel.wheel.displacedPos = mousePos
        MouseWheel.wheel.nodePosA = mousePos
        MouseWheel.wheel.nodePosB = mousePos
        MouseWheel.wheel.nodeVelA = delta
        MouseWheel.wheel.nodeVelB = delta
        MouseWheel.wheel:UpdateVelocity()
    end
end