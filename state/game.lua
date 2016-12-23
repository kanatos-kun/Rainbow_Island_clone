local game = {}
--game = gamestate.new()
--module
local customlayer = require("state.customlayer")
local collision = require("state.collision")
-- variable global
local list_tile = {}
world = bump.newWorld(16)

game.load = function()

-- liste
local list_sprite = {}


map = sti("asset/map/map_test.lua", {"bump"})
customlayer.load()
collision.load()
map:bump_init(world)

map:removeLayer("objet")
end

game.tileInitialize = function(pX,pY,pW,pH,pType)
  tile = {
    x = pX,
    y = pY,
    width = pW,
    height = pH,
    ["type"] = pType,
  }
  table.insert(list_tile,tile)
end


game.update = function(dt)
  map:update(dt)
  debug.update(dt)
end


game.draw = function()
  map:draw()
  map:bump_draw()
  debug.draw()
end

game.keypressed = function(key)
debug.keypressed(key)
--Show debug in game screen
  if key == "x" then
    if debug.state then 
      debug.state = false
      else
      debug.state = true 
    end
  end

end


return game