require 'constants'

GameObject = {}

function GameObject:new(x, y, width, height)
    object = {}
    
    setmetatable(object, self)
    self.__index = self

    object.x          = x
    object.y          = y
    object.width      = width
    object.height     = height
    object.name       = "kal"

    object.direction   = {}
    object.direction.x = 0
    object.direction.y = 0
    
    object.currentSpeed = 0

    object.sprite     = nil
    object.alive      = true
    object.color      = { 0, 0, 0, 255 }
    
    object.isJumping  = false
    object.isFalling  = false
    object.jumpPower  = 0
    
    return object
end

function GameObject:draw(camera)
    love.graphics.setColor(self.color)

    local scaleX = 2
    local xPos = self.x + camera.x
    
    if self.direction.x < 0 then
        scaleX = -scaleX
        xPos   = xPos + self.width
    end
    
    love.graphics.draw(self.sprite, xPos, self.y + camera.y, 0, scaleX, 2)
end

Player = GameObject:new()

function Player:loadResources()
    self.sprite = love.graphics.newImage("images/arnold.png")
    self.sprite:setFilter("nearest", "nearest")
end

function Player:update(dt)
    if self.isJumping == true then
        self.jumpPower = self.jumpPower - (gravity * dt)
        
        -- TODO: Change how jump power is affected by gravity.
        --       I probably should not be.
            
        if self.jumpPower <= 0 then
            self.isJumping = false
            self.jumpPower = 0
        end
    end

    local new_x           = self.x + (self.direction.x * GameConstants.playerSpeed * dt)
    local new_direction_y = (self.direction.y) + ((gravity - self.jumpPower) * dt)
    local new_y           = self.y + (new_direction_y * GameConstants.playerSpeed * dt)
    
    local new_tile_x = nil
    local cur_tile_x = nil
    
    if self.direction.x > 0 then
        new_tile_x = math.floor((new_x + self.width) / map.tileWidth)
        cur_tile_x = math.floor((self.x + self.width) / map.tileWidth)
    else
        new_tile_x = math.floor((new_x) / map.tileWidth)
        cur_tile_x = math.floor((self.x) / map.tileWidth)
    end
    
    local new_tile_y = math.floor((new_y + self.height) / map.tileHeight)
    local cur_tile_y = math.floor((self.y + self.height) / map.tileHeight)
    
    if new_tile_x + 1 > map.width or new_tile_x + 1 <= 0 or new_tile_y + 1 > map.height or new_tile_y + 1 <= 0 then
        return
    end

    -- TODO: Check for the mapWidth and mapHeight before indexing into the tiles!!!
    local bottomTile = map.tiles[mainLayer.tileData[new_tile_y + 1][cur_tile_x + 1]]
    local rightTile  = map.tiles[mainLayer.tileData[cur_tile_y + 1][new_tile_x + 1]]
    
    -- TODO: It looks like we fall through bottom corner tiles... makes it hard
    --       to jump at the last minute.
    if bottomTile ~= nil and bottomTile.properties.collidable == nil then
        self.y = new_y
        self.isFalling = true
    else
        self.isJumping = false
        self.isFalling = false
    end

    if rightTile ~= nil and rightTile.properties.collidable == nil then
        self.x = new_x
    else
        self.alive = false
    end
end