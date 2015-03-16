tiolved={}

-- it create from xml file a table
function tiolved:map(name)
	local firstline = "<%?"
	local object = "<[^/].*/>"
	local begintable = "<[^/].*[^/]>"
	local endtable= "</.*>"

	local stack={}
	local courant=1
	local xml={}
	stack[courant]=xml

	local function readattribute(line)
		local k, n, v
		_,k,n=string.find(line, "%s(%w%w*)=")
		if n then
			line=string.sub(line,k+1)
			_,k=string.find(line,".\"" )
			v=string.sub(line,2,k-1)
			line=string.sub(line,k+1)
		end
		return line,n,v
	end

	local function readline(line)
		local object, objectname, k
		_,k,objectname=string.find(line, "<(%w%w*)")
		line=string.sub(line, k+1)

		object={je=objectname}

		local attr={n=nil,v=nil}
		line,attr.n,attr.v=readattribute(line)
		while attr.n and attr.v do
			object[attr.n]=attr.v
			line,attr.n,attr.v=readattribute(line)
		end
		return object
	end

	for line in love.filesystem.lines(name) do
		if line == "</map>" then
			return xml[1]
		elseif string.find(line,firstline) then
		elseif string.find(line,object) then
			table.insert(stack[courant],readline(line))
		elseif string.find(line,begintable) then
			table.insert(stack[courant],readline(line))
			stack[courant+1]=stack[courant][table.getn(stack[courant])]
			courant=courant+1
		elseif string.find(line,endtable) then
			courant=courant-1
		end
	end
end

-- gid is a result of tileset information it will be used temporaly to create the true tileset
function tiolved:gid(map,rep)
	-- save the previous blendmode because tile are drawned in "replace" mode in orderto keep alpha and note having a mixe with black
	local previousblendmode=love.graphics.getBlendMode()
	love.graphics.setBlendMode("replace")
	local gid={}
	-- counter count the tile in gid
	local counter=1
	for _,m in ipairs(map) do
		-- interprate only from tileset table
		if m.je=="tileset" then
			local tileset=m
			-- import the image of the tileset in the repertory indicated
			tileset.image=love.graphics.newImage(rep..tileset[1].source)
			-- number of tile in width and in height, used to loop on them
			local tileinwidth=math.floor(tileset[1].width/tileset.tilewidth)
			local tileinheight=math.floor(tileset[1].height/tileset.tileheight)
			for n = 1,tileinheight do
				for m = 1,tileinwidth do
					-- the information of each tile are going in the table
					gid[counter]={}
					-- create a quad that take only the part of image that fits the tile
					local quad = love.graphics.newQuad((m-1)*tileset.tilewidth,(n-1)*tileset.tileheight,tileset.tilewidth,tileset.tileheight,tileset[1].width,tileset[1].height)
					-- create the canvas that will contain the tile
					local canvas = love.graphics.newCanvas(tileset.tilewidth,tileset.tileheight)
					-- draw the quad of the image into the canvas
					love.graphics.setCanvas (canvas)
					love.graphics.draw(tileset.image,quad)
					love.graphics.setCanvas()
					
					-- each tile have a canvas and and absolute identifier
					gid[counter].canvas=canvas
					gid[counter].id=counter
					counter=counter+1
				end
			end

			-- interpretation of some information in the tileset : properties and animation of tiles
			for _,t in ipairs(tileset) do
				if t.je=="tile" then
					for _,k in ipairs(t) do
						-- calculation of the identifier of the tile
						local l=tonumber(t.id)+tonumber(tileset.firstgid)
						-- saving of the animation
						if k.je=="animation" then
							gid[l].animation={}
							for _,a in ipairs(k) do
								table.insert(gid[l].animation,{tileid=tonumber(a.tileid)+tonumber(tileset.firstgid),duration=tonumber(a.duration)})
							end
						-- saving of properties
						elseif k.je=="properties" then
							for _,p in ipairs(k) do
								gid[l][p.name]=p.value
							end
						end
					end
				end
			end
		end
	end
	-- set the previous blend mode
	love.graphics.setBlendMode(previousblendmode)
	return gid
