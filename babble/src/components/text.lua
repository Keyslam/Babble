local SubPath = (...):gsub('%.[^%.]+%.[^%.]+$', '')

local Class   = require(SubPath..".class")
local Content = require(SubPath..".content")

local Text = Class()
function Text:init(node, str, id, options)
   self.node        = node
   self.str         = str
   self.id          = id
   self.pos         = 0
   self.started     = false
   self.currentTime = 0

   self.color     = options and options.color
   self.typeSpeed = options and options.typeSpeed or 20
   self.typeSound = options and options.typeSound

   self.content = Content(id or os.time(), self.color)
end

function Text:update(dt)
   if not self.started then
      self.node.parent:addContent(self.content)
      self.started = true
   else
      self.currentTime = self.currentTime + dt

      if self.currentTime >= 1 / self.typeSpeed then
         self.pos = self.pos + 1
         self.content.text = self.str:sub(0, self.pos)

         self.currentTime = 0

         if self.pos == #self.str then
            return true
         end
      end
   end
end

return Text
