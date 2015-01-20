require ("tiolved")

function love.load()
	-- parsering tmx file
	map=tiolved:map("source/isometrique.tmx")

	-- creation of the gid
	gid=tiolved:gid(map,"source/")

	-- interpretation of interpreted layers
	for i,v in ipairs (map) do
		if v.name=="collision" then
			-- create[collision](v)
			table.remove(map,v)
		end
	end

	-- rendering of drawned layers
	layers=tiolved:layers(map,gid)
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

end

function love.draw()
	love.graphics.translate(-3000,-1300)
	for _,v in pairs(layers) do 
		love.graphics.draw(v.canvas)
	end
end
