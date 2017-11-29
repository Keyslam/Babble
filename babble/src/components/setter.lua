local SubPath = (...):gsub('%.[^%.]+%.[^%.]+$', '')

local Class = require(SubPath..".class")

local Setter = Class()
function Setter:init(node, env, index, value)
   self.node  = node
   self.env   = env
   self.index = index
   self.value = value
end

function Setter:update()
   self.env[self.index] = self.value

   return true
end

return Setter
