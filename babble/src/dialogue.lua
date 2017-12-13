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
   self.x = 0
   self.y = 0
   self.w = 0
   self.h = 0

   self.nodes    = {}
   self.stack    = {}

   self.contents = {}

   self.buffer = {}
   self.dirty  = true

   self.effects = {
      color     = {255, 255, 255},
      font      = nil,
      underline = false,
   }
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
   self.contents[#self.contents + 1] = content
   self.dirty = true
end

function Dialogue:skip()
   self:update(0, true)
end

function Dialogue:update(dt, skip)
   while self.current do
      local continue, state = self.current:update(dt, skip)

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

function Dialogue:render(w, h)
   self.buffer = {}
   self.curX   = 0
   self.curY   = 0

   for _, content in ipairs(self.contents) do
      local currentText = ""

      for i, text in ipairs(content.text) do
         if content.effects[i] then
            if currentText ~= "" then
               self:renderText(currentText)
            end

            for _, effect in ipairs(content.effects[i]) do
               self.effects[effect[1]] = effect[2]
            end

            currentText = ""
         end

         currentText = currentText..text
      end

      self:renderText(currentText)

      --local _, count = string.gsub(content.text[1], " ", "")
      --print(content.text[1], count)
   end

   self.buffer[#self.buffer + 1] = {
      block = true,

      x = self.curX,
      y = self.curY,
      w = 5,
      h = 5,

      color = {225, 225, 225}
   }
end

function Dialogue:renderText(text)
   local font = self.effects.font or love.graphics.getFont()

   for line in text:gmatch("[^\r\n]+") do
      self.buffer[#self.buffer + 1] = {
         text = line,
         x    = self.curX,
         y    = self.curY,

         color = self.effects.color,
         font  = font,
      }

      if self.effects.underline then
         self.buffer[#self.buffer + 1] = {
            line = true,
            x    = self.curX,
            y    = self.curY + font:getHeight() + font:getDescent(),
            w    = font:getWidth(line),

            color = self.effects.color,
         }
      end

      if text:find("\n") then
         self.curX = 0
         self.curY = self.curY + font:getHeight()
      else
         self.curX = self.curX + font:getWidth(line)
      end
   end
end

function Dialogue:draw(x, y, w, h, drawBB)
   if self.dirty then
      self:render(w, h)
   end

   local prefColor = {love.graphics.getColor()}
   local prefFont  = love.graphics.getFont()

   for _, handle in ipairs(self.buffer) do
      love.graphics.setColor(handle.color)

      if handle.text then
         love.graphics.setFont(handle.font)
         love.graphics.print(handle.text, handle.x + x, handle.y + y)
      end

      if handle.block then
         love.graphics.rectangle("fill", handle.x + x, handle.y + y, handle.w, handle.h)
      end

      if handle.line then
         love.graphics.line(handle.x + x, handle.y + y, handle.x + handle.w + x, handle.y + y)
      end
   end

   love.graphics.setColor(prefColor)
   love.graphics.setFont(prefFont)

   if drawBB then
      love.graphics.rectangle("line", x, y, w, h)
   end

   --[[
   local totalContent = {}
   local totalText    = ""

   for _, content in ipairs(self.buffer) do
      for i, textOrColor in ipairs(content.coloredText) do
         totalContent[#totalContent + 1] = textOrColor

         if i % 2 == 0 then
            print(i)
         end
      end
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
   ]]


end

return Dialogue
