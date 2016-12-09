local ennemy = {}

local img = {ennemy = love.graphics.newImage("asset/image/sprite/ennemy/ennemy.png")}

setmetatable (ennemy,{__add = function (t,other)
  new = {}
    for k,v in pairs(other) do
     new[k] = v
    end
  return new
end
})


for k,object in pairs(map.objects) do
     print(k,object)
  if object.name == "ennemy" then
    ennemy = ennemy + object
  end
end

ennemy.initialize = function (self)
self.sprite = {
  img         = img.ennemy,
  x           = ennemy.x,
  y           = ennemy.y,
  width       = img.ennemy:getWidth(),
  height      = img.ennemy:getHeight(),
  ox          = img.ennemy:getWidth()/2,
  oy          = img.ennemy:getHeight(),
  jumpHeight  = -300,
  velocity_y  = 0,
  dir         = 1,
  ground      = ennemy.y,
  boolJump    = false}
 table.insert(self.list_sprite,self.sprite)
 self.list_ennemy[#self.list_ennemy+1] = self.sprite -- same as table insert
 world:add(self.sprite,self.sprite.x,self.sprite.y-21,self.sprite.width,self.sprite.height)
 return self.sprite
end

ennemy.draw = function (self)
    local s = self.ennemy
    love.graphics.draw(s.img,s.x,s.y,0,1,1,s.ox,s.oy)
end

return ennemy