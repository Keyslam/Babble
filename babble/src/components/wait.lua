local SubPath = (...):gsub('%.[^%.]+%.[^%.]+$', '')

local Class = require(SubPath..".class")

local Wait = Class()
function Wait:init(node)
   self.node    = node
   self.current = 0
end

function Wait:update(dt)
   self.current = self.current + dt

   if self.current >= 0.25 then
      return true
   end
end

return Wait
