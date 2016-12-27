local level = {}
local sprite = {}
local string = {"asset/map/level 1-1.lua",
"asset/map/level 1-2.lua",
"asset/map/level 1-3.lua"}
local id = 1
level.id = 1

level.load = function ()
world = bump.newWorld(16)
map = sti(string[id], {"bump"})
map:bump_init(world)
level.initialization()
end

level.change = function()
  if sprite.display == false then
  world:remove(sprite)
  sprite = {}
  end
map = sti(string[level.id],{"bump"})
level.initialization()
end

level.update = function(dt)
  map:update(dt)
  level.collision(dt)
end

level.initialization = function()
  for k,object in pairs(map.objects) do
    if object.name == "end" then
      sprite = object
      sprite.display = true
      break
    end
  end
  world:add(sprite,sprite.x,sprite.y,sprite.width,sprite.height)
end

level.collision = function(self,dt)

    if sprite.display then

    local  function levelFilter(item,other)
        if other.type == "player" then return 'cross' end
      end

      local goalX,goalY = sprite.x,sprite.y
      local actualX,actualY,cols,len = world:move(sprite,goalX,goalY,levelFilter)
      sprite.x,sprite.y = actualX,actualY
      
      for n = 1,#cols do
       local cols = cols[n]

       if cols.other.type == "player" then
        -- print("vous avez atteint le goal",id)
        cols.other.type = "player_fin"
         level.id = level.id + 1
         print ("changement")
         sprite.display = false
         level.change()
      end
    end

    end

end

level.draw = function() 
  map:draw()
end

return level