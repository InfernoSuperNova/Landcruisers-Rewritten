How to effectively dampen bounces but only perpendicular to the block?
LC1 ran into the issue where terrain surfaces that are not flat would massively increase the rolling resistance
So perhaps we should do a dot product between the current moving direction and the slope up axis? Apply dampening directly based on similarity?

Will it be enough to apply the dampening directly to the movement vector, or should I multiply it by the surface normal unit and then apply it to the movement vector?

