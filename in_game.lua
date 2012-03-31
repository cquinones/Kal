function keyPressedPlaying(key)
    if key == "q" then
        if player1.isJumping == false and player1.isFalling == false then
            player1.isJumping = true
            player1.jumpPower = GameConstants.playerJump
            
            -- TODO: Change how jump power is affected by gravity.

            jumpSfx:stop()
            jumpSfx:play()
        end
    end
    
    if key == "p" then
        if player2.isJumping == false and player2.isFalling == false then
            player2.isJumping = true
            player2.jumpPower = GameConstants.playerJump
            
            jumpSfx:stop()
            jumpSfx:play()
        end
    end
end

function startNewLevel(level)
    gameObjects = nil
    gameObjects = {}
    
    player1 = nil
    player2 = nil

    map       = loader.load(level)
    mainLayer = map.tileLayers["main"]
    
    topScreen.x = -((map.width * map.tileWidth) - GameConstants.screenWidth)
    topScreen.y = 0
    mapWidth    = map.width * map.tileWidth
    
    bottomScreen.x = 0
    bottomScreen.y = 300
    
    topColor    = GameConstants.topScreenColor
    bottomColor = GameConstants.bottomScreenColor
    
    player1 = Player:new(GameConstants.cameraOffset * 2, GameConstants.playerSpawnY, 32, 32)
    player1:loadResources()
    player1.currentSpeed = GameConstants.playerSpeed
    player1.name = "player1"
    
    player2 = Player:new(mapWidth - (GameConstants.cameraOffset * 2), GameConstants.playerSpawnY, 32, 32)
    player2:loadResources()
    player2.currentSpeed = GameConstants.playerSpeed
    player2.name = "player2"

    table.insert(gameObjects, player1)
    table.insert(gameObjects, player2)
    
    isPlaying           = true
    player1.direction.x = 1
    player2.direction.x = -1
    gravity = GameConstants.gravity
    
    flipTimer = 0
    
    isGameOver = false
    isSuccess  = false
    hasFlipped = false
end

function updatePlaying(dt)
    if isPaused == true then
        return
    end

    if flipTimer > 0 then
        flipTimer = flipTimer - dt
    end
    
    if goTimer > 0 then
        goTimer = goTimer - dt
    elseif isGameOver and goTimer <= 0 then
        myKeypressed = keyPressedStartScreen
    end

    if isGameOver == true or isSuccess == true or flipTimer > 0 then
        return
    end
    
    if backgroundMusic:isPaused() == true then
        backgroundMusic:resume()
    elseif backgroundMusic:isStopped() == true then
        backgroundMusic:play()
    end

    if player1.x + player1.width >= (map.width * map.tileWidth) - 32 and player2.x - player2.width <= 0 then
        isSuccess = true
        isPlaying = false
        
        myKeypressed = keyPressedStartScreen
        goTimer      = GameConstants.gameOverTimer
        
        currLevel = currLevel + 1
        if currLevel > #GameConstants.levels then
            currLevel    = 1
            myKeypressed = keyPressedStartScreen
            myUpdate     = nil
            myDraw       = drawStartScreen
        end
        
        return
    end
    
    if  player1.y + player1.height >= (map.height * map.tileHeight) - GameConstants.deathOffset or
        player2.y + player2.height >= (map.height * map.tileHeight) - GameConstants.deathOffset or
        player1.alive == false or player2.alive == false then

        isGameOver  = true
        goTimer     = GameConstants.gameOverTimer
        topColor    = GameConstants.gameOverColor
        bottomColor = GameConstants.gameOverColor
        currLevel   = 1
        myKeypressed = nil
        
        backgroundMusic:stop()
        deathSfx:stop()
        deathSfx:play()
        
        return
    end
    
    -- Update our game objects.
    for i = 1, #gameObjects do
        gameObjects[i]:update(dt)
    end

    -- Scroll our cameras.
    topScreen.x    = -(player2.x - (GameConstants.screenWidth - GameConstants.cameraOffset))
    bottomScreen.x = -(player1.x - GameConstants.cameraOffset)

    if player1.x >= player2.x and hasFlipped == false then
        topScreen.y    = 300
        bottomScreen.y = 0
        
        topColor, bottomColor = bottomColor, topColor
        hasFlipped = true
        
        flipTimer = GameConstants.flipTimer
        
        backgroundMusic:pause()
        flipSfx:stop()
        flipSfx:play()
    end
end

function drawPlaying()
    map.useSpriteBatch = false
    
    love.graphics.setColor(topColor)    
    love.graphics.rectangle("fill", 0, 0, GameConstants.screenWidth, (GameConstants.screenHeight / 2) - 16)
    
    love.graphics.setColor(bottomColor)
    love.graphics.rectangle("fill", 0, GameConstants.screenHeight / 2, GameConstants.screenWidth, (GameConstants.screenHeight / 2) - 16)

    -- NOTE: Why the hell was I math.flooring() topX, topY and bottomX, bottomY
        
    -- Draw the top screen (shows the player moving left).

    local topX, topY = topScreen.x, topScreen.y
    
    love.graphics.push()
    love.graphics.scale(1)
    love.graphics.translate(topX, topY)
    
    map:autoDrawRange(topX, topY, 1, 0)
    map:draw()
    
    love.graphics.pop()
    
    -- Draw the bottom screen (shows the player moving right).
    
    local bottomX, bottomY = bottomScreen.x, bottomScreen.y
    
    love.graphics.push()
    love.graphics.scale(1)
    love.graphics.translate(bottomX, bottomY)
    
    map:autoDrawRange(bottomX, bottomY, 1, 0)
    map:draw()
    
    love.graphics.pop()
    
    -- Draw the bottom objects.
    camera = {}
    camera.x      = bottomX
    camera.y      = bottomY
    camera.width  = GameConstants.screenWidth
    camera.height = GameConstants.screenHeight / 2
    
    for i = 1, #gameObjects do
        gameObjects[i]:draw(camera)
    end
    
    -- Draw the top objects.
    camera = {}
    camera.x      = topX
    camera.y      = topY
    camera.width  = GameConstants.screenWidth
    camera.height = GameConstants.screenHeight / 2
    
    for i = 1, #gameObjects do
        gameObjects[i]:draw(camera)
    end
    
    if flipTimer > 0 then
        love.graphics.setColor(255, 255, 255)
        love.graphics.draw(flipImage, 272, 172)
        return
    end
    
    if isGameOver == true then
        love.graphics.setColor(255, 255, 255)
        love.graphics.draw(gameOverImage, 272, 172)        
        return
    end
    
    if isSuccess == true then
        love.graphics.setColor(255, 255, 255)
        love.graphics.draw(successImage, 272, 172)
        return
    end
end