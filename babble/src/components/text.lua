local SubPath = (...):gsub('%.[^%.]+%.[^%.]+$', '')

local Class    = require(SubPath..".class")
local Contents = require(SubPath..".contents")

local Text = Class()
function Text:init(node, str, id, options)
   self.node        = node
   self.str         = str
   self.id          = id
   self.pos         = 0
   self.started     = false
   self.currentTime = 0

   self.color     = options and options.color or {255, 255, 255}
   self.font      = options and options.font
   self.typeSpeed = options and options.typeSpeed or 20
   self.typeSound = options and options.typeSound

   self.content = Contents.text(id)
   self.content:setText(1, "")
   self.content:appendEffect(1, {"color", self.color})
   self.content:appendEffect(1, {"font",  self.font})
end

function Text:update(dt, skip)
   if not self.started then
      self.node.parent:addContent(self.content)
      self.started = true
   end

   if not skip then
      self.currentTime = self.currentTime + dt

      if self.currentTime >= 1 / self.typeSpeed then
         self.pos = self.pos + 1
         self.content:setText(1, self.str:sub(0, self.pos))

         self.currentTime = 0

         if self.pos == #self.str then
            return true
         end
      end
   else
      self.content:setText(1, self.str)
      return true
   end
end

return Text
