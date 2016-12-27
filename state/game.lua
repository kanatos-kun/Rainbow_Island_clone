local game = {}
game = gamestate.new()
--game = gamestate.new()
--module
local customlayer = require("state.customlayer")
local collision = require("state.collision")
local level = require("state.level")
game.id = 1
-- variable global

function game:init()
print("vous êtes dans le jeu")

level.load()
customlayer.load(game.id)
collision.load()
game.id = level.id
map:removeLayer("objet")

end

function game:change(dt)
  if level.id ~= game.id then
  customlayer.load(level.id)
  collision.reinitialization()
  game.id = level.id
  map:removeLayer("objet")
  end
end

function game:update(dt)
  level.update(dt)
  game:change(dt)
  debug.update(dt)
end


function game:draw()
  level.draw()
  debug.draw()
end

function game:keypressed(key)
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