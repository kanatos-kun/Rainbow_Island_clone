local Ennemy = class('Ennemy')

local img = {ennemy = love.graphics.newImage("asset/image/sprite/ennemy/ennemy.png")}
Ennemy.list_ennemy = {}
local sprite = {}


  for k,object in pairs(map.objects) do
    if object.name == "ennemy" then
      -- print(k,object)
      sprite = object
      table.insert(Ennemy.list_ennemy,sprite)
    end
  end

  function Ennemy:initialize()
    for n = #Ennemy.list_ennemy, 1,-1 do
      local sprite = Ennemy.list_ennemy[n]
      self[n] = {
      img = img.ennemy,
      pos = vector(sprite.x,sprite.y),
      width = img.ennemy:getWidth(),
      height = img.ennemy:getHeight(),
      ox = img.ennemy:getWidth()/2,
      oy = 0,
      jumpHeight = -300,
      gravity = -850,
      velocity_y = 0,
      dir = 1,
      sleep = false,
      ground = false,
      boolJump = false,
      no_collision = true,
      display = true,
      }
      world:add(self[n],self[n].pos.x,self[n].pos.y,self[n].width,self[n].height)
      end
  end

  function Ennemy:update(dt)
    self:move(dt)
    self:collision(dt)
    self:destroy(dt)
  end

function Ennemy:destroy(dt)

  for n = #self,1,-1 do
    local e = self[n]
    if not e.display then
    world:remove(e)
    table.remove(self,n)
    end
  end

end

  function Ennemy:move(dt)
    local speed = 32
    for n = 1, #self do
      local e = self[n]
      if not e.sleep then
-- movement
--========================================

      if e.ground then
     e.pos.x = e.pos.x + (speed * dt)* e.dir
      end

      if not e.boolJump then
        if e.velocity_y > 100 then
          e.velocity_y = 100 
        else
        e.velocity_y = e.velocity_y - (e.gravity * dt)
      end
        e.pos.y = e.pos.y + e.velocity_y * dt
      end

--========================================
    end

    end
  end
local trace = false


  function Ennemy:collision(dt)

 for n = 1, #self do
        local e = self[n]

      if e.display then 
            local function ennemyFilter(item,other)
              if other.type == "solid" then return 'slide' end
              if other.type == "one_way" then return 'slide' end
              if other.type == "one_way_s" then return 'slide' end
              if other.type == "change_direction" then return 'slide' end
              if other.type == "bullet" then return 'cross' end
              if other.type == "rainbow_bullet" then return 'cross' end
              end
      e.no_collision = true


       -- check further collision (not working)
      --[[
          local goalX,goalY = e.x,e.y
          local actualX,actualY, cols, len = world:check(e,goalX,goalY,ennemyFilter)
          --world:update(e,goalX+e.dir,goalY,e.width,e.height)
          for i = 1,len do
            local cols = cols[i]
      -- check if there void in the next move
            if cols.other.type == "solid"  and 
               cols.normal.y == -1        then
                if goalX > cols.other.x then
                 print("valeur goalX  : "..goalX,"valeur item.x  : "..cols.item.x)
                end
                e.no_collision = false
            end
          end

      if e.no_collision then
        e.dir = e.dir - (2*e.dir) 
      end
            print ("collision detected  "..tostring(e.no_collision))
      --world:update(e,goalX,goalY,e.width,e.height)
      --]]

      -- check instant collision
          local goalX,goalY = e.pos.x,e.pos.y
          local actualX,actualY, cols, len = world:move(e,goalX,goalY,ennemyFilter)
          e.pos.x,e.pos.y = actualX,actualY
          e.ground = false
          for i = 1,len do
            local cols = cols[i]

            if cols.other.type == "one_way_s" then
              cols.other.type = "one_way"
            end
            if cols.other.type == "change_direction" then
              e.dir = e.dir - (2*e.dir) 
            end
            if cols.other.type == "solid" or cols.other.type == "one_way" then
              if cols.normal.y == -1 then
              e.velocity_y = 0
              e.gravity_affect = false
              e.ground = true 
              elseif cols.normal.x == -1 then
                e.dir = -1
              elseif cols.normal.x == 1 then
                e.dir = 1
              end
--[[            elseif (cols.other.type == "one_way" and
               cols.normal.y == -1              and
                  math.ceil(e.pos.y + (e.height)) <= cols.other.y ) then
                 cols.other.type = "one_way_s"
                 e.velocity_y = 0
                 e.ground = true
            elseif cols.other.type == "one_way" then
                   cols.other.type = "one_way" --]]
            end 
            if (cols.other.type == "solid" or
               cols.other.type == "one_way" or
               cols.other.type == "one_way_s") and
               cols.normal.y == -1 then
            end
            if  (cols.other.type == "bullet" or
                cols.other.type == "rainbow_bullet") then
              e.display = false
            end
      end
      
    end
    
  end

end
  
  function Ennemy:draw()
    for n = #self,1,-1 do
      local s = self[n]
      love.graphics.draw(s.img,s.pos.x,s.pos.y,0,1,1,s.ox,s.oy)
    end
  end

return Ennemy