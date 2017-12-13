local Path = (...):gsub('%.[^%.]+$', '')

local Class      = require(Path..".class")
local Components = require(Path..".components")

local Node = Class()

Node.custom = {
   colors     = {},
   typeSpeeds = {},
   typeSounds = {},
}

function Node:init(parent, id)
   self.parent = parent
   self.id     = id

   self.default = {
      color     = {255, 255, 255, 255},
      typeSpeed = 5,
      typeSound = nil,
   }

   self.current = {
      color     = self.default.color,
      typeSpeed = self.default.typeSpeed,
      typeSound = self.default.typeSound,
      component = 1
   }

   self.components = {}
end

function Node:setColor(color)
   color = self.custom.colors[color] or color or self.default.color
   self.current.color = color

   return self
end

function Node:setTypeSpeed(typeSpeed)
   typeSpeed = self.custom.typeSpeeds[typeSpeed] or typeSpeed or self.default.typeSpeed
   self.current.typeSpeed = typeSpeed

   return self
end

function Node:setTypeSound(typeSound)
   typeSound = self.custom.typeSounds[typeSound] or typeSound or self.default.typeSound
   self.current.typeSound = typeSound

   return self
end

function Node:addComponent(component)
   self.components[#self.components + 1] = component

   return self
end

function Node:update(dt, skip)
   local current = self.current.component
   local component = self.components[current]

   if component then
      local state = component:update(dt, skip)

      if state then
         self.current.component = current + 1
         return true, state
      else
         return false
      end
   end

   return true
end

function Node:draw()
end

for name, component in pairs(Components) do
   Node[name] = function(self, ...)
      self:addComponent(component(self, ...))
      return self
   end
end

return Node
