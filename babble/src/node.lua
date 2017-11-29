local Path = (...):gsub('%.[^%.]+$', '')

local Class      = require(Path..".class")
local Components = require(Path..".components")

local Node = Class()
local NodeInstance = Class()

Node.custom = {
   colors     = {},
   typeSpeeds = {},
   typeSounds = {},
}

function Node:init(parent, id, custom)
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
   }

   self.components = {}
end

function Node:newInstance ()
  return NodeInstance(self)
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

function NodeInstance:init(node)
  self.node = node
  self.current = 1
  self.parent = node.parent
end

function NodeInstance:update(dt)
   while true do
      local component = self.node.components[self.current]

      if component then
         local state = component:update(dt)

         if state then
            self.current = self.current + 1

            if type(state) == "string" then
               self.parent:push(state)
               break
            end
         else
            break
         end
      else
         return true
      end
   end
end

function NodeInstance:draw()
end

for name, component in pairs(Components) do
   Node[name] = function(self, ...)
      self:addComponent(component(self, ...))
      return self
   end
end

return Node
