-- Cette ligne permet d'afficher des traces dans la console pendant l'éxécution
io.stdout:setvbuf('no')

-- Empèche Love de filtrer les contours des images quand elles sont redimentionnées
-- Indispensable pour du pixel art
love.graphics.setDefaultFilter("nearest")

-- Cette ligne permet de déboguer pas à pas dans ZeroBraneStudio
if arg[#arg] == "-debug" then require("mobdebug").start() end

sti   = require 'libs.sti'
anim8 = require 'libs.anim8'
bump  = require 'libs.bump'
class = require 'libs.middleclass'
game  = require 'state.game'
debug = require 'state.debug'
require 'state.util'


function love.load()
  game.load()
  largeur = love.graphics.getWidth()
  hauteur = love.graphics.getHeight()
  debug.initialize()
end

function love.update(dt)
  game.update(dt)
end

function love.draw()
    game.draw()
end

function love.keypressed(key)
  
  game.keypressed(key)
  
end