local player = {}
--player.__index = player
local img = {  player = love.graphics.newImage("asset/image/sprite/player/player.png")}

setmetatable (player,{__add = function (t,other)
    new = {}
      for k,v in pairs(other) do
        new[k] = v
      end
    return new
  end
})
  for k,object in pairs (map.objects) do
    if object.name == "player" then
   player = player + object
     break
    end
  end


player.initialize = function (self)
  self.sprite  = {
    img        = img.player,
    x          = player.x,
    y          = player.y,
    ox         = img.player:getWidth()/2,
    oy         = 0,
    width      = img.player:getWidth(),
    height     = img.player:getHeight(),
    jumpHeight = -300,
    velocity_y = 0,
    on_ground     = false,
    boolJump   = false }
    table.insert(self.list_sprite,self.sprite)
    world:add(self.sprite,self.sprite.x,self.sprite.y,self.sprite.width,self.sprite.height)
    return self.sprite
end


player.update = function(self,dt)
    -- 96 pixel /second
  local speed = 96 
      if love.keyboard.isDown("right") then
      self.player.x = self.player.x  + speed * dt
      end

      if love.keyboard.isDown("left") then
      self.player.x = self.player.x - speed * dt
    end
    --Jump
      if love.keyboard.isDown("space") then
        if self.player.velocity_y == 0 then
          self.player.boolJump = true
          self.player.velocity_y = self.player.jumpHeight
        end
    end
      
      
      if not self.player.boolJump then 
        if self.player.velocity_y > 50 then
           self.player.velocity_y = 50
        else
          self.player.velocity_y = self.player.velocity_y - (self.gravity * dt)
        end
        self.player.y = self.player.y + self.player.velocity_y * dt
        end

      if self.player.velocity_y ~= 0 then
        if self.player.velocity_y > 100 then
           self.player.velocity_y = 100
        else
        self.player.velocity_y = self.player.velocity_y - (self.gravity * dt)
        end
        self.player.y = self.player.y + self.player.velocity_y * dt

      end
      

end



player.draw = function(self)
    local s = self.player
    love.graphics.draw(s.img,s.x,s.y,0,1,1,s.ox,s.oy)
end


return player