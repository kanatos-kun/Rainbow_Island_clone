
local init = gamestate.new()
local game = gamestate.new()
local menu = gamestate.new()

function init:init()
  gamestate.registerEvents()
end

return init