local Path = (...):gsub('%.init$', '')

local Contents = {}

Contents.text = require(Path..".text")

return Contents
