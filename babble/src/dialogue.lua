local Path = (...):gsub('%.[^%.]+$', '')

local Class = require(Path..".class")
local Node  = require(Path..".node")

local Dialogue = Class()
function Dialogue:init()
   self.nodes    = {}
   self.stack    = {}

   self.buffer = {}
end

function Dialogue:startNode(id, custom)
   local node = Node(self, id, custom)

   self.nodes[id] = node

   return node
end

function Dialogue:switch(id)
   local node = self.nodes[id]

   if not node then
      error(("Invalid node id '%s'"):format(id), 2)
   end

   local instance = node:newInstance()
   self.stack = {instance}
   self.current = instance

   return self
end

function Dialogue:push(id)
   local node = self.nodes[id]

   if not node then
      error(("Invalid node id '%s'"):format(id), 2)
   end

   local instance = node:newInstance()
   self.stack[#self.stack + 1] = instance
   self.current = instance

   return self
end

function Dialogue:pop()
   self.stack[#self.stack] = nil

   self.current = self.stack[#self.stack]

   return self
end

function Dialogue:update(dt)
   while self.current do
      local continue, state = self.current:update(dt)

      if continue then
         if type(state) == "string" then
            self:push(state)
         elseif state == nil then
            self:pop(state)
         end
      else
         break
      end
   end

   return not self.current
end

function Dialogue:draw(x, y, w, h)
end

return Dialogue
