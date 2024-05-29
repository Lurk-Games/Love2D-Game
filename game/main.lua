local score = 0
local filename = "score.txt"
local scoreAddition = 1
local version = "1.0(Unfinished)"

local game_state = 'menu'
local menus = { 'Play', 'Quit'}
local selected_menu_item = 1
local window_width
local window_height
local font_height


-- functions
local draw_menu
local menu_keypressed
local draw_game
local game_keypressed

function love.load()
    loadScore()

    -- Fonts
    font1 = love.graphics.newFont("assets/font/Coffee Normal.ttf", 50)
    font2 = love.graphics.newFont("assets/font/Coffee Normal.otf",50)

    -- Get the width and height of the game window in order to center menu items
    window_width, window_height = love.graphics.getDimensions()

    -- Use a big font for the menu
    local font = love.graphics.setNewFont(30)

    -- Get the height of the font to help calculate vertical positions of menu items
    font_height = font:getHeight()

    love.graphics.setDefaultFilter("nearest", "nearest")

    imageX = 550
    imageY = 300

    --Audio
    sound = love.audio.newSource("assets/SFX/mouseclick1.ogg", "static") -- the "static" is good for short sound effects
    -- music = love.audio.newSource("techno.ogg", "stream") -- the "stream" is good for longer music tracks

    image = love.graphics.newImage("assets/images/planet03.png")
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

    imageWidthBG = 1500  -- Desired width
    imageHeightBG = 800  -- Desired height

    -- Calculate the scaling factors
    scaleX = imageWidth / originalWidth
    scaleY = imageHeight / originalHeight

    BGscaleX = imageWidthBG / originalWidthBG
    BGscaleY = imageHeightBG / originalHeightBG

    love.mouse.setCursor(cursor)

    love.window.setFullscreen(true, "desktop")
end

function love.quit()
    saveScore()
end

function love.mousepressed(x, y, button, istouch)
    if button == 1 then -- Versions prior to 0.10.0 use the MouseConstant 'l'
        if game_state == 'game' then
            if mouseOverImage then
                score = score + scoreAddition
                sound:play()
            end
        end
    end
end

function love.update(dt)
    if game_state == 'game' then
        -- Get the current mouse position
        mouseX, mouseY = love.mouse.getPosition()

        -- Check if the mouse is over the image
        mouseOverImage = mouseX > imageX and mouseX < imageX + imageWidth and mouseY > imageY and mouseY < imageY + imageHeight

    end
end


function love.draw()
    if game_state == 'menu' then
        draw_menu()
    elseif game_state == 'game' then
        draw_game()
    end
end

function draw_menu()
    font = love.graphics.setNewFont(30)
    local horizontal_center = window_width / 2
    local vertical_center = window_height / 2
    local start_y = vertical_center - (font_height * (#menus / 2))

    -- Draw guides to help check if menu items are centered, can remove later
    -- love.graphics.setColor(1, 1, 1, 0.1)
    -- love.graphics.line(horizontal_center, 0, horizontal_center, window_height)
    -- love.graphics.line(0, vertical_center, window_width, vertical_center)

    -- Draw game title
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.print("Planet Clicker", 550, 150, 0, 1)
    love.graphics.print("Version: " .. version .. " Might finish it one day", 0, 725, 0, 0.5) -- (Text, PositionX, PositionY, Rotation, Size)
    love.graphics.print("Made by: Moonwave Studios", 550, 725, 0, 0.5) -- (Text, PositionX, PositionY, Rotation, Size)

    -- Draw menu items
    for i = 1, #menus do
        -- Currently selected menu item is yellow
        if i == selected_menu_item then
            love.graphics.setColor(1, 1, 0, 1)
        -- Other menu items are white
        else
            love.graphics.setColor(1, 1, 1, 1)
        end

        -- Draw this menu item centered
        love.graphics.print(menus[i], 600, start_y + font_height * (i-1), 0, 1)
    end
end
function draw_game()
    love.graphics.setFont(font1)
    love.graphics.draw(background, SettingsButX, SettingsButY, 0, BGscaleX, BGscaleY)
    love.graphics.draw(image, imageX, imageY, 0, scaleX, scaleY)
    love.graphics.print("Technology Points: " .. score, 400, 0, 0, 1) -- (Text, PositionX, PositionY, Rotation, Size)
end

function love.keypressed(key, scan_code, is_repeat)
    if game_state == 'menu' then
        menu_keypressed(key)
    elseif game_state == 'game' then
        game_keypressed(key)
    end
end

function menu_keypressed(key)
    -- Pressing Esc on the main menu quits the game
    if key == 'escape' then
        love.event.quit()
    -- Pressing up selects the previous menu item, wrapping to the bottom if necessary
    elseif key == 'up' then
        selected_menu_item = selected_menu_item - 1
        if selected_menu_item < 1 then
            selected_menu_item = #menus
        end
    -- Pressing down selects the next menu item, wrapping to the top if necessary
    elseif key == 'down' then
        selected_menu_item = selected_menu_item + 1
        if selected_menu_item > #menus then
            selected_menu_item = 1
        end
    -- Pressing enter changes the game state (or quits the game)
    elseif key == 'return' or key == 'kpenter' then
        if menus[selected_menu_item] == 'Play' then
            game_state = 'game'
        elseif menus[selected_menu_item] == 'Quit' then
            love.event.quit()
        end
    end
end

function how_to_play_keypressed(key)
    if key == 'escape' then
        game_state = 'menu'
    end
end

function game_keypressed(key)
    if key == 'escape' then
        game_state = 'menu'
    elseif key == "l" then
        loadScore()
    elseif key == "c" then
        score = 0
        print("Score cleared")
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
