require ("tiolved")

function love.load()
	-- parsering tmx file
	map=tiolved:map("source/isometric.tmx")

	-- creation of the gid
	gid=tiolved:gid(map,"source/")

	-- interpretation of interpreted layers
	for i,v in ipairs (map) do
		if v.name=="collision" then
			-- create[collision](v)
			table.remove(map,i)
		end
	end

	-- rendering of drawned layers
	layers=tiolved:layers(map,gid)
	-- useful function
	toMap,toRender=tiolved:usefulfunc(map,gid)

	-- creation of objects
	for _,objectgroup in ipairs(map) do
		if objectgroup.je=="objectgroup" then
			for _,object in ipairs(objectgroup) do
				local obj={}
				for name,value in pairs(objectgroup) do
					obj[name]=value
				end
				for name,value in pairs(object) do
					obj[name]=value
				end
				-- create[objectgroup.name](obj)
			end
		end
	end
end

function love.update(dt)
	x=love.mouse:getX()
	y=love.mouse:getY()
	xmap,ymap=toMap(x,y)
	xrender,yrender=toRender(xmap,ymap)
end

function love.draw()
	for _,v in pairs(layers) do 
		love.graphics.draw(v.canvas)
	end
	love.graphics.print("x="..x..", y="..y.."\nxmap="..xmap..", ymap="..ymap.."\nxrender="..xrender..", yrender="..yrender)
end
