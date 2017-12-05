local Path = (...):gsub('%.[^%.]+$', '')

local Class = require(Path..".class")
local Node  = require(Path..".node")

local Dialogue = Class()
function Dialogue:init()
   self.nodes    = {}
   self.stack    = {}

   self.buffer      = {}
   self.namedBuffer = {}
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

function Dialogue:addContent(content)
   self.buffer[#self.buffer + 1] = content
   self.namedBuffer[content.id]  = content
end

function Dialogue:getContentByID(id)
   return self.namedBuffer[id]
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

function Dialogue:draw(x, y, w, h, drawBB)
   local totalContent = {}
   local totalText    = ""

   for _, content in ipairs(self.buffer) do
      totalContent[#totalContent + 1] = content.color
      totalContent[#totalContent + 1] = content.text

      totalText = totalText..content.text
   end

   local font = love.graphics.getFont()
   
   local rw, lines  = font:getWrap(totalText, w)
   local lineHeight = font:getHeight()
   local height     = #lines * lineHeight

   local overflow = math.max(0, height - h)

   love.graphics.setScissor(x, y, w, h)
   love.graphics.setColor(255, 255, 255)
   love.graphics.printf(totalContent, x, y - overflow, w, "left")
   love.graphics.setScissor()

   if drawBB then
      love.graphics.rectangle("line", x, y, w, h)
   end
end

return Dialogue
