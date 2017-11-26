local Namespace  = require((...):gsub('%.[^%.]+$', '')..".namespace")
local Class      = Namespace.class
local Components = Namespace.components

local Node = Class("Node")
Node.custom = {
   colors     = {},
   typeSpeeds = {},
   typeSounds = {},
}

function Node:initialize(parent, id, custom)
   self.parent = parent
   self.id     = id
   self.custom = custom

   self.default = {
      color     = {255, 255, 255, 255},
      typeSpeed = 5,
      typeSound = nil,
   }

   self.current = {
      color     = self.default.color,
      typeSpeed = self.default.typeSpeed,
      typeSound = self.default.typeSound,

      component = 1,
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

function Node:endNode()
   return self.parent
end

function Node:update(dt)
   local component = self.components[self.current.component]

   if component then
      local finished = component:update(dt)

      if finished then
         self.current.component = self.current.component + 1
      end
   else
      return true
   end
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
