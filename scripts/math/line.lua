Line = {}

function Line.OnSegment(p, q, r)
    if q.x <= math.max(p.x, r.x) and q.x >= math.min(p.x, r.x) and
            q.y <= math.max(p.y, r.y) and q.y >= math.min(p.y, r.y) then
        return true
    end
    return false
end

function Line.Orientation(p, q, r)
    local val = (q.y - p.y) * (r.x - q.x) -
        (q.x - p.x) * (r.y - q.y);

    if val == 0 then return 0 end          -- collinear

    if val > 0 then return 1 else return 2 end -- clock or counterclock wise
end

function Line.DoIntersect(p1, q1, p2, q2) 


    -- Find the four orientations needed for general and 
    -- special cases 

    local o1 = Line.Orientation(p1, q1, p2)
    local o2 = Line.Orientation(p1, q1, q2)
    local o3 = Line.Orientation(p2, q2, p1)
    local o4 = Line.Orientation(p2, q2, q1)
  
    -- General Case
    if o1 ~= o2 and o3 ~= o4 then return true end

  
    -- Special Cases 
    -- p1, q1 and p2 are collinear and p2 lies on segment p1q1 
    if o1 == 0 and Line.OnSegment(p1, p2, q1) then return true end 
  
    -- p1, q1 and q2 are collinear and q2 lies on segment p1q1 
    if o2 == 0 and Line.OnSegment(p1, q2, q1) then return true end 
  
    -- p2, q2 and p1 are collinear and p1 lies on segment p2q2 
    if o3 == 0 and Line.OnSegment(p2, p1, q2) then return true end
  
     -- p2, q2 and q1 are collinear and q1 lies on segment p2q2 
    if o4 == 0 and Line.OnSegment(p2, q1, q2) then return true end
  
    return false -- Doesn't fall in any of the above cases 
end

function Line.IntersectPoint(p1, q1, p2, q2)
    local det = (q1.y - p1.y) * (p2.x - q2.x) - (p1.x - q1.x) * (q2.y - p2.y)

    if det == 0 then
        -- Lines are parallel, you may need additional handling based on your requirements
        return nil
    else
        local t1 = ((p1.x - p2.x) * (p2.y - q2.y) + (p1.y - p2.y) * (q2.x - p2.x)) / det
        local intersectionX = p1.x + t1 * (q1.x - p1.x)
        local intersectionY = p1.y + t1 * (q1.y - p1.y)

        return Vec3(intersectionX, intersectionY)
    end
end