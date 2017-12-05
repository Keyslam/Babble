local Path = (...):gsub('%.[^%.]+$', '')

local Class = require(Path..".class")

local Content = Class()
function Content:init(id, color)
   self.id    = id
   self.text  = ""
   self.color = color or {255, 255, 255}
end

return Content
