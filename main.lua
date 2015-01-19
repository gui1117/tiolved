require ("tiolved")

function love.load()
	text=""
	tiolved:init("isometrique.tmx")
end

function love.update(dt)
end

function love.draw()
	love.graphics.translate(-3000,-1300)
	tiolved:draw()
end
