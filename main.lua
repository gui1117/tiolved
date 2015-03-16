require ("tiolved")

function love.load()
	-- parsering tmx file
	local map=tiolved:map("source/orthogonal.tmx")

	-- creation of the gid
	local gid=tiolved:gid(map,"source/")

	tileset=tiolved:tileset(gid,map)

	-- interpretation of interpreted layers
	local toremove={} -- you must not remove in an array while looping in it
	for i,v in ipairs (map) do
		if v.name=="collision" then
			-- create[collision](v)
			table.insert(toremove,i)
		end
	end
	for _,v in ipairs(toremove) do
		table.remove(map,v)
	end

	-- rendering of drawned layers
	layers=tiolved:layers(map,tileset)
	-- useful function
	toMap,toRender=tiolved:usefulfunc(map)

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
	tileset:update(dt)

	x=love.mouse:getX()
	y=love.mouse:getY()
	xmap,ymap=toMap(x,y)
	xrender,yrender=toRender(xmap,ymap)

	if love.keyboard.isDown("escape") then
		love.event.quit()
	end
end

function love.draw()
	layers:draw() -- must be call before tileset:draw()
	tileset:draw()
	love.graphics.print(
		"x="..x..", y="..y..
		"\nxmap="..xmap..", ymap="..ymap..
		"\nxrender="..xrender..", yrender="..yrender
	)
end
