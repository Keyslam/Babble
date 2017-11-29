local SubPath = (...):gsub('%.[^%.]+%.[^%.]+$', '')

local Class = require(SubPath..".class")

local Pause = Class()
function Pause:init(node, delay)
   self.node    = node
   self.delay   = delay
   self.current = 0
end

function Pause:update(dt)
   self.current = self.current + dt

   if self.current >= self.delay then
      return true
   end
end

return Pause
