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
local debug_rainbow = require 'state.player'
debug.state = false

debug[1] = {}  --CustomLayer information
debug[2] = {}  --Game information
debug[3] = {}  --Rainbow information

debug.choice = {false,false,false,false,false,false} --global information set
local choice = 1 
--[[--------------------------------------------
==================CHOIX=========================
                1) Information global
                2) Information bump general
                3) Information Tile
                4) Information Player
                5) Information Ennemy
                6) Rainbow_chain (not implemented)
------------------------------------------------
]]
  debug.id = {
    ennemy = {},
    tile = {},
    rainbow_chain = {},
    option = {true,true}, -- disable/enable collision et option hide/show all collision  
  }

local id = 1
local idEnnemy = 1
local idTile = 1
local idRainbow = 1


debug.initialize = function()
  debug.load(debug_customlayer.debug(debug[1]),1) -- 2eme argument,set n as debug[n]
  debug.load(debug_collision.debug(debug[2]),2)

  --update choice
    for i = 1,#debug.choice do
      debug.choice[i] = false
      if choice == i then
        debug.choice[i] = true
      end
    end

  --initialize Numero id 
  debug.id.ennemy = {}
  debug.id.tile = {}
  debug.id.rainbow_chain = {}
  --ennemy
      for i = 1,#debug[1].list_ennemy do
      debug.id.ennemy[#debug.id.ennemy + 1] = i
     end 
  --tile
     for i = 1,#debug[2].list_tile do
      debug.id.tile[#debug.id.tile + 1] = i
     end
  --rainbow 
 if not debug[1].player.creerRainbow  then
--      print("Aucun arc-en-ciel n'a été créer")
  else
--      print("un ou plusieur arc-en-ciel ont été générée")
      for i = 1,#debug[1].player.list_rainbow do
        debug.id.rainbow_chain[#debug.id.rainbow_chain + 1] = i
      end
 end
--local mt = {__newindex = ""}

--setmetatable(debug.id.ennemy,mt)
--setmetatable(debug.id.tile,mt)
end


debug.load = function (table,n)
--setmetatable(debug[n],{__index = table})
debug[n] = table
end

debug.update = function (dt)

end
 

debug.draw = function()
local gfx = love.graphics

  if debug.state then
    local tile = debug[2].list_tile
    local ennemy = debug[1].list_ennemy
    local player = debug[1].player
    local rainbow = debug[1].player.list_rainbow

    local option = debug.id.option
    local text = ""
    local bumpText = ""

    local function returnBumpText()
      if tile[1] ~= nil and choice == 3 then
      local x1,y1,w1,h1 = world:getRect(tile[idTile])
      bumpText ="========bump info======".."\n"..
              "x  : "..math.floor(x1).."\n"..
              "y  : "..math.floor(y1).."\n"..
              "width  : "..math.floor(w1).."\n"..
              "height : "..math.floor(h1).."\n"
      elseif ennemy[1] ~= nil and choice == 5 then
      local x3,y3,w3,h3 = world:getRect(ennemy[idEnnemy])
      bumpText = "========bump info======".."\n"..
              "x  : "..math.floor(x3).."\n"..
              "y  : "..math.floor(y3).."\n"..
              "width  : "..math.floor(w3).."\n"..
              "height : "..math.floor(h3).."\n"
      elseif player ~= nil and choice == 4 then
      local x2,y2,w2,h2 = world:getRect(player)
      bumpText ="========bump info======".."\n"..
              "x  : "..math.floor(x2).."\n"..
              "y  : "..math.floor(y2).."\n"..
              "width  : "..math.floor(w2).."\n"..
              "height : "..math.floor(h2).."\n"
      elseif rainbow[1] ~= nil and choice == 6 then
           local x4,y4,w4,h4 = world:getRect(rainbow[idRainbow])
      bumpText = "========bump info======".."\n"..
              "x  : "..math.floor(x4).."\n"..
              "y  : "..math.floor(y4).."\n"..
              "width  : "..math.floor(w4).."\n"..
              "height : "..math.floor(h4).."\n"
      else
      bumpText = ""
     end
  end


    local function returnText()

      if tile[1] ~= nil and choice == 3 then
        text ="x  : "..tile[idTile].x.."\n"..
              "y  : "..tile[idTile].y.."\n"..
              "width  : "..tile[idTile].width.."\n"..
              "height  : "..tile[idTile].height.."\n"..
              "type  :  "..tile[idTile]["type"].."\n"
      elseif ennemy[1] ~= nil and choice == 5 then
        text ="x  : "..math.floor(tostring(ennemy[idEnnemy].pos.x)).."\n".. 
              "y  : "..math.floor(tostring(ennemy[idEnnemy].pos.y)).."\n"..
              "width  : "..tostring(ennemy[idEnnemy].width).."\n"..
              "height  : "..tostring(ennemy[idEnnemy].height).."\n"..
              "ox  : "..tostring(ennemy[idEnnemy].ox).."\n"..
              "oy  : "..tostring(ennemy[idEnnemy].oy).."\n"..
              "jump  : "..(tostring(ennemy[idEnnemy].boolJump)).."\n"..
              "velocity_y  : "..math.floor(tostring(ennemy[idEnnemy].velocity_y)).."\n"..
              "dir  : "..tostring(ennemy[idEnnemy].dir).."\n"..
              "no_collision  : "..(tostring(ennemy[idEnnemy].no_collision)).."\n"..
              "sleep  : "..(tostring(ennemy[idEnnemy].sleep)).."\n"..
              "ground  : "..(tostring(ennemy[idEnnemy].ground)).."\n"
      elseif player ~= nil and choice == 4 then
        text =               "x  : "..math.floor(player.pos.x).."\n"..
              "y  : "..math.floor(player.pos.y).."\n"..
              "width : "..(player.width).."\n"..
              "height : "..(player.height).."\n"..
              "ox : "..(player.ox).."\n"..
              "oy : "..(player.oy).."\n"..
              "dir : "..(player.dir).."\n"..
              "jump : "..(tostring(player.boolJump)).."\n"..
              "on_rainbow : "..(tostring(player.onRainbow)).."\n"..
              "descente_rainbow1 : "..(tostring(player.descenteRainbow1)).."\n"..
              "descente_rainbow2 : "..(tostring(player.descenteRainbow2)).."\n"..
              "theresRainbow? : "..(tostring(player.theresRainbow)).."\n"..
              "velocity_y : "..math.floor(player.velocity_y).."\n"
      elseif rainbow[1] ~= nil and choice == 6 then
      text = "x  : "..math.floor(tostring(rainbow[idRainbow].pos.x)).."\n"..
              "y  : "..math.floor(tostring(rainbow[idRainbow].pos.y)).."\n"..
              "width : "..(tostring(rainbow[idRainbow].width)).."\n"..
              "height : "..(tostring(rainbow[idRainbow].height)).."\n"..
              "dir : "..(tostring(rainbow[idRainbow].dir)).."\n"..
              "ox : "..(tostring(rainbow[idRainbow].ox)).."\n"..
              "oy : "..(tostring(rainbow[idRainbow].oy)).."\n"..
              "rainbowCross : "..(tostring(rainbow[idRainbow].rainbowCross)).."\n"
      else
      text = ""
      end
    end

returnText()
returnBumpText()

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
              {255,255,255},text,{255,124,37},bumpText},
            player = {
              {48,171,0},--color
              ":::::::::::::::::::: DEBUG ::::::::::::::::::::".."\n", --text Player
              {127,145,255},
              "========player========".."\n",
              {255,255,255},text,{255,124,37},bumpText},
            ennemy = {
              {48,171,0},--color
              ":::::::::::::::::::: DEBUG ::::::::::::::::::::".."\n", --text Ennemy
              {127,145,255},
              "========ennemy========".."\n",
              {180,180,180},
              "<-:--                   "..tostring(debug.id.ennemy[idEnnemy]) .."                   --:->".."\n",
              {255,255,255},text,{255,124,37},bumpText},
            rainbow_chain = {
              {48,171,0},--color
              ":::::::::::::::::::: DEBUG ::::::::::::::::::::".."\n", --rainbow_chain
              {127,145,255},
              "======rainbow_chain======".."\n",
              {180,180,180},
              "<-:--                   "..tostring(debug.id.rainbow_chain[idRainbow]) .."                   --:->".."\n",
              {255,255,255},text},
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
  elseif choice == 6 then
    grp = "rainbow_chain"
  end

-- affichage ecriture
    gfx.print(coloredText[grp],largeur-220,0)
    gfx.print(coloredText.touche,largeur-250,hauteur-220)

-- affichage individual box
  if grp == "tile" and tile[1] ~= nil then
    gfx.setColor(37,255,68,127)
    gfx.rectangle("fill",tile[idTile].x,tile[idTile].y,tile[idTile].width,tile[idTile].height)
    if option[2] then
    local x1,y1,w1,h1 = world:getRect(tile[idTile])
      gfx.setColor(13,116,87,180)
      gfx.rectangle("fill",x1,y1,w1,h1)
    end
  elseif grp == "player" and player ~= nil then
    local x2,y2,w2,h2 = world:getRect(player)
    gfx.setColor(255,37,37,127)
    gfx.rectangle("fill",player.pos.x,player.pos.y,player.width,player.height)
    gfx.setColor(116,13,103,180)
    gfx.rectangle("fill",x2,y2,w2,h2)
    gfx.setColor(255,255,255,255)
    gfx.circle("fill",player.pos.x,player.pos.y,2)
  elseif grp == "ennemy" and ennemy[1] ~= nil then
    local x3,y3,w3,h3 = world:getRect(ennemy[idEnnemy])
    gfx.setColor(37,145,255,127)
    gfx.rectangle("fill",ennemy[idEnnemy].pos.x,ennemy[idEnnemy].pos.y,ennemy[idEnnemy].width,ennemy[idEnnemy].height)
    gfx.setColor(255,255,255,255)
    gfx.circle("fill",ennemy[idEnnemy].pos.x,ennemy[idEnnemy].pos.y,2)
    if option[2] then
      gfx.setColor(39,13,116,180)
      gfx.rectangle("fill",x3,y3,w3,h3)
    end
  elseif grp == "rainbow_chain" and rainbow[1] ~= nil then
    local x4,y4,w4,h4 = world:getRect(rainbow[idRainbow])
    gfx.setColor(37,145,255,127)
    gfx.rectangle("fill",rainbow[idRainbow].pos.x,rainbow[idRainbow].pos.y,rainbow[idRainbow].width,rainbow[idRainbow].height)
    gfx.setColor(255,255,255,255)
    gfx.circle("fill",rainbow[idRainbow].pos.x,rainbow[idRainbow].pos.y,2)
      if option[2] then
        gfx.setColor(39,13,116,180)
        gfx.rectangle("fill",x4,y4,w4,h4)
      end
end

  if option[1] and option[2] then-- show/enable all collision bump 
    gfx.setColor(240,140,120,120)
    if player ~= nil then
    local x1,y1,w1,h1 = world:getRect(player)
    local x2,y2,w2,h2 = world:getRect(player.detect)
    gfx.rectangle("fill",x1,y1,w1,h1)
    gfx.setColor(0,255,0,200)
    gfx.rectangle("fill",x2,y2,w2,h2)
   end
  
    if tile[1] ~= nil then
    gfx.setColor(240,140,120,120)
      for n = 1,#tile do
        local x2,y2,w2,h2 = world:getRect(tile[n])
        gfx.rectangle("fill",x2,y2,w2,h2)
      end
    end

    if ennemy[1] ~= nil then
    for n = 1,#ennemy do
      local x3,y3,w3,h3 = world:getRect(ennemy[n])
      gfx.rectangle("fill",x3,y3,w3,h3)
    end
    end

    if rainbow[1] ~= nil then
      for n = 1,#rainbow do
       local x4,y4,w4,h4 = world:getRect(rainbow[n])
       local x6,y6,w6,h6 = world:getRect(rainbow[n].detect)
       local x7,y7,w7,h7 = world:getRect(rainbow[n].detect2)
        gfx.setColor(240,140,120,120)
        gfx.rectangle("fill",x4,y4,w4,h4)
        gfx.setColor(255,0,0,255)
        gfx.rectangle("fill",x6,y6,w6,h6)
        gfx.setColor(0,0,255,255)
        gfx.rectangle("fill",x7,y7,w7,h7)
        if rainbow[n].bullet.display then
          local x5,y5,w5,h5 = world:getRect(rainbow[n].bullet)
          gfx.setColor(0,0,255,255)
          gfx.rectangle("fill",x5,y5,w5,h5)
        end
      end
    end
    
  end

  end
end

debug.keypressed = function(key)
  if debug.state then
    local grp = nil
    local option = debug.id.option

        if key == "a" then
          if choice >= #debug.choice then
          choice = 1
          else
          choice = choice + 1
          id = 1 --reset id
          end
       end

      if choice == 5 then 
        grp = "ennemy" 
      elseif choice == 3 then
        grp = "tile" 
      elseif choice == 6 then
        grp = "rainbow_chain"
      else
        grp = nil  
      end


-- Incrementer la valeur de [categorie]
       if key == "kp+" then
         if grp ~= nil then
           if id >= #debug.id[grp] then
              id = 1
            else
              id = id + 1
           end
          end
      end

-- Décrementer la valeur de [categorie]
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

      if choice == 6 then
        idRainbow = id
      else
        idRainbow = 1
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