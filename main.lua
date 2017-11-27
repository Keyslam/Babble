local Babble = require("babble")

preference = nil

local d = Babble.dialogue()
   :startNode("start")
      :print("Hello and welcome to Burber Burb")
      :print("Do you like chocolate or strawberry?")

      :setter(_G, "preference", "chocolate") -- Replaced by a option later

      :link(function()
         return preference == "chocolate" and "likes_chocolate" or "likes_strawberry"
      end, true) -- True so it will link back when done
   :endNode()

   :startNode("likes_chocolate")
      :print("But you'll get pimples!")
   :endNode()

   :startNode("likes_strawberry")
      :print("Strawberry is really nice, yeah.")
   :endNode()

function love.update(dt)
   d:update(dt)
end

function love.draw()
   d:draw()
end
