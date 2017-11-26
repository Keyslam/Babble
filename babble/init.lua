local Path = (...):gsub('%.init$', '')

local Namespace = require(Path..".src.namespace")

Namespace.class = require(Path..".lib.middleclass")

Namespace.components = require(Path..".src.components")
Namespace.node       = require(Path..".src.node")
Namespace.dialogue   = require(Path..".src.dialogue")
Namespace.condition  = require(Path..".src.condition")

return Namespace
