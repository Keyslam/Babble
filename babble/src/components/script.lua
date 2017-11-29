local SubPath = (...):gsub('%.[^%.]+%.[^%.]+$', '')

local Class = require(SubPath..".class")

local Script = Class()
function Script:init(node, func, ...)
   self.node = node
   self.func = func
   self.args = {..., n = select('#', ...)}
end

function Script:update(dt)
   return self.func(self.node, dt, unpack(self.args, self.args.n))
end

return Script
