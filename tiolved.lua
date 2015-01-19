require ("create")
require("tiolvedParser")

tiolved={}

tiolved.map={}
tiolved.gid={}
tiolved.layers={}
tiolved.objects={}

function tiolved:init(maptmx)
	tiolved.map=tiolvedParser:map(maptmx)
	tiolved.gid=tiolvedParser:gid(tiolved.map)

	-- traitement des couche tile interpreté
	for i,v in ipairs (tiolved.map) do
		if v.name=="collision" then
			create[collision](v)
			table.remove(tiolved.map,v)
		end
	end

	-- traitement des couches qui reste en dessin
	tiolved.layers=tiolvedParser:layers(tiolved.map)

	-- fonction de conversion x,y
	local map=tiolved.map
	local gap=map.height*map.tilewidth/2

	if tiolved.map.orientation=="orthogonal" then
		function tiolved:toMap(x,y)
			return x/map.tilewidth,y/map.tileheight
		end
		function tiolved.toRender(x,y)
			return x*map.tilewidth,y*map.tileheight
		end
	elseif tiolved.map.orientation=="isometric" then
		function tiolved:toMap(x,y)
			local xg=x-gap
			local gap=map.height*map.tilewidth/2
			local a=map.tilewidth
			local b=map.tileheight
			local d=1/(2*map.tilewidth*map.tileheight)
			return d*(b*xg+a*y),d*(-b*xg+a*y)
		end
		function tiolved:toRender(x,y)
			return (x-y)*map.tilewidth+gap,(x+y)*map.tileheight
		end
	end

	-- creation des objets
	tiolved:createobjects(map)
end

function tiolved:createobjects(map)
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
				if create[objectgroup.name] then
					create[objectgroup.name](obj)
				end
			end
		end
	end
end

function tiolved:sort(a,b)

end

function tiolved:draw()
	for _,v in pairs(tiolved.layers) do 
		love.graphics.draw(v.canvas)
	end
end
