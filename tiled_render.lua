local function tiled_render(map)
	local gid={}
	local compteur=1 -- counter

	-- TRAITEMENT DES TILESETS
	-- supposé : les tilesets sont contenus dans les premiers index de map
	-- 	     le premier index des tilesets est image
	local i = 1
	while map[i].je=="tileset" do
		local tileset=map[i]
		tileset.image=love.graphics.newImage(tileset[1].source)
		local tileinwidth=math.floor(tileset[1].width/tileset.tilewidth)
		local tileinheight=math.floor(tileset[1].height/tileset.tileheight)
		for n = 1,tileinheight do
			for m = 1,tileinwidth do
				local quad = love.graphics.newQuad((m-1)*tileset.tilewidth,(n-1)*tileset.tileheight,tileset.tilewidth,tileset.tileheight,tileset[1].width,tileset[1].height)
				local canvas = love.graphics.newCanvas(tileset.tilewidth,tileset.tileheight)
				love.graphics.setCanvas (canvas)
				love.graphics.draw(tileset.image,quad)
				love.graphics.setCanvas()
				gid[compteur]=canvas
				compteur=compteur+1
			end
		end
		i=i+1
	end

	-- TRAITEMENT DES CALQUES TILES
	-- on suppse que viennent directement ensuite les calques de tile
	-- avec propriétées ou pas puis data
	local layers={}
	local number = 1
	local draw={}
	function draw.orthogonal ()
		while map[i] and map[i].je=="layer" do
			local layer=map[i]
			local couche={name=layer.name,number=number,canvas=love.graphics.newCanvas(map.width*map.tilewidth,map.height*map.tileheight)}
			love.graphics.setCanvas(couche.canvas)
			j=1
			if layer[j].je=="properties" then
				for k in ipairs(layer[j]) do
					couche[layer[j][k].name]=layer[j][k].value
				end
				j=j+1
			end
			local data=layer[j]
			for k,l in ipairs(data) do
				if l.gid~="0" then
					local tileheight=gid[tonumber(l.gid)]:getHeight()
					local pos={x=(k-1)%map.width*map.tilewidth,y=(math.ceil(k/map.width))*map.tileheight-tileheight}
					love.graphics.draw(gid[tonumber(l.gid)],pos.x,pos.y)
				end
			end
			love.graphics.setCanvas()
			table.insert(layers,couche)
			i=i+1
			number=number+1
		end
	end

	function draw.isometric ()
		while map[i] and map[i].je=="layer" do
			local layer=map[i]
			local couche={name=layer.name,number=number,canvas=love.graphics.newCanvas((map.width+map.height)*map.tilewidth/2,(map.width+map.height)*map.tileheight/2)}
			love.graphics.setCanvas(couche.canvas)
			j=1
			if layer[j].je=="properties" then
				for k in ipairs(layer[j]) do
					couche[layer[j][k].name]=layer[j][k].value
				end
				j=j+1
			end
			local data=layer[j]
			for k,l in ipairs(data) do
				if l.gid~="0" then
					local tileheight=gid[tonumber(l.gid)]:getHeight()
					local pos={x=(k-1)%map.width+1,y=math.ceil(k/map.width)}
					local ipos={}
					ipos.x=map.tilewidth/2*(pos.x-pos.y-1)
					ipos.y=map.tileheight/2*(pos.x+pos.y-1)-tileheight
					love.graphics.draw(gid[tonumber(l.gid)],ipos.x,ipos.y)
				end
			end
			love.graphics.setCanvas()
			table.insert(layers,couche)
			i=i+1
			number=number+1
		end
	end

	draw[map.orientation]()

	-- TRAITEMENT DES CALQUES OBJECTS

	return layers
end

return tiled_render
