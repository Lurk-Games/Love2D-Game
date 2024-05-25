local characterPositionY = 200
local characterPositionX = 200

function love.load()
image = love.graphics.newImage("logo.jpg")
w, h = love.graphics.getDimensions()
wi, hi = image:getDimensions()
end

function love.update(dt)
    -- Change image position accordingly to the mouse position
    x, y = love.mouse.getPosition()
end
-- Draw a coloured rectangle.
function love.draw()
    love.graphics.draw(image, x, y, 0, 0.5,0.5,wi/2,hi/2)
end

function love.keypressed(key,scancode,isrepeat)
    if key == "escape" then
        love.event.quit()
    elseif key == "w" then
        characterPositionY = characterPositionY + 5
        love.graphics.print(characterPositionY,400,300)
    end
end
