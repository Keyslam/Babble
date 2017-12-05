local SubPath = (...):gsub('%.[^%.]+%.[^%.]+$', '')

local Class = require(SubPath..".class")

local Wait = Class()
function Wait:init(node, delay)
   self.node    = node
   self.delay   = delay or 0.25
   self.current = 0
end

function Wait:update(dt)
   self.current = self.current + dt

   if self.current >= self.delay then
      return true
   end
end

return Wait
