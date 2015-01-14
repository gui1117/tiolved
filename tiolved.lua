local function tiolved ( maptmx )
	local tiled_render=love.filesystem.load("tiled_render.lua")()
	local tmx_parser=love.filesystem.load("tmx_parser.lua")()
	local map = tmx_parser(maptmx)
	local layers=tiled_render(map)

	if map.orientation=="orthogonal" then
		screentomap=function(x,y)
			return x/map.tilewidth,y/map.tileheight
		end
		maptoscreen=function(x,y)
			return x*map.tilewidth,y*map.tileheight
		end
	elseif map.orientation=="isometric" then
		screentomap=function(x,y)
			local a=map.tilewidth
			local b=map.tileheight
			local d=1/(2*map.tilewidth*map.tileheight)
			return d*(b*x+a*y),d*(-b*x+a*y)
		end
		maptoscreen=function(x,y)
			return (x-y)*map.tilewidth,(x+y)*map.tileheight
		end
	end

	return {map=map,layers=layers,screentomap=screentomap,maptoscreen=maptoscreen}
end

return tiolved
