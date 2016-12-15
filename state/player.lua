local Rainbow = require ('state.rainbow')
local Player = class('Player')

local rainbow = ""
local img = {  player = love.graphics.newImage("asset/image/sprite/player/player.png"),
               rainbow = love.graphics.newImage("asset/image/sprite/bullet/rainbow.png") }
local sprite = {}

function Player:initialize()
  for k,object in pairs (map.objects) do
    if object.name == "player" then
   sprite = object
     break
    end
  end
  self.x   = math.floor(sprite.x)
  self.y   = math.floor(sprite.y)
  self.img = img.player
  self.ox  = img.player:getWidth()/2
  self.oy  = 0
  self.width = img.player:getWidth()
  self.height = img.player:getHeight()
  self.boolJump = false
  self.jumpHeight = -300
  self.velocity_y = 0
  self.gravity = -850
  self.dir = 1
  self.on_ground = false
  self.boolJump = false
  self.creerRainbow = false
  self.list_rainbow = {}
world:add(self,self.x,self.y,self.width,self.height)
end


function Player:update(dt)
  self:move(dt)
  self:collision(dt)
end

function Player:move(dt)
    -- 96 pixel /second

  local speed = 96 
      if love.keyboard.isDown("right") then
      self.dir = 1
      self.x = self.x  + speed * dt
      end

      if love.keyboard.isDown("left") then
      self.dir = -1
      self.x = self.x - speed * dt
    end
    --Jump
      if love.keyboard.isDown("space") then
        if self.velocity_y == 0 then
          self.boolJump = true
          self.velocity_y = self.jumpHeight
        end
    end

      if love.keyboard.isDown("b") then
        -- autoriser le debug d'afficher le rainbow
        rainbow = Rainbow:new(self.x,self.y,self.dir)
        self.list_rainbow[#self.list_rainbow+1] = rainbow
        self.creerRainbow = true
        rainbow:add(self.width)
      end
      if not self.boolJump then 
        if self.velocity_y > 50 then
           self.velocity_y = 50
        else
          self.velocity_y = self.velocity_y - (self.gravity * dt)
        end
        self.y = self.y + self.velocity_y * dt
        end
      if self.velocity_y ~= 0 then
        if self.velocity_y > 100 then
           self.velocity_y = 100
        else
        self.velocity_y = self.velocity_y - (self.gravity * dt)
        end
        self.y = self.y + self.velocity_y * dt
      end
end

function Player:collision(dt)
  
    local playerFilter = function(item,other)
      if other.type == "solid" then return 'slide' end
      if other.type == "one_way" then return 'cross' end
      if other.type == "one_way_s" then return 'slide' end
      if other.type == "rainbow" then return 'slide' end
    end


    local goalX, goalY = self.x, self.y
    local actualX, actualY, cols, len = world:move(self,goalX, goalY,playerFilter)
    self.x,self.y = actualX, actualY

    for i = 1,len do
  
  if cols[i].other.type == "one_way_s"  then
    cols[i].other.type = "one_way"
  end
  
        if (cols[i].other.type == "one_way" and
            cols[i].normal.y == -1          and
            math.ceil(self.y + (self.height)) <= cols[i].other.y ) then 
            cols[i].other.type = "one_way_s" 
          self.velocity_y = 0
          self.boolJump = false
        elseif cols[i].other.type == "one_way" then
             cols[i].other.type = "one_way"
        end


        if (cols[i].other.type == "solid" and
            cols[i].normal.y == -1 ) or
           (cols[i].other.type == "rainbow" and
            cols[i].normal.y == -1 ) then
          self.velocity_y = 0
          self.boolJump = false
        end

--      for k,v in pairs (cols[i].other) do
--        print (k,v)
--      end
--print ('collided with' .. tostring(cols[i].other))
    end
   end


function Player:draw()
    local s = self
    love.graphics.draw(s.img,s.x,s.y,0,1,1,s.ox,s.oy)

    if self.creerRainbow then
      for n = 1,#s.list_rainbow do
        local r = s.list_rainbow[n]
        love.graphics.draw(r.img,r.x,r.y,0,1,1)
      end
    end

end

function Player:debug()
    self = nil
    if Player.creerRainbow then
      if rainbow ~= "" then
      self = {}
      self.list_rainbow = rainbow
      self.CreerRainbow = Player.CreerRainbow
      end
    end
    return self
end

return Player