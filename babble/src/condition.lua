local Path = (...):gsub('%.[^%.]+$', '')

local Class = require(Path..".class")

local Condition = Class()
function Condition:init(func, env, index, ...)
   self.func    = func
   self.env     = env
   self.index   = index
   self.targets = {...}
end

function Condition:evaluate()
   return self.func(self.env[self.index], self.targets[1], self.targets[2])
end

function Condition.equals(v, t) return v == t end
function Condition.different(v, t) return v ~= t end
function Condition.greater(v, t) return v > t end
function Condition.greaterOrEqual(v, t) return v >= t end
function Condition.lesser(v, t) return v < t end
function Condition.lesserOrEqual(v, t) return v <= t end
function Condition.between(v, t1, t2) return v > t1 and v < t2 end
function Condition.outside(v, t1, t2) return v < t1 or v > t2 end

return Condition
