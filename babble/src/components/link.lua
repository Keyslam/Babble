local SubPath = (...):gsub('%.[^%.]+%.[^%.]+$', '')

local Class = require(SubPath..".class")

local Link = Class()
function Link:init(node, func, ...)
   self.node = node
   local mt = getmetatable(func)
   if type(func) == "function" or mt and type(mt.__call) == "function" then
      self.func = func
      self.args = {..., n = select("#", ...)}
   elseif type(func) == "string" then
      self.link = func
   --[[
   else
      error("bad argument #1 to 'link' (function expected)", 3)
   ]]
   end
end

function Link:update(dt)
   if self.link then
      return self.link
   else
      return self.func(dt, unpack(self.args, 1, self.args.n)) or true
   end
end

return Link
