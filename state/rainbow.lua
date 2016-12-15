local Rainbow = class('Rainbow')
  
local img = { rainbow = love.graphics.newImage("asset/image/sprite/bullet/rainbow.png")}
  
  function Rainbow:test()
    print("this is a test")
  end
  
  function Rainbow:initialize(pX,pY,pDir)
    self.x = pX
    self.y = pY - 3
    self.img = img.rainbow
    self.width = img.rainbow:getWidth()
    self.height = img.rainbow:getHeight()
    self.ox = img.rainbow:getWidth()/2
    self.dir = pDir
    self.display = false
    self.chrono = 1000
    self.type = "rainbow"
    self.oy = 0
  end
  
  function Rainbow:update(dt)
    
  end
  
  function Rainbow:add(pW)
  self.display = true
    if self.dir == 1 then
    self.x = (self.x + pW)
    else
    self.x = (self.x - self.width) - pW 
  end
  world:add(self,self.x+10,self.y,self.width,self.height)
  debug.initialize()
  end
  
  --[[
  function Rainbow:draw()
    local r = self
    if self.display then
      love.graphics.draw(r.img,r.x,r.y,0,1,1)
    end
  end ]]
  
  
  
return Rainbow