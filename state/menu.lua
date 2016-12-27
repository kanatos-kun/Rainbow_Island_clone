local menu = {}
menu = gamestate.new()

local choice = 1
local maxChoice = 2


function menu:init()
  print("vous êtes dans le menu")
end

local function color(string)
  if string == "blanc" then
    love.graphics.setColor(255,255,255)
  end
  
  if string == "gris" then
    love.graphics.setColor(140,140,140)
  end

end

function menu:update(dt)
end

function menu:draw()

  if choice == 1 then
  color("blanc")
  else
  color("gris")
  end

  love.graphics.print("new game",largeur/2 - 50,hauteur/2)
  if choice == 2 then
  color("blanc")
  else
  color("gris")
  end
  love.graphics.print("quit",largeur/2 - 50,hauteur/2 + 30)
end

function menu:keypressed(key)
  if key == "down" then

    if choice ~= maxChoice then
    choice = choice + 1
    else
    choice = 1
    end
   
 end

  if key == "up" then
    
    if choice ~= 1 then
      choice = choice - 1
    else
      choice = maxChoice
    end
    
 end
 
  if key == "return" then

    if choice == 1 then
      gamestate.switch(game)
    elseif choice == 2 then
      love.event.quit( )
      print("quit game")
    end

  end


end

return menu