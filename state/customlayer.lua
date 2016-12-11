local customlayer = {} 

customlayer.load = function()
-- Charge image
  local img = {ennemy = love.graphics.newImage("asset/image/sprite/ennemy/ennemy.png")}

  local ennemy  = require "state.ennemy"


  local spriteLayer = map:addCustomLayer("Sprite Layer",3)
  
  --Variable global
   spriteLayer.gravity = -850
   spriteLayer.list_sprite = {}
   spriteLayer.list_ennemy = ennemy.list_ennemy
  -- Put all function for spriteLayer---------------------

--===========================================
--           player-collision
--===========================================
  customlayer.movePlayer = function(player,dt)
    local playerFilter = function(item,other)
      if other.type == "solid" then return 'slide' end
      if other.type == "one_way" then return 'cross' end
      if other.type == "one_way_s" then return 'slide' end
    end
    
    local locPlayer = spriteLayer.player
    local goalX, goalY = locPlayer.x, locPlayer.y
    local actualX, actualY, cols, len = world:move(locPlayer,goalX, goalY,playerFilter)
    locPlayer.x,locPlayer.y = actualX, actualY

    for i = 1,len do
  
  if cols[i].other.type == "one_way_s"  then
    cols[i].other.type = "one_way"
  end
  
        if (cols[i].other.type == "one_way" and
            cols[i].normal.y == -1          and
            math.ceil(locPlayer.y + (locPlayer.height)) <= cols[i].other.y ) then 
            cols[i].other.type = "one_way_s" 
          locPlayer.velocity_y = 0
          locPlayer.boolJump = false
        elseif cols[i].other.type == "one_way" then
             cols[i].other.type = "one_way"
        end


        if cols[i].other.type == "solid" and
            cols[i].normal.y == -1  then
          locPlayer.velocity_y = 0
          locPlayer.boolJump = false
        end

--      for k,v in pairs (cols[i].other) do
--        print (k,v)
--      end
      --print ('collided with' .. tostring(cols[i].other))
    end
   end
  --------------------------------------------------------
  local  player = require "state.player"
  
  --Initialization des sprites----------------------------
  spriteLayer.player = player.initialize(spriteLayer)
 -- spriteLayer.ennemy = ennemy.initialize(spriteLayer)
  --------------------------------------------------------
  spriteLayer.update = function(self,dt)
  player.update(self,dt)
  customlayer.movePlayer(spriteLayer.player,dt)
  end

  spriteLayer.draw = function(self)
    player.draw(self)
    ennemy.draw(self)
  end

customlayer.debug = function(self)
self = {}
self.player = spriteLayer.player
self.list_sprite = spriteLayer.list_sprite
self.list_ennemy = spriteLayer.list_ennemy
self.gravity = spriteLayer.gravity
return self
end

end


return customlayer