local Fruit = class('Fruit')

function Fruit:initialize()
print ("ceci est un fruit")
end

Fruit.print = function()
  print ("cela marche")
end

return Fruit