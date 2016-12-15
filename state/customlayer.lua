local customlayer = {} 

customlayer.load = function()

  --module
  local ennemy  = require "state.ennemy"
  local player = require "state.player"

  local spriteLayer = map:addCustomLayer("Sprite Layer",3)
  
  --Initialization des sprites----------------------------
  spriteLayer.player = player:new()
  spriteLayer.ennemy = ennemy:new()
  --------------------------------------------------------
  spriteLayer.update = function(self,dt)
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