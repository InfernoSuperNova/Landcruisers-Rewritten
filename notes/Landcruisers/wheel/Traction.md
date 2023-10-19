In the wheel definition, each wheel will have:
A traction coefficient
A bearing coefficient
A mass

And each wheel will have, individual to itself:
A current spin velocity
Traction

When colliding with terrain, the difference between the last two points of collision will be calculated.

If the difference is GREATER than the equivalent movement of the outside of the wheel, then a COUNTER force will be applied to the moving landcruiser, and velocity will be added to the WHEEL.

If the difference is LESS than the equivalent movement of the outside of the wheel, then a COMPLIMENTARY force will be applied to the moving landcruiser, and velocity will be removed from the WHEEL.

Therefore, as they have mass, wheels will be able to implicitly store potential energy.

Note that some energy will be lost due to friction of the moving parts





Coefficiencts, explaints

Traction coefficient:

wheel velocity = tractionCoefficient * vehicle velocity * wheel intersected into ground value
How well energy is transferred between wheel spin and movement
And also energy loss based on how hard is pushing into the ground


Bearing coefficient:

wheel velocity = bearingCoefficient * vehicle velocity

