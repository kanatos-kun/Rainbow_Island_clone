local customlayer = {} 
local id = 1

customlayer.load = function(pId)

  --module
  local ennemy  = require "state.ennemy"
  local player = require "state.player"

  local spriteLayer = map:addCustomLayer("Sprite Layer",4)
  
  spriteLayer.reinitialization = function()
 -- world:remove(spriteLayer.player)
  spriteLayer.player = {}
  spriteLayer.ennemy = {}
  end

  if pId ~= id then
    print("reinitialisation")
     spriteLayer.reinitialization()
     id = pId
  end
  
  --Initialization des sprites----------------------------
  spriteLayer.player = player:new(pId)
  spriteLayer.ennemy = ennemy:new(pId)
  --------------------------------------------------------

  
  spriteLayer.update = function(self,dt)
    if spriteLayer.player.finDeLevel == true then
    print("finDeLevel")
    if spriteLayer.player.list_rainbow ~= 0 then
      for n =  #spriteLayer.player.list_rainbow,1,-1 do
        local r = spriteLayer.player.list_rainbow
        world:remove(r,n)
        table.remove(r,r[n])
      end
      world:remove(spriteLayer.player)
    end

 end
   self.player:update(dt)

 -- for n = 1,#self.ennemy do
  self.ennemy:update(dt)
  --end
  end



  spriteLayer.draw = function(self)
    self.ennemy:draw()
    self.player:draw()
  end

  customlayer.debug = function(self)
  self = {}
  self.player = spriteLayer.player
  self.list_ennemy = spriteLayer.ennemy
  return self
  end
end




return customlayer