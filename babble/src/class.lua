return function()
   local class = {}
   class.init  = function(obj) end
   class.mt    = {__index = class}

   return setmetatable(class, {
      __call = function(_, ...)
         local obj = setmetatable({}, class.mt)
         class.init(obj, ...)
         return obj
      end
   })
end
