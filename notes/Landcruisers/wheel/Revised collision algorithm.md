

Our first steps remain relatively unchanged, except we do the checks using twice the radius of the actual wheels

Loop through wheel groups and see if the boundary is colliding with a block boundary

Loop through wheel groups and see if the boundary is colliding with individual block segment boundaries

Loop through the wheels in the wheel group and save all of the colliders that they are within range of


Now, the steps change:
Starting with the highest displacement segment collider, we take the necessary steps to resolve that collision using a regular sized wheel, and THEN we save the new position, but we don't do any force stuff yet.

Then, we run the collision checks on the other segments in range, starting with the next biggest from the new position.

We repeat that until the displaced position is either too far away from the original position, or until the collision is entirely resolved.


