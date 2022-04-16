function EnemyCharacter(x,y,sprites,velocity)
    return {
        x = x,
        y = y,
        sprites = sprites,
        update = function()
            self.x -= velocity
        end,
    }
end