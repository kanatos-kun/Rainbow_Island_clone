--[[ 
=====================================================
touche : 
          a : "changer de choix"
          x : "activer le systéme de debogage"
          + : " incrementer les instances"
          - : decrémenter les instances"

====================================================
--]]


local debug = {}
local debug_collision  = require 'state.collision'
local debug_customlayer = require 'state.customlayer'

debug.state = false

debug[1] = {}  --CustomLayer information
debug[2] = {}  --Game information


debug.choice = {false,false,false,false,false} --global information set
local choice = 1 
--[[--------------------------------------------
==================CHOIX=========================
                1) Information global
                2) Information bump general
                3) Information Tile
                4) Information Player
                5) Information Ennemy
------------------------------------------------
]]
  debug.id = {
    ennemy = {},
    tile = {},
    option = {true,true}, -- option hide/show collision et disable/enable collision
  }

local id = 1
local idEnnemy = 1
local idTile = 1

debug.initialize = function()
  debug.load(debug_customlayer.debug(debug[1]),1)
  debug.load(debug_collision.debug(debug[2]),2)
  --update choice
    for i = 1,#debug.choice do
      debug.choice[i] = false
      if choice == i then
        debug.choice[i] = true
      end
    
    end

  --initialize Numero id 
  --ennemy
      for i = 1,#debug[1].list_ennemy do
      debug.id.ennemy[#debug.id.ennemy+1] = i
     end 
  --tile
     for i = 1,#debug[2].list_tile do
      debug.id.tile[#debug.id.tile+1] = i
     end

local mt = {__newindex = ""}

setmetatable(debug.id.ennemy,mt)
setmetatable(debug.id.tile,mt)
end


debug.load = function (table,n)
setmetatable(debug[n],{__index = table})
end

debug.update = function (dt)

end

debug.draw = function()
local gfx = love.graphics

  if debug.state then
    local tile = debug[2].list_tile
    local ennemy = debug[1].list_ennemy
    local player = debug[1].player
    local x1,y1,w1,h1 = world:getRect(tile[idTile])
    local x2,y2,w2,h2 = world:getRect(player)
    local x3,y3,w3,h3 = world:getRect(ennemy[idEnnemy])
    local option = debug.id.option

    local coloredText = {
            global = {
              {48,171,0},--color
              ":::::::::::::::::::: DEBUG ::::::::::::::::::::".."\n", --text Global information
              {127,145,255},
              "=====global information=====".."\n",
              {255,255,255},--color
              "largeur  : "..largeur.."\n"..
              "hauteur  : "..hauteur.."\n",--text
              },
            global_bump = {
              {48,171,0},--color
              ":::::::::::::::::::: DEBUG ::::::::::::::::::::".."\n", --text  Global BUmp
              {127,145,255},
              "=======global bump======".."\n",
              {255,255,255},--color
              "Nombre d'item  : "..world:countItems().."\n"..
              "number of cell being used  : " ..world:countCells().."\n"
              ,--text
              },
            tile = {
              {48,171,0},--color
              ":::::::::::::::::::: DEBUG ::::::::::::::::::::".."\n", --text Tile
              {127,145,255},
              "=========tile=========".."\n",
              {180,180,180},
              "<-:--                   "..debug.id.tile[idTile].."                   --:->".."\n",
              {255,255,255}, --color
              "x  : "..tile[idTile].x.."\n"..
              "y  : "..tile[idTile].y.."\n"..
              "width  : "..tile[idTile].width.."\n"..
              "height  : "..tile[idTile].height.."\n"..
              "type  :  "..tile[idTile]["type"].."\n", --text
              {255,124,37},
              "========bump info======".."\n"..
              "x  : "..math.floor(x1).."\n"..
              "y  : "..math.floor(y1).."\n"..
              "width  : "..math.floor(w1).."\n"..
              "height : "..math.floor(h1).."\n"
              },
            player = {
              {48,171,0},--color
              ":::::::::::::::::::: DEBUG ::::::::::::::::::::".."\n", --text Player
              {127,145,255},
              "========player========".."\n",
              {255,255,255},
              "x  : "..math.floor(player.x).."\n"..
              "y  : "..math.floor(player.y).."\n"..
              "width : "..(player.width).."\n"..
              "width : "..(player.height).."\n"..
              "ox : "..(player.ox).."\n"..
              "oy : "..(player.oy).."\n"..
              "jump : "..(tostring(player.boolJump)).."\n"..
              "velocity_y : "..math.floor(player.velocity_y).."\n",
              {255,124,37},
              "========bump info======".."\n"..
              "x  : "..math.floor(x2).."\n"..
              "y  : "..math.floor(y2).."\n"..
              "width  : "..math.floor(w2).."\n"..
              "height : "..math.floor(h2).."\n"
            },
            ennemy = {
              {48,171,0},--color
              ":::::::::::::::::::: DEBUG ::::::::::::::::::::".."\n", --text Ennemy
              {127,145,255},
              "========ennemy========".."\n",
              {180,180,180},
              "<-:--                   "..debug.id.ennemy[idEnnemy] .."                   --:->".."\n",
              {255,255,255},--color 
              "x  : "..math.floor(ennemy[idEnnemy].x).."\n".. 
              "y  : "..math.floor(ennemy[idEnnemy].y).."\n"..
              "width  : "..ennemy[idEnnemy].width.."\n"..
              "height  : "..ennemy[idEnnemy].height.."\n"..
              "ox  : "..ennemy[idEnnemy].ox.."\n"..
              "oy  : "..ennemy[idEnnemy].oy.."\n"..
              "jump  : "..(tostring(ennemy[idEnnemy].boolJump)).."\n"..
              "velocity_y  : "..math.floor(ennemy[idEnnemy].velocity_y).."\n"..
              "dir  : "..ennemy[idEnnemy].dir.."\n",
              {255,124,37},
              "========bump info======".."\n"..
              "x  : "..math.floor(x3).."\n"..
              "y  : "..math.floor(y3).."\n"..
              "width  : "..math.floor(w3).."\n"..
              "height : "..math.floor(h3).."\n"
            },
            touche = {
              {180,180,180},
              "======touche======".."\n"..
              "x : ".."Enlever le debugeur".."\n"..
              "a : ".."Changer d'information".."\n"..
              "+ : ".."Incrementer la valeur".."\n"..
              "- : ".."Décrementer la valeur".."\n"..
              "u : ".."show/hide all bump collision   :  ",
              {255,0,48},
              tostring(option[1]).."\n",
              {180,180,180},
              "d : ".."Disable/enable collision Bump".."\n"..
              "draw  : ",
              {255,0,48},
              tostring(option[2]).."\n"
            }
          }
    local grp = ""
  if choice == 1 then 
     grp = "global"
  elseif choice == 2 then
     grp = "global_bump"
  elseif choice == 3 then
     grp = "tile"
  elseif choice == 4 then
     grp = "player"
  elseif choice == 5 then
     grp = "ennemy"
  end
-- affichage ecriture
    gfx.print(coloredText[grp],largeur-220,0)
    gfx.print(coloredText.touche,largeur-250,hauteur-220)
-- affichage box
  if grp == "tile" then
  gfx.setColor(37,255,68,127)
  gfx.rectangle("fill",tile[idTile].x,tile[idTile].y,tile[idTile].width,tile[idTile].height)
    if option[2] then
    gfx.setColor(13,116,87,180)
    gfx.rectangle("fill",x1,y1,w1,h1)
    end
  elseif grp == "player" then
  gfx.setColor(255,37,37,127)
  gfx.rectangle("fill",player.x,player.y,player.width,player.height)
    gfx.setColor(116,13,103,180)
    gfx.rectangle("fill",x2,y2,w2,h2)
  elseif grp == "ennemy" then
  gfx.setColor(37,145,255,127)
  gfx.rectangle("fill",ennemy[idEnnemy].x,ennemy[idEnnemy].y,ennemy[idEnnemy].width,ennemy[idEnnemy].height)
  if option[2] then
    gfx.setColor(39,13,116,180)
    gfx.rectangle("fill",x3,y3,w3,h3)
  end
end

  if option[1] and option[2] then-- show/enable all collision bump 
    local x1,y1,w1,h1 = world:getRect(player)
    gfx.setColor(240,140,120,120)
    gfx.rectangle("fill",x1,y1,w1,h1)
    for n = 1,#tile do
      local x2,y2,w2,h2 = world:getRect(tile[n])
      gfx.rectangle("fill",x2,y2,w2,h2)
    end
    for n = 1,#ennemy do
      local x3,y3,w3,h3 = world:getRect(ennemy[n])
      gfx.rectangle("fill",x3,y3,w3,h3)
    end
  end

  end
end

debug.keypressed = function(key)
  if debug.state then
    local grp = nil
    local option = debug.id.option
      if choice == 5 then 
        grp = "ennemy" 
      else 
        grp = nil  
        end

      if choice == 3 then 
        grp = "tile" 
      else
        grp = nil  
      end

        if key == "a" then
          if choice >= #debug.choice then
          choice = 1
          else
          choice = choice + 1
          id = 1 --reset id
          end
       end

       if key == "kp+" then
         if grp ~= nil then
           if id >= #debug.id[grp] then
              id = 1
            else
              id = id + 1
           end
          end
      end

      if key == "kp-" then
         if grp ~= nil then
          if id > 1 then
            id = id - 1
          else
            id = #debug.id[grp]
          end
        end
    end

    if key == "u" then
      if option[1] then
         option[1] = false
      else
      option[1] = true
      end
    end
    
    if key =="d" then
      if option[2] then
         option[2] = false
      else
      option[2] = true
      end
    end
  
      if choice == 5 then 
        idEnnemy = id 
      else 
        idEnnemy = 1 
        end

      if choice == 3 then 
        idTile = id
      else
        idTile = 1 
      end
  end
end

return debug