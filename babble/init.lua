local Path = (...):gsub('%.init$', '')

local Babble = {}

Babble.class      = require(Path..".src.class")
Babble.components = require(Path..".src.components")
Babble.node       = require(Path..".src.node")
Babble.dialogue   = require(Path..".src.dialogue")

return Babble
