local Babble = require("babble")

local font = love.graphics.newFont("LCD_Solid.ttf", 25)
local font2 = love.graphics.getFont()

local count = 0

local d = Babble.dialogue()
   :addNode("start", function (node)
      return node
         :text("Hello World!\n\n", {explicit = true, font = font})
         :link("subpath")
         :text("Underlines work\n\n\n", {underline = true, font = font})
         :link("subpath")
   end)

   :addNode("subpath", function(node)
      return node
         :text("The time is: " ..love.timer.getTime()..".\n", {font = font2})
   end)

   :switch("start")

function love.update(dt)
   d:update(dt)
end

function love.draw()
   love.graphics.rectangle("line", 10, 460, 620, 170)
   love.graphics.setFont(font)
   d:draw(20, 470, 600, 150, false)

   local info = love.graphics.getStats()
   love.graphics.print(info.drawcalls)
end

function love.keypressed(key)
   last_pressed = key
   d:skip()
end
