local SubPath = (...):gsub('%.[^%.]+%.[^%.]+$', '')

local Class    = require(SubPath..".class")
local Contents = require(SubPath..".contents")

local function isCallable(f)
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

local Text = Class()
function Text:init(node, str, options)
   self.node        = node
   self.str         = str
   self.pos         = 0
   self.started     = false
   self.currentTime = 0

   self.color         = options and options.color         or {255, 255, 255}
   self.font          = options and options.font          or love.graphics.getFont()
   self.underline     = options and options.underline     or false
   self.strikethrough = options and options.strikethrough or false
   self.offset        = options and options.offset        or {0, 0}
   self.typeSpeed     = options and options.typeSpeed     or 20
   self.typeSound     = options and options.typeSound
   self.explicit      = options and options.explicit

   self.content = Contents.text(id)
   self.content:setModifier(1, "color",         self.color)
   self.content:setModifier(1, "font",          self.font)
   self.content:setModifier(1, "underline",     self.underline)
   self.content:setModifier(1, "strikethrough", self.strikethrough)
   self.content:setModifier(1, "offset",        self.offset)
end

function Text:update(dt, skip)
   if not self.started then
      if isCallable(self.str) then
         self.str = self.str()
      end

      self.node.parent:addContent(self.content)
      self.started = true
   end

   if not skip then
      self.currentTime = self.currentTime + dt

      if self.currentTime >= 1 / self.typeSpeed then
         self.pos = self.pos + 1

         if not self.explicit then
            self.content:setText(1, self.str:sub(0, self.pos))
         else
            self.content:setText(self.pos, self.str:sub(self.pos, self.pos))
         end

         self.currentTime = 0

         if self.pos == #self.str then
            return true
         end
      end
   else
      if not self.explicit then
         self.content:setText(1, self.str)
      else
         for i = self.pos, #self.str do
            self.content:setText(i, self.str:sub(i, i))
         end
      end

      return true
   end
end

return Text
