local SubPath = (...):gsub('%.[^%.]+%.[^%.]+$', '')

local Class = require(SubPath..".class")

local function isCallable (f)
   if type(f) == 'function' then
      return true
   elseif type(f) == 'table' then
      local mt = getmetatable(f)
      if mt and type(mt.__call) == 'function' then
         return true
      end
   end

   return false
end

local Script = Class()
function Script:init(node, func, ...)
   if not isCallable(func) then
      error("bad argument #1 to 'script' (function expected)", 3)
   end

   self.node = node
   self.func = func
   self.args = {..., n = select('#', ...)}
end

function Script:update(dt)
   return self.func(self.node, dt, unpack(self.args, self.args.n))
end

return Script
