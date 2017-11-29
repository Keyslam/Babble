local SubPath = (...):gsub('%.[^%.]+%.[^%.]+$', '')

local Class = require(SubPath..".class")

local Text = Class()
function Text:init(node, str, color, typeSpeed, typeSound)
   self.node      = node
   self.str       = str
   self.color     = color
   self.typeSpeed = typeSpeed
   self.typeSound = typeSound
end

function Text:update(dt)
   return true
end

return Text
