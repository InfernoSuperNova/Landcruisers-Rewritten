Construct with a table of objects- containing a wheel type (for radius), and displaced position
Inside the constructor, it should handle:
Sorting the wheels into a hull
Displacing that hull outwards


Perhaps the actual track structure should contain the position of the track (like how far around the wheels the track has moved), as well as perhaps containing a copy of each wheel
Should be updated and take wheel position







Currently, we have a broad list of wheels
We also have a list of track sets that also contains those wheels
Should be we invoking the wheel updates from those track sets?
That sounds messy, but the alternative sounds messy as well
My gut says "no"
Furthermore, should the indexing be done from deviceManager?
Or should it be called directly from Load()?

Right now, all wheel behavior doesn't require a specific structureId, but track behavior will
