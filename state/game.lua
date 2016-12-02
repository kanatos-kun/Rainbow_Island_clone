local game = {}
game.load = function()
  
-- variable global
-- Charge image
local img = {
  player = love.graphics.newImage("asset/image/sprite/player/player.png")
  }
-- liste
local list_sprite = {}

map = sti("asset/map/map_test.lua")
local spriteLayer = map:addCustomLayer("Sprite Layer",3)

local player
for k,object in pairs (map.objects) do
  if object.name == "player" then
   player = object
   break
   end
end

-- Initialization des sprites
spriteLayer.player = {
  sprite = img.player,
  x      = player.x,
  y      = player.y,
  ox     = img.player:getWidth()/2,
  oy     = 0,
  width  = img.player:getWidth(),
  height = img.player:getHeight(),
  }


spriteLayer.update = function(self,dt)
-- 96 pixel /second
local speed = 96 
print(dt)
    if love.keyboard.isDown("right") then
    self.player.x = self.player.x  + speed * dt
    end

    if love.keyboard.isDown("left") then
    self.player.x = self.player.x - speed * dt
    end

    if love.keyboard.isDown("up") then
    self.player.y = self.player.y - speed * dt
    end

    if love.keyboard.isDown("down") then
    self.player.y = self.player.y + speed * dt
    end

end

spriteLayer.draw = function(self)
  local s = self.player
  love.graphics.draw(s.sprite,s.x,s.y,0,1,1,s.ox,s.oy)
end

map:removeLayer("objet")

end



game.update = function(dt)
  map:update(dt)
end


game.draw = function()
  map:draw()
end


game.keypressed = function()

end


return game