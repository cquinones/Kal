GameConstants = {}

-- Screen and canvas configuration.
GameConstants.screenWidth     = 800
GameConstants.screenHeight    = 600
GameConstants.fullscreen      = false
GameConstants.playFieldOffset = 0
GameConstants.flipTimer       = 2

-- Player properties.
GameConstants.playerSpawnY  = 128
GameConstants.playerSpeed   = 200
GameConstants.playerWidth   = 32
GameConstants.playerHeight  = 32
GameConstants.playerJump    = 320
GameConstants.jumpIncrement = GameConstants.playerJump / 2

-- Camera properties.
GameConstants.cameraOffset = 64
GameConstants.scrollSpeed  = 100

-- World properties.
GameConstants.gravity = 200
GameConstants.deathOffset = 16

-- Game / Level properties.
GameConstants.levels            = { "level_01.tmx", "level_02.tmx", "level_03.tmx", "level_04.tmx", "level_05.tmx" }
GameConstants.topScreenColor    = { 0, 127, 127, 255 }
GameConstants.bottomScreenColor = { 255, 106, 0, 255 }
GameConstants.gameOverColor     = { 192, 192, 192, 255 }
GameConstants.gameOverTimer     = 1