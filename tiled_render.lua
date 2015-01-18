tiled_render={}

function tiled_render:gid(map)
	gid={}
	local counter=1
	local i=1
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
				gid[counter]=canvas
				counter=counter+1
			end
		end
		i=i+1
	end
	return gid
end

function tiled_render:layers(map)
	local layers={}
	local draw={}
	local number=1
	if map.orientation=="orthogonal" then
		for _,v in ipairs(map) do
			if v.je=="layer" then
				local layer={name=v.name,number=number}
				layer.canvas=love.graphics.newCanvas(map.width*map.tilewidth,map.height*map.tileheight)
				love.graphics.setCanvas(couche.canvas)
				j=1
				if v[j].je=="properties" then
					for _,k in ipairs(v[j]) do
						layer[k.name]=k.value
					end
					j=j+1
				end
				-- data :
				for k,l in ipairs(v[j]) do
					if l.gid~="0" then
						local tileheight=gid[tonumber(l.gid)]:getHeight()
						local pos={x=(k-1)%map.width*map.tilewidth,y=(math.ceil(k/map.width))*map.tileheight-tileheight}
						love.graphics.draw(gid[tonumber(l.gid)],pos.x,pos.y)
					end
				end
				love.graphics.setCanvas()
				table.insert(layers,layer)
				number=number+1
			end
		end
	elseif map.orientation=="isometric" then
		local gap=map.height*map.tilewidth/2
		for _,v in ipairs(map) do
			if v.je=="layer" then
				local layer={name=v.name,number=number}
				layer.canvas=love.graphics.newCanvas((map.width+map.height)*map.tilewidth/2,(map.width+map.height)*map.tileheight/2)
				j=1
				if v[j].je=="properties" then
					for _,k in ipairs(v[j]) do
						layer[k.name]=k.value
					end
					j=j+1
				end
				-- data :
				love.graphics.setCanvas(layer.canvas)
				for k,l in ipairs(v[j]) do
					if l.gid~="0" then
						local tileheight=gid[tonumber(l.gid)]:getHeight()
						local pos={x=(k-1)%map.width+1,y=math.ceil(k/map.width)}
						local ipos={}
						ipos.x=gap+map.tilewidth/2*(pos.x-pos.y-1)
						ipos.y=map.tileheight/2*(pos.x+pos.y-1)-tileheight
						love.graphics.draw(gid[tonumber(l.gid)],ipos.x,ipos.y)
					end
				end
				love.graphics.setCanvas()
				table.insert(layers,layer)
				number=number+1
			end
		end
	end
	return layers
end
