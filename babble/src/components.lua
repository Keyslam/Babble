local Namespace = require((...):gsub('%.[^%.]+$', '')..".namespace")
local Class     = Namespace.class

local Text = Class("Text")
function Text:initialize(node, str, color, typeSpeed, typeSound)
   self.node      = node
   self.str       = str
   self.color     = color
   self.typeSpeed = typeSpeed
   self.typeSound = typeSound
end

function Text:update(dt)
   return true
end


local Pause = Class("Pause")
function Pause:initialize(node, delay)
   self.node    = node
   self.delay   = delay
   self.current = 0
end

function Pause:update(dt)
   self.current = self.current + dt

   if self.current >= self.delay then
      return true
   end
end


local Print = Class("Print")
function Print:initialize(node, str)
   self.node = node
   self.str  = str
end

function Print:update(dt)
   print(self.str)

   return true
end


local Script = Class("Script")
function Script:initialize(node, func, args)
   self.node = node
   self.func = func
   self.args = args or {}
end

function Script:update(dt)
   return self.func(self.node, dt, self.args)
end

return {
   text   = Text,
   pause  = Pause,
   print  = Print,
   script = Script,
}
