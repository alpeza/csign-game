function EnemyCharacter(x,y,sprites,velocity,life)
    return {
        x = x,
        y = y,
        lp = life,
        sprites = sprites,
        update = function()
            self.x -= velocity
        end,
    }
end