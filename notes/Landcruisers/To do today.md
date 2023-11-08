

Modify wheel debug to change line values as it approaches the threshold
DONE
Visualize dot and cross product results better?
Add system to spawn onscreen text at specified co ordinates
Maybe fix annoying collision system

Add a drawableWheel class that creates a wireframe wheel
DONE


To fix annoying collision:
OBSERVATION: As it is currently set to be the radius of the wheel relative to the other normal, it gets "picked up" by a segment as it gets close to it
Ideally, the segment should be all but ignored if it's on the other side of the other segments normal boundary

How it currently looks like:

![[Pasted image 20231108162604.png]]


How it should look like:



![[Pasted image 20231108162653.png]]


HOWEVER, problems arrive on concave surfaces. Namely, 90 degree walls, as the normal of it will render the platform that is being sat on completely untraversable.

![[Pasted image 20231108164447.png]]







To do collisions:
If it's not in range, then skip entirely

If it's not concave, then it should not pass the normal of the next block
If it passes the normal of the next block, then it must be acute
If acute, then do collisions
If any other condition is true, then do collisions
