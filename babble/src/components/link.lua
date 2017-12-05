local SubPath = (...):gsub('%.[^%.]+%.[^%.]+$', '')

local Class = require(SubPath..".class")

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

local Link = Class()
function Link:init(node, func, ...)
   self.node = node
   if isCallable(func) then
      self.func = func
      self.args = {..., n = select("#", ...)}
   elseif type(func) == "string" then
      self.link = func
   else
      error("bad argument #1 to 'link' (function or string expected)", 3)
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
