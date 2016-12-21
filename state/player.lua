local Rainbow = require ('state.rainbow')
local Player = class('Player')

local rainbow = ""
local img = {  player = love.graphics.newImage("asset/image/sprite/player/player.png"),
}
local sprite = {}

function Player:initialize()
  for k,object in pairs (map.objects) do
    if object.name == "player" then
   sprite = object
     break
    end
  end
  self.pos   = vector(math.floor(sprite.x),math.floor(sprite.y))
  self.vec  = vector(0,0)
  self.img = img.player
  self.ox  = img.player:getWidth()/2
  self.oy  = 0
  self.width = img.player:getWidth()
  self.height = img.player:getHeight()
  self.jumpHeight = -300
  self.velocity_y = 0
  self.gravity = -850
  self.dir = 1
  self.type = "player"
  self.on_ground = false
  self.boolJump = false
  self.creerRainbow = false
  self.boolJump = false
  self.createNewRainbow = true
  self.onRainbow = false
  self.isStop = false
  self.descenteRainbow1 = false
  self.descenteRainbow2 = false
  self.theresRainbow = false
  self.list_rainbow = {}
  self.detect = {
    pos = self.pos - vector(0,self.height/2),
    width = 2,
    height = 2,
  }
world:add(self.detect,self.detect.pos.x,self.detect.pos.y,self.detect.width,self.detect.height)
world:add(self,self.pos.x,self.pos.y,self.width,self.height)
end

function Player:update(dt)
  self:move(dt)
  self:collision(dt)
  self:rainbowClimb(dt)

  if self.creerRainbow then
    for i = 1,#self.list_rainbow do
     local r = self.list_rainbow[i]
     r:update(dt)
    end
  end

end

