local SubPath = (...):gsub('%.[^%.]+%.[^%.]+$', '')

local Class = require(SubPath..".class")

local Text = Class()
function Text:init(id)
   self.id      = id or tostring(os.time())
   self.text    = {}
   self.effects = {}
end

function Text:setText(index, text)
   self.text[index] = text
end

function Text:appendText(text)
   local index = #self.text + 1
   self.text[index] = text

   return index
end

function Text:appendEffect(index, effect)
   if not self.effects[index] then
      self.effects[index] = {}
   end

   self.effects[index][#self.effects[index] + 1] = effect
end

return Text
