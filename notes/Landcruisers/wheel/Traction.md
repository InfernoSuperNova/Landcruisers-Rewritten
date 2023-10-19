In a nutshell:
Each wheel will have a traction coefficient
And also an energy loss coefficient
Wheels will also have an angular velocity value
Velocity will be ADDED when travelling across a surface. Specifically:
It'll store the last collided position
If a frame exists where there is no collision, it will not apply velocity
Otherwise
It will take the difference between the two collision positions, do some funky stuff with the width of the wheel and the velocity coefficient
It will also remove some lateral velocity when the wheel starts spinning, "storing" it in the spinning wheel
Energy will be lost to the hub of the wheel passively
