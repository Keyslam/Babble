local Namespace = require((...):gsub('%.[^%.]+$', '')..".namespace")
local Class     = Namespace.class
local Node      = Namespace.node

local Dialogue = Class("Dialogue")

function Dialogue:initialize()
   self.nodes       = {}
   self.currentNode = "start"

   self.buffer = {}
end

function Dialogue:startNode(id, custom)
   local node = Node(self, id, custom)

   self.nodes[id] = node

   return node
end

function Dialogue:update(dt)
   self.nodes[self.currentNode]:update(dt)
end

function Dialogue:draw(x, y, w, h)
end

return Dialogue
