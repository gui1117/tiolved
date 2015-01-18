require ("tiolved")

function love.load()
	text=""
	tiolved:init("isometrique.tmx")
end

function love.update(dt)
end

function love.draw()
	tiolved:draw()
	love.graphics.print(text)
end
