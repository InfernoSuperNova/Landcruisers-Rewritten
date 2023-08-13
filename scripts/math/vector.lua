-- Vector2 class definition
Vector2 = {}
Vector2.__index = Vector2

-- Constructor
function Vector2.new(x, y)
    local self = setmetatable({}, Vector2)
    self.x = x or 0
    self.y = y or 0
    return self
end

-- Addition
function Vector2.__add(a, b)
    return Vector2.new(a.x + b.x, a.y + b.y)
end

-- Subtraction
function Vector2.__sub(a, b)
    return Vector2.new(a.x - b.x, a.y - b.y)
end

-- Scalar multiplication
function Vector2.__mul(v, scalar)
    return Vector2.new(v.x * scalar, v.y * scalar)
end

-- Magnitude (length) of the vector
function Vector2:magnitude()
    return math.sqrt(self.x * self.x + self.y * self.y)
end

-- Normalize the vector to a unit vector
function Vector2:normalize()
    local mag = self:magnitude()
    if mag > 0 then
        self.x = self.x / mag
        self.y = self.y / mag
    end
end

-- Calculate the dot product of two vectors
function Vector2.dot(a, b)
    return a.x * b.x + a.y * b.y
end

-- Calculate the perpendicular vector (rotate 90 degrees counterclockwise)
function Vector2:perpendicular()
    return Vector2.new(-self.y, self.x)
end

-- Display the vector as a string
function Vector2:__tostring()
    return "(" .. self.x .. ", " .. self.y .. ")"
end
