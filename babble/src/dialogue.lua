local Path = (...):gsub('%.[^%.]+$', '')

local Class = require(Path..".class")
local Node  = require(Path..".node")

local Dialogue = Class()
function Dialogue:init()
   self.finished = false
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

   self.finished = false
   self.stack = {node:newInstance()}

   return self
end

function Dialogue:push(id)
   local node = self.nodes[id]

   if not node then
      error(("Invalid node id '%s'"):format(id), 2)
   end

   self.finished = false
   self.stack[#self.stack + 1] = node:newInstance()

   return self
end

function Dialogue:pop()
   self.stack[#self.stack] = nil

   if #self.stack == 0 then
     self.finished = true
   end

   return self
end

function Dialogue:update(dt)
   local node = self.stack[#self.stack]

   if node then
      if node:update(dt) then
        self:pop()
        return self.finished
      end
   end
end

function Dialogue:draw(x, y, w, h)
end

return Dialogue
