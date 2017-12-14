local SubPath = (...):gsub('%.[^%.]+%.[^%.]+$', '')

local Class = require(SubPath..".class")

local Text = Class()
function Text:init(id)
   self.id        = id or tostring(os.time())
   self.text      = {}
   self.modifiers = {}
end

function Text:setText(index, text)
   self.text[index] = text
end

function Text:appendText(text)
   local index = #self.text + 1
   self.text[index] = text

   return index
end

function Text:setModifier(index, name, value)
   if not self.modifiers[index] then
      self.modifiers[index] = {}
   end

   self.modifiers[index][name] = value
end

return Text
