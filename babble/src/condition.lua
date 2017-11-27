local Path = (...):gsub('%.[^%.]+$', '')

local Class = require(Path..".class")

local Condition = Class()
function Condition:init(func, target, env, index, ...)
   self.func    = func
   self.target  = target
   self.env     = env
   self.index   = index
   self.targets = {...}
end

function Condition:evaluate()
   return self.func(self.target or true, self.env[self.index], self.targets[1], self.targets[2])
end

function Condition.equals        (t, a, b) return (a == b) and t end
function Condition.different     (t, a, b) return (a ~= b) and t end
function Condition.greater       (t, a, b) return (a >  b) and t end
function Condition.greaterOrEqual(t, a, b) return (a >= b) and t end
function Condition.lesser        (t, a, b) return (a <  b) and t end
function Condition.lesserOrEqual (t, a, b) return (a <= b) and t end

function Condition.between(t, a, b, c) return (v > t1 and v < t2) and t end
function Condition.outside(t, a, b, c) return (v < t1 or  v > t2) and t end

function Condition.cor (t, a, b) return (a or  b) and t end
function Condition.cand(t, a, b) return (a and b) and t end
function Condition.cxor(t, a, b) return (a ~=  b) and t end

function Condition.cnor (t, a, b) return (not (a or  b)) and t end
function Condition.cnand(t, a, b) return (not (a and b)) and t end
function Condition.cxnor(t, a, b) return (not (a ~=  b)) and t end

return Condition