function Player:move(dt)
    -- 96 pixel /second
    --Mouvement du joueur
  local speed = 96 
      if love.keyboard.isDown("right") and not self.isStop then
      self.dir = 1
      self.pos.x = self.pos.x  + speed * dt
      end

      if love.keyboard.isDown("left") and not self.isStop then
      self.dir = -1
      self.pos.x = self.pos.x - speed * dt
    end
    
    --update detector 
    if self.dir == 1 then
    self.detect.pos = self.pos + vector(25,self.height/2)
    elseif self.dir == -1 then
    self.detect.pos = self.pos - vector(25,0) + vector(0,self.height/2)
    end
  world:update(self.detect,self.detect.pos.x,self.detect.pos.y,self.detect.width,self.detect.height)

    --Jump
      if love.keyboard.isDown("space") then
        if self.velocity_y == 0 then
          self.boolJump = true
          self.velocity_y = self.jumpHeight
        end
    end

      if love.keyboard.isDown("b") then
        -- autoriser le debug d'afficher le rainbow
        if self.createNewRainbow then
          rainbow = Rainbow:new(self.pos.x,self.pos.y,self.dir)
          self.list_rainbow[#self.list_rainbow+1] = rainbow
          self.creerRainbow = true
          self.createNewRainbow = false
          rainbow:add(self.width)
        end
      end

     for n = 1,#self.list_rainbow do
     local r = self.list_rainbow[n]

      if r.bullet.display then
         if r.dir == 1 then
          r.bullet.vec:rotateInplace(1/10)
          local dy,dx = r.bullet.vec:rotateInplace(1/100):unpack()
      -- si "angle" = {(0°) or(2pi)} alors bullet_display = false()
      -- Les angles pour les bullet du joueur
          if dx > -8 and dy > 10 then
            r.bullet.display = false
            self.createNewRainbow = true
            world:remove(r.bullet)
          else
          r.bullet.pos.x = r.bullet.pos.x + dx / -(math.pi *2)
          r.bullet.pos.y = r.bullet.pos.y + dy / (math.pi *2)
          world:update(r.bullet,r.bullet.pos.x,r.bullet.pos.y,r.bullet.width,r.bullet.height)
          end
          end
        if r.dir == -1 then
          r.bullet.vec:rotateInplace(-1/10)
          local dy,dx = r.bullet.vec:rotateInplace(-1/100):unpack()
          -- si "angle" = {(180°) or (pi)} alors bullet_display = false()
          if dx > -8 and dy < -10 then 
            r.bullet.display = false
            self.createNewRainbow = true
            world:remove(r.bullet)
          else
          r.bullet.pos.x = r.bullet.pos.x + dx / (math.pi * 2)
          r.bullet.pos.y = r.bullet.pos.y + dy / -(math.pi * 2)
          world:update(r.bullet,r.bullet.pos.x,r.bullet.pos.y,r.bullet.width,r.bullet.height)
          end
        end
      end

   end
-- agir la gravité lorsque le joueur tombe
      if not self.boolJump and not self.onRainbow then 
        if self.velocity_y > 50 then
           self.velocity_y = 50
        else
          self.velocity_y = self.velocity_y - (self.gravity * dt)
        end
        self.pos.y = self.pos.y + self.velocity_y * dt
      end

      if self.velocity_y ~= 0 then
        if self.velocity_y > 100 then
           self.velocity_y = 100
        else
        self.velocity_y = self.velocity_y - (self.gravity * dt)
        end
        self.pos.y = self.pos.y + self.velocity_y * dt
      end
end

local temp = 0
local chrono = 30
local up = 8
local montee = false

--La fonction rainbowClimb pour faire monter le hero dans un arc-en-ciel
function Player:rainbowClimb(dt)
  local circle = {}
  for i = 1,36 do
    local phi = 2 * math.pi * i / 36
    circle[#circle+1] = self.vec:rotated(phi)
   -- print(circle[8])
  end
  if self.theresRainbow then
    up = 8
    montee = false
  end
  if self.onRainbow and not self.theresRainbow then
    chrono = chrono - 25

      if  chrono < 0  and self.dir == 1 then
        chrono = 30
      if up < 18 and (not self.descenteRainbow1 and not self.descenteRainbow2)
        and self.onRainbow then
        self.isStop = true
        local dx,dy = circle[up]:unpack()
        self.pos.x = self.pos.x + dx / (math.pi * 5)
        self.pos.y = self.pos.y + dy / (math.pi * 5)
        up = up + 1
      elseif self.descenteRainbow1 and up < 28 and montee then
        self.isStop = true
        local dx,dy = circle[up]:unpack()
        self.pos.x = self.pos.x + dx / (math.pi * 5)
        self.pos.y = self.pos.y + dy / (math.pi * 5)
        up = up + 1
      elseif self.descenteRainbow2 and up > 7 and montee then
        self.isStop = true
        local dx,dy = circle[up]:unpack()
        self.pos.x = self.pos.x - dx / (math.pi * 5)
        self.pos.y = self.pos.y + dy / (math.pi * 5)
        print(up)
        up = up - 1
      else
        self.isStop = false
        montee = true
      end
    end


     if  chrono < 0  and self.dir == -1 then
        chrono = 30
      if up < 18 and (not self.descenteRainbow1 and not self.descenteRainbow2 )
        and self.onRainbow then
        self.isStop = true
        local dx,dy = circle[up]:unpack()
        self.pos.x = self.pos.x + dx / (math.pi * 5)
        self.pos.y = self.pos.y + dy / -(math.pi * 5)
        up = up + 1
      elseif self.descenteRainbow1 and up < 28 and montee then
        self.isStop = true
          local dx,dy = circle[up]:unpack()
          self.pos.x = self.pos.x + dx / (math.pi * 5)
          self.pos.y = self.pos.y + dy / -(math.pi * 5)
        up = up + 1
      elseif self.descenteRainbow2 and up > 7 and montee then
        self.isStop = true
        print(up)
          local dx,dy = circle[up]:unpack()
          self.pos.x = self.pos.x - dx / (math.pi * 5)
          self.pos.y = self.pos.y + dy / -(math.pi * 5)
          up = up - 1
      else
        self.isStop = false
        montee = true
      end
    end

        if up == 28 then 
          self.descenteRainbow1 = false
          self.isStop = false
          self.onRainbow = false
          montee = false
          up = 8 
        end
        if self.descenteRainbow2 and up <= 8 then
        self.descenteRainbow2 = false
        self.isStop = false
        self.onRainbow = false
        montee = false
        up = 8
        end
  end
  

end

function Player:collision(dt)

    local playerFilter = function(item,other)
      if other.type == "solid" then return 'slide' end
      if other.type == "one_way" then return 'cross' end
      if other.type == "one_way_s" then return 'slide' end
      if other.type == "rainbow" then return 'cross' end
      if other.type == "on_rainbow" then return 'cross' end
      if other.type == "rainbow_detector" then return 'cross' end
      if other.type == "rainbow_detector2" then return 'cross' end
    end

    local goalX, goalY = self.pos.x, self.pos.y
    local actualX, actualY, cols, len = world:move(self,goalX, goalY,playerFilter)
    self.pos.x,self.pos.y = actualX, actualY

    for i = 1,len do
  
  if cols[i].other.type == "one_way_s"  then
     cols[i].other.type = "one_way"
  end
  
        if (cols[i].other.type == "one_way" and
            cols[i].normal.y == -1          and
            math.ceil(self.pos.y + (self.height)) <= cols[i].other.y ) then 
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

      if cols[i].other.type == "rainbow" then

          if cols[i].normal.x == 1 then
           -- print("collision avec normal.x en 1 : "..temp)
            cols[i].other["type"] = "on_rainbow"
            self.onRainbow = true


          if cols[i].other.dir == 1 then 
          -- detect 2
          cols[i].other.detect2.pos = cols[i].other.detect2.ancienPos
          cols[i].other.detect2.pos.x = (cols[i].other.detect2.pos.x + self.width) + cols[i].other.width - cols[i].other.detect2.width
           -- detect 1
          cols[i].other.detect.pos = cols[i].other.detect.ancienPos
          cols[i].other.detect.pos.x = cols[i].other.detect.pos.x + self.width/2
          elseif cols[i].other.dir == -1 then
            
          -- detect 2
          cols[i].other.detect2.pos = cols[i].other.detect2.ancienPos
          cols[i].other.detect2.pos.x = (cols[i].other.detect2.pos.x - self.width) - cols[i].other.detect2.width
          -- detect 1
          cols[i].other.detect.pos =  cols[i].other.detect.ancienPos
          cols[i].other.detect.pos.x = (cols[i].other.detect.pos.x - cols[i].other.width) - self.width - 4

          end

          world:update(cols[i].other.detect,cols[i].other.detect.pos.x,cols[i].other.detect.pos.y,cols[i].other.detect.width,cols[i].other.detect.height)
          world:update(cols[i].other.detect2,cols[i].other.detect2.pos.x,cols[i].other.detect2.pos.y,cols[i].other.detect2.width,cols[i].other.detect2.height)
            self.vec.x =   cols[i].other.width + 8--- self.width
            self.vec.y =   cols[i].other.height - 16--- self.height
            temp = temp + 1
          end



          if cols[i].normal.x == -1 then
            --print("collision avec normal.x en -1 : "..temp)
            cols[i].other["type"] = "on_rainbow"
            self.onRainbow = true

          if cols[i].other.dir == 1 then
          -- detect 2
          cols[i].other.detect2.pos = cols[i].other.detect2.ancienPos
          cols[i].other.detect2.pos.x = (cols[i].other.detect2.pos.x + self.width)
          -- detect 1
          cols[i].other.detect.pos = cols[i].other.detect.ancienPos
          cols[i].other.detect.pos.x = (cols[i].other.detect.pos.x + self.width) + 4
          elseif cols[i].other.dir == -1 then
        -- detect 2
            cols[i].other.detect2.pos = cols[i].other.detect2.ancienPos
            cols[i].other.detect2.pos.x = (cols[i].other.detect2.pos.x - self.width) - ( cols[i].other.width)
        -- detect 1
            cols[i].other.detect.pos =  cols[i].other.detect.ancienPos
            cols[i].other.detect.pos.x = (cols[i].other.detect.pos.x - cols[i].other.width) - self.width

          end


          world:update(cols[i].other.detect,cols[i].other.detect.pos.x,cols[i].other.detect.pos.y,cols[i].other.detect.width,cols[i].other.detect.height)
          world:update(cols[i].other.detect2,cols[i].other.detect2.pos.x,cols[i].other.detect2.pos.y,cols[i].other.detect2.width,cols[i].other.detect2.height)
            self.vec.x =   -cols[i].other.width - 8--- self.width
            self.vec.y =   cols[i].other.height - 32--- self.height
            temp = temp + 1
          end
      end

          if cols[i].other.type == "rainbow_detector" and montee then
          --print("detection")
          self.descenteRainbow1 = true
          self.descenteRainbow2 = false
        elseif cols[i].other.type == "rainbow_detector2" and montee then
          self.descenteRainbow2 = true
          self.descenteRainbow1 = false
        end

--      for k,v in pairs (cols[i].other) do
--        print (k,v)
--      end
--    print ('collided with' .. tostring(cols[i].other))
  end

    local detectorFilter = function(item,other)
      if other.type == "solid" then return 'slide' end
      if other.type == "one_way" then return 'cross' end
      if other.type == "one_way_s" then return 'slide' end
      if other.type == "rainbow" then return 'cross' end
      if other.type == "on_rainbow" then return 'cross' end
      if other.type == "rainbow_detector" then return 'cross' end
      if other.type == "rainbow_detector2" then return 'cross' end
    end
--detector collision
    local goalX, goalY = self.detect.pos.x, self.detect.pos.y
    local actualX, actualY, cols, len = world:move(self.detect,goalX, goalY,detectorFilter)
    self.detect.pos.x,self.detect.pos.y = actualX,actualY
    self.theresRainbow = false
    for i = 1,len do
      
      if cols[i].other.type == "rainbow" then
        self.theresRainbow = true
      else
        self.theresRainbow = false
      end
    end

   end



function Player:draw()
    local s = self
    love.graphics.draw(s.img,s.pos.x,s.pos.y,0,1,1,s.ox,s.oy)

    if self.creerRainbow then
      for n = 1,#s.list_rainbow do
        local r = s.list_rainbow[n]
        local b = s.list_rainbow[n].bullet
        love.graphics.translate(r.pos.x + r.width/2,r.pos.y + r.height)
        if b.display then
        love.graphics.draw(b.img,b.vec.x,b.vec.y,0,1,1)
        end
        love.graphics.translate(-r.pos.x - r.width/2,-r.pos.y - r.height)
        love.graphics.setColor(0,0,255,200)
        love.graphics.draw(r.img,r.pos.x - s.width/2,r.pos.y,0,1,1)
        love.graphics.setColor(255,255,255,255)
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