end

-- tileset is an object that contain the canvas of each tile, a table of animated tile and a table of tile to draw (batch)
-- it has 3 mathods : update, draw, and add
-- update changes the canvas of tile that are animated
-- add adds a tile to draw at a certain height
-- draw draws tiles and clean the batch
function tiolved:tileset(gid,map)
	local tileset={
		animated={},
		batch={}
	}
	for i,g in ipairs(gid) do
		if g.animation then
			local anim={
				id=i,
				current=1
			}
			for k,v in ipairs(g.animation) do
				table.insert(anim,{canvas=gid[v.tileid].canvas,duration=v.duration/1000})
			end
			anim.nexttime=anim[1].duration
			table.insert(tileset.animated,anim)
			tileset[i]=anim[1].canvas
		else
			tileset[i]=g.canvas
		end
	end
	local time=0
	function tileset:update(dt)
		time=time+dt
		for _,t in ipairs(self.animated) do
			debug="    next="..t.nexttime.." dur="..t[t.current].duration.." cur="..t.current.." time="..time
			while time >= t.nexttime do
				t.nexttime=t.nexttime+t[t.current].duration
				t.current=t.current % table.getn(t) +1
				t.canvas=t[t.current].canvas
				for _,v in pairs(self.batch) do
					if v[t.id] then 
						v[t.id]:setTexture(t.canvas)
					end
				end
			end
		end
	end
	local size=map.width*map.tilewidth,map.height*map.tileheight
	function tileset:add(z,id,x, y, r, sx, sy, ox, oy, kx, ky )
		if not self.batch[z] then self.batch[z]={} end
		if not self.batch[z][id] then self.batch[z][id]=love.graphics.newSpriteBatch(self[id],size) end
		self.batch[z][id]:add(x, y, r, sx, sy, ox, oy, kx, ky )
	end
	function tileset:draw()
		for _,v in pairs(self.batch) do
			for _,k in pairs(v) do
				love.graphics.draw(k,0,0)
				k:clear()
			end
		end
	end
	return tileset
end

function tiolved:layers(map,tileset)
	local layers={}
	local number=1
	if map.orientation=="orthogonal" then
		for _,v in ipairs(map) do
			if v.je=="layer" then
				local layer={
					name=v.name,
					number=number,
					tile={}
				}
				j=1
				-- properties
				if v[j].je=="properties" then
					for _,k in ipairs(v[j]) do
						layer[k.name]=k.value
					end
					j=j+1
				end
				-- interpration of z property
				if not layer.z then layer.z=number 
				else layer.z=tonumber(layer.z)
				end
				-- data
				for k,l in ipairs(v[j]) do
					if l.gid~="0" then
						local id=tonumber(l.gid)
						local tileheight=tileset[id]:getHeight()
						local pos={x=(k-1)%map.width*map.tilewidth,y=(math.ceil(k/map.width))*map.tileheight-tileheight}
						tileset:add(layer.z,id,pos.x,pos.y)
						table.insert(layer.tile,{id=id,x=pos.x,y=pos.y})
					end
				end
				-- function to insert tiles of the layer in tileset.batch
				function layer.draw()
					for _,v in ipairs(layer.tile) do
						tileset:add(layer.z,v.id,v.x,v.y)
					end
				end
				-- insertion in a global table named layers
				table.insert(layers,layer)
				number=number+1
			end
		end
	elseif map.orientation=="isometric" then
	end
	function layers.draw()
		for _,v in ipairs(layers) do
			v.draw()
		end
	end
	return layers
end

function tiolved:usefulfunc(map)
	local toMap,toRender

	if map.orientation=="orthogonal" then
		function toMap(x,y)
			return x/map.tilewidth,y/map.tileheight
		end
		function toRender(x,y)
			return x*map.tilewidth,y*map.tileheight
		end
	end
	return toMap,toRender
end
