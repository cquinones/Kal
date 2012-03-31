require 'game_objects'
require 'constants'
require 'start_screen'
require 'in_game'

loader      = require 'AdvTiledLoader/Loader'
loader.path = "maps/"
map         = nil
mainLayer   = nil

topScreen = {}
topScreen.x = 0
topScreen.y = 0

topColor = GameConstants.topScreenColor

bottomScreen = {}
bottomScreen.x = 0
bottomScreen.y = 300

bottomColor = GameConstants.bottomScreenColor

mapWidth    = 0
isPlaying   = false
isGameOver  = false
isSuccess   = false
hasFlipped  = false
isPaused    = false
flipTimer   = 0
goTimer     = 0
gameObjects = {}
player1     = nil
player2     = nil
currLevel   = 1
gravity     = 0

-- Assets:
backgroundMusic  = nil
jumpSfx          = nil
flipSfx          = nil
deathSfx         = nil
startScreenImage = nil
flipImage        = nil
gameOverImage    = nil
successImage     = nil

-- Game state functions:
myKeypressed = keyPressedStartScreen
myUpdate     = nil
myDraw       = drawStartScreen

-- For loading our resources (done only once).
function love.load()
    love.graphics.setMode(GameConstants.screenWidth, GameConstants.screenHeight, GameConstants.fullscreen)
    love.graphics.setCaption("Kal")

    love.graphics.setBackgroundColor(0, 0, 0);
    
    -- Load our messages and screens:
    startScreenImage = love.graphics.newImage("images/kal_intro_screen.png")
    flipImage        = love.graphics.newImage("images/flip.png")
    gameOverImage    = love.graphics.newImage("images/game_over.png")
    successImage     = love.graphics.newImage("images/success.png")

    backgroundMusic = love.audio.newSource("music/agda.xm", "stream")
    backgroundMusic:setLooping(true)
        
    jumpSfx  = love.audio.newSource("sfx/jump_01.wav", "static")
    flipSfx  = love.audio.newSource("sfx/flip_01.wav", "static")
    deathSfx = love.audio.newSource("sfx/death_01.wav", "static")
end

-- Called continuosly (game logic is done here).
function love.update(dt)
    if myUpdate ~= nil then myUpdate(dt) end
end

-- Here we draw our stuffs.
function love.draw()
    if myDraw ~= nil then myDraw() end
end

-- Detect key presses and handle input.
function love.keypressed(key, unicode)
    if myKeypressed ~= nil then myKeypressed(key) end
    
    if key == "escape" then
        love.event.push("q")
    end
end

-- Detect mouse release.
function love.mousepressed(x, y, button)
end

-- Sent when we lose or gain focus.
function love.focus(f)
    isPaused = not f
    love.audio.pause()
end

-- Sent when the user clicks the close button.
function love.quit()
end