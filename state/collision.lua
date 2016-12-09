local collision = {}
local list_tile = {}

collision.load = function()
-- list_tile  

local maxLigne,maxColonne =  map.layers[1].height,map.layers[1].width
local nLigne,nColonne = 0,0

for nLigne = 1,maxLigne do
  for nColonne = 1,maxColonne do
    if map.layers[1].data[nLigne][nColonne] ~= nil then
      if map.layers[1].data[nLigne][nColonne].properties["type"] ~= nil then
          local tile = map.layers[1].data[nLigne][nColonne]
          collision.initialize((nColonne-1) * tile.width, (nLigne-1) * tile.height, tile.width,tile.height,tile.properties.type)
          --  for k,v in pairs(tile) do
          --    print (k,v)
          --  end
      end
    end
  end
end

end

collision.initialize = function(pX,pY,pW,pH,pType)
  tile = {
    x = pX,
    y = pY,
    width = pW,
    height = pH,
    ["type"] = pType
  }
  list_tile[#list_tile+1] = tile
  world:add(tile,tile.x+9,tile.y-2,tile.width,tile.height)
end

collision.debug = function (self)
self = {}
self.list_tile = list_tile
return self
end

return collision