
Ideally, we round segments to appear the very position that a straight segment begins to overlap with the round segment, and a straight segment to appear the very second that the round segment begins to overlap with a straight segment.

This could be done by, eg straight segment, taking the remaining distance from the end of the segment, subtracting that from the link distance, and using that directly as the offset for the next (round) segment. We then use that offset and offset the starting point of the next round arc, again using the segment length minus the remainder to offset the next straight segment, etc, until we get back to the beginning which unfortunately we don't have a case for
