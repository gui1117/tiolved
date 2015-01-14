function love.load()
	tiolvedinit=love.filesystem.load("tiolved.lua")()
	tiolved=tiolvedinit("isometrique.tmx")
	text=""
end

function love.update(dt)
	text="\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n" 
	x,y=love.mouse:getPosition()
	text=text.."\nscreen : x="..x..", y"..y
	x,y=tiolved.screentomap(x,y)
	text=text.."\nmap : x="..x..", y"..y
	x,y=tiolved.maptoscreen(x,y)
	text=text.."\nscreen : x="..x..", y"..y
end

function love.draw()
	for i,v in ipairs(tiolved.layers) do
		love.graphics.draw(v.canvas)
	end
	love.graphics.print(text)
end
