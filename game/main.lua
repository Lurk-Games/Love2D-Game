local score = 0
local filename = "score.txt"

function love.load()

loadScore()

imageX = 300
imageY = 300

image = love.graphics.newImage("assets/images/logo.jpg")
background = love.graphics.newImage("assets/images/background.png")
cursor = love.mouse.newCursor("assets/images/cursor.png", 0, 0)

-- Original dimensions of the image
    originalWidth = image:getWidth()
    originalHeight = image:getHeight()

    originalWidthBG = background:getWidth()
    originalHeightBG = background:getHeight()
    
    -- Desired dimensions for the image
    imageWidth = 200  -- Desired width
    imageHeight = 200  -- Desired height

    -- Desired dimensions for the image
    imageWidthBG = 1500  -- Desired width
    imageHeightBG = 800  -- Desired height
    
    -- Calculate the scaling factors
    scaleX = imageWidth / originalWidth
    scaleY = imageHeight / originalHeight

    -- Calculate the scaling factors
    BGscaleX = imageWidthBG / originalWidthBG
    BGscaleY = imageHeightBG / originalHeightBG

love.mouse.setCursor(cursor)

love.window.setFullscreen(true, "desktop")

end

function love.quit()
    saveScore()
end


function love.update(dt)
    -- Get the current mouse position
    mouseX, mouseY = love.mouse.getPosition()

    -- Check if the mouse is over the image
    mouseOverImage = mouseX > imageX and mouseX < imageX + imageWidth and mouseY > imageY and mouseY < imageY + imageHeight
end

-- Draw a coloured rectangle.
function love.draw()
    love.graphics.draw(background, 0,0,0,BGscaleX,BGscaleY)
    love.graphics.draw(image, imageX, imageY, 0, scaleX, scaleY)
    love.graphics.print("Score: " .. score,500,0)
end

function love.mousepressed(x, y, button, istouch)
   if button == 1 and mouseOverImage then -- Versions prior to 0.10.0 use the MouseConstant 'l'
      score = score + 1
   end
end

function love.keypressed(key,scancode,isrepeat)
    if key == "escape" then
        love.event.quit()
    elseif key == "l" then
        loadScore()
    elseif key == "c" then
        score = 0
        print("Score cleared")
    elseif key == "f11" then
        fullscreen = not fullscreen
        love.window.setFullscreen(fullscreen, "exclusive")
    end
end

function saveScore()
    -- Open the file for writing
    local file = love.filesystem.newFile(filename, "w")
    local success, message = file:write(tostring(score) .. "\n")
    file:close()
    if success then
        print("Score saved to " .. filename)
    else
        print("Error saving score: " .. message)
    end
end


function loadScore()
    if love.filesystem.getInfo(filename) then
        local contents, size = love.filesystem.read(filename)
        if contents then
            score = tonumber(contents)
            if score then
                print("Score loaded from " .. filename)
            else
                print("Error: Could not convert file contents to a number.")
            end
        else
            print("Error reading score file.")
        end
    else
        print("No score file found, starting fresh.")
    end
    print("Current score: " .. score)
end
