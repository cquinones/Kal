function keyPressedStartScreen(key)
    myUpdate     = updatePlaying
    myDraw       = drawPlaying
    myKeypressed = keyPressedPlaying
    
    backgroundMusic:stop()
    
    startNewLevel(GameConstants.levels[currLevel])
end

function drawStartScreen()
    love.graphics.setColor(255, 255, 255)
    love.graphics.draw(startScreenImage, 128, 44)
end