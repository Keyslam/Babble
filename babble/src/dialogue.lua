local Path = (...):gsub('%.[^%.]+$', '')

local Class = require(Path..".class")
local Node  = require(Path..".node")

local function isCallable (f)
  if type(f) == 'function' then
    return true
  elseif type(f) == 'table' then
    local mt = getmetatable(f)
    if mt and type(mt.__call) == 'function' then
      return true
    end
  end

  return false
end

local function getNodeInstance (parent, id)
   local constructor = parent.nodes[id]

   if not constructor then
       error(("Invalid node id '%s'"):format(id), 3)
   end

   local node = Node(parent, id)
   return constructor(node) or node
end

local Dialogue = Class()
function Dialogue:init()
   self.nodes    = {}
   self.stack    = {}

   self.buffer      = {}
   self.namedBuffer = {}
end

function Dialogue:addNode(id, constructor)
   if not isCallable(constructor) then
      error("Node Constructor should be a function", 2)
   end

   self.nodes[id] = constructor

   return self
end

function Dialogue:switch(id)
   local instance = getNodeInstance(self, id)

   self.stack = {instance}
   self.current = instance

   return self
end

function Dialogue:push(id)
   local instance = getNodeInstance(self, id)

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
