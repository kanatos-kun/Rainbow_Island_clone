local Rainbow = class('Rainbow')
local Bullet = class('Bullet')
local widthJoueur = 0
local img = { rainbow = love.graphics.newImage("asset/image/sprite/bullet/rainbow.png"),
              bullet  = love.graphics.newImage("asset/image/sprite/bullet/bullet.png"),
            }

  function Rainbow:initialize(pX,pY,pDir)
    self.bullet = Bullet:new(pX,pY-3,pDir)
    self.pos = vector(pX,pY - 3)
    self.img = img.rainbow
    self.width = img.rainbow:getWidth()
    self.height = img.rainbow:getHeight()
    self.ox = img.rainbow:getWidth()/2
    self.oy = 0
    self.dir = pDir
    self.display = false
    self.rainbowCross = false
    self.detect = {
      pos = vector(self.pos.x + self.width /2 ,self.pos.y),
      ancienPos = vector(self.pos.x + self.width /2 ,self.pos.y),
      width = 2,
      height = 2,
      ["type"] = "rainbow_detector",
    }
    self.detect2 = {
      pos = vector(self.pos.x,self.pos.y),
      ancienPos = vector(self.pos.x,self.pos.y),
      width = 2,
      height = 2,
      ["type"] = "rainbow_detector2",
      }
    self.chrono = 1000
    self.type = "rainbow"
  end
  
  function Rainbow:update(dt)
    if self.display then
      self:collision(dt)
    end
  end
  
  function Rainbow:collision(dt)
    local rainbowFilter = function(item,other)
      if other.type == "rainbow" then return 'cross' end
      if other.type == "on_rainbow" then return 'cross' end
      if other.type == "player" then return 'cross' end
    end
      local goalX,goalY = self.pos.x,self.pos.y
      local actualX,actualY,cols,len = world:move(self,goalX,goalY,rainbowFilter)
      self.pos.x,self.pos.y = actualX,actualY
      
      for i = 1, #cols do
        local cols = cols[i]
        
        if cols.other.type == "rainbow" or cols.other.type == "on_rainbow" then
          self.rainbowCross = true
        end
        
        if cols.other.type == "player" and cols.normal.x == 1 then -- || < player
          -- detect 1
       --   self.detect.pos = self.detect.ancienPos
       --   self.detect.pos.x = (self.detect.pos.x - self.width) - widthJoueur - 4
          -- detect 2
        --  self.detect2.pos = self.detect2.ancienPos
        --  self.detect2.pos.x = (self.detect2.pos.x - widthJoueur) - self.detect2.width
       --   world:update(self.detect,self.detect.pos.x,self.detect.pos.y,self.detect.width,self.detect.height)
        --  world:update(self.detect2,self.detect2.pos.x,self.detect2.pos.y,self.detect2.width,self.detect2.height)
        end
        
        if cols.other.type == "player" and cols.normal.x == -1 then --  player > || 
          -- detect 1
        --  self.detect.pos = self.detect.ancienPos
         -- self.detect.pos.x = (self.detect.pos.x + widthJoueur) + 4
          -- detect 2
        --  self.detect2.pos.x = (self.detect2.pos.x + widthJoueur)
        --  self.detect2.pos.x = (self.detect2.pos.x - widthJoueur) - self.detect2.width
        --  world:update(self.detect,self.detect.pos.x,self.detect.pos.y,self.detect.width,self.detect.height)
        --  world:update(self.detect2,self.detect2.pos.x,self.detect2.pos.y,self.detect2.width,self.detect2.height)
        end
      end
      
    end
  
  function Rainbow:add(pW)
  self.display = true
  widthJoueur = pW
    if self.dir == 1 then
   self.pos.x = (self.pos.x + pW)
   self.detect.pos.x = (self.detect.pos.x + pW) + 4
   self.detect2.pos.x = (self.detect2.pos.x + pW)
   self.bullet.vec.x = -self.width/2 + self.bullet.width 
   self.bullet.vec.y = -self.bullet.height
   self.bullet.pos.x = self.bullet.pos.x + pW 
   self.bullet.pos.y = self.bullet.pos.y + self.height - self.bullet.height
    else
  self.pos.x = (self.pos.x - self.width) - pW 
  self.detect.pos.x = (self.detect.pos.x - self.width) - pW - 4
  self.detect2.pos.x = (self.detect2.pos.x - pW) - self.detect2.width
  self.bullet.vec.x = self.width/2 - self.bullet.width 
  self.bullet.vec.y = -self.bullet.height
  self.bullet.pos.x = self.bullet.pos.x - pW 
  self.bullet.pos.y = self.bullet.pos.y + self.height - self.bullet.height
end
  world:add(self,self.pos.x +100,self.pos.y,self.width,self.height)
  world:add(self.detect,self.detect.pos.x,self.detect.pos.y,self.detect.width,self.detect.height)
  world:add(self.detect2,self.detect2.pos.x,self.detect2.pos.y,self.detect2.width,self.detect2.height)
  world:add(self.bullet,self.bullet.pos.x,self.bullet.pos.y,self.bullet.width,self.bullet.height)
  debug.initialize()
  end
  
  --=============================================================
  --                        [BULLET]
  --=============================================================
  
  function Bullet:initialize(pX,pY,pDir)
    self.vec = vector(0,0)
    self.pos = vector(pX,pY)
    self.img = img.bullet
    self.width = img.bullet:getWidth()
    self.height = img.bullet:getHeight()
    self.ox = img.bullet:getWidth()/2
    self.oy = 0
    self.rotation = 0
    self.dir = pDir
    self.type = "bullet"
    self.display = true
  end

  --==============================================================
  --                    [ENNEMY_WALL]
  --==============================================================

  
return Rainbow