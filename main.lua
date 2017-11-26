local Babble = require("babble")

myVar = 8

--[[
Babble.dialogue()
   :addNode("start")
      :text("Hello world"):endl()
      :text("My name is ")
      :pause(1)
      :setColor(225, 30, 30)
      :text("Mr. Poopy butthole"):endl()
      :setColor()
      :text("But you can call me Dave."):endl()
      :link("askRepeat")

   :addNode("askRepeat")
      :text("Would you like me to repeat that?")
      :link("start")
]]

local d = Babble.dialogue()
   :startNode("start")
      :print("Hello")
      :script(function(node, dt, args)
         print(node)
         print(dt)
         print(args.a + args.b)

         return true
      end, {a = 100, b = 50})
      :pause(1)
      :print("World")
   :endNode()

--[[
   :addNode("start", {})
      :text("Hello world"):endl()
      :text("My name is ")
      :pause(1)
      :setColor(225, 30, 30)
      :text("Mr. Poopy butthole"):endl()
      :setColor()
      :text("But you can call me Dave.")
]]

function love.update(dt)
   d:update(dt)
end

function love.draw()
   d:draw()
end
