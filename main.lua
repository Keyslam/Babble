local Babble = require("babble")

local last_pressed = nil
preference = nil

local d = Babble.dialogue()
   :startNode("start")
      :print("Hello and welcome to Burber Burb")
      :print("Do you like [c]hocolate or [s]trawberry?")

      :script(function()
         if last_pressed == "c" then
            preference = "chocolate"
            return true
         elseif last_pressed == "s" then
            preference = "strawberry"
            return true
         end
      end)

      :link(function()
         return preference == "chocolate" and "likes_chocolate" or "likes_strawberry"
      end)

      :print('Eat as much as you want!')
   :endNode()

   :startNode("likes_chocolate")
      :print("But you'll get pimples!")
   :endNode()

   :startNode("likes_strawberry")
      :print("Strawberry is really nice, yeah.")
   :endNode()

   :switch("start")

function love.update(dt)
   d:update(dt)
end

function love.draw()
   d:draw()
end

function love.keypressed(key)
   last_pressed = key
end
