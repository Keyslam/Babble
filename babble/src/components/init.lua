local Path = (...):gsub('%.init$', '')

local Components = {}

Components.link   = require(Path..".link")
Components.print  = require(Path..".print")
Components.script = require(Path..".script")
Components.setter = require(Path..".setter")
Components.text   = require(Path..".text")
Components.wait   = require(Path..".wait")

return Components
