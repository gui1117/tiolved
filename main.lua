function love.load()
	tiled_render=love.filesystem.load("tiled_render.lua")()
	layers=tiled_render("isometrique.tmx")
end

function love.update(dt)
end

function love.draw()
	for i,v in ipairs(layers) do
		love.graphics.draw(v.canvas)
	end
end
