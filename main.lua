local Babble = require("babble")

local font = love.graphics.newFont("LCD_Solid.ttf", 25)

local count = 0

local d = Babble.dialogue()
   :addNode("start", function (node)
      return node:wait(2)
         :text("My dialogue system is coming along nicely.\n"):wait()
         :text("It has got"):wait():text("."):wait():text("."):wait():text("."):wait():text(" pauses.\n"):wait()
         :text("C", nil,  {color = {255,   0,   0}})
         :text("o", nil,  {color = {  0, 255,   0}})
         :text("l", nil,  {color = {  0,   0, 255}})
         :text("o", nil,  {color = {255,   0,   0}})
         :text("r", nil,  {color = {  0, 255,   0}})
         :text("e", nil,  {color = {  0,   0, 255}})
         :text("d ", nil, {color = {255,   0,   0}})
         :text("t", nil,  {color = {  0, 255,   0}})
         :text("e", nil,  {color = {  0,   0, 255}})
         :text("x", nil,  {color = {255,   0,   0}})
         :text("t", nil,  {color = {  0, 255,   0}})
         :text("!\n"):wait()
         :text("And much more!\n")
         :text("a\na\na\na\n")
   end)

   :switch("start")

function love.update(dt)
   d:update(dt)
end

function love.draw()
   love.graphics.setFont(font)
   love.graphics.rectangle("line", 10, 460, 620, 170)
   d:draw(20, 470, 600, 150)
end

function love.keypressed(key)
   last_pressed = key
end
