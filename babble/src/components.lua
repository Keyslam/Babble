local Path = (...):gsub('%.[^%.]+$', '')

local Class = require(Path..".class")

local Text = Class()
function Text:init(node, str, color, typeSpeed, typeSound)
   self.node      = node
   self.str       = str
   self.color     = color
   self.typeSpeed = typeSpeed
   self.typeSound = typeSound
end

function Text:update(dt)
   return true
end


local Pause = Class()
function Pause:init(node, delay)
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


local Print = Class()
function Print:init(node, str)
   self.node = node
   self.str  = str
end

function Print:update(dt)
   print(self.str)

   return true
end


local Script = Class()
function Script:init(node, func, args)
   self.node = node
   self.func = func
   self.args = args or {}
end

function Script:update(dt)
   return self.func(self.node, dt, self.args)
end


local Link = Class()
function Link:init(node, func)
   self.node = node
   self.func = func
end

function Link:update(dt)
   return self.func() or true
end


local Setter = Class()
function Setter:init(node, env, index, value)
   self.node  = node
   self.env   = env
   self.index = index
   self.value = value
end

function Setter:update()
   self.env[self.index] = self.value

   return true
end

return {
   text   = Text,
   pause  = Pause,
   print  = Print,
   script = Script,
   link   = Link,
   setter = Setter,
}
