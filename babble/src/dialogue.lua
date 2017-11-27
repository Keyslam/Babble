local Path = (...):gsub('%.[^%.]+$', '')

local Class = require(Path..".class")
local Node  = require(Path..".node")

local Dialogue = Class()
function Dialogue:init()
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
