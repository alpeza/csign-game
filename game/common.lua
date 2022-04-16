SCREEN_HEIGHT=128
SCREEN_WIDTH=128
PICKUP_POWERUP_BULLET_BULLET_VELOCITY = 3
PICKUP_POWERUP_BULLET_BULLET_SPRITE = 21
PARTICLES_MAX_LIFE_TIME_SECONDS = 0.5

function Vector2(x,y)
    return {
        x = x,
        y = y
    }
end 


function timer()
    return {
        initTime = 0,
        finishtime = 0,
        getCurrent = function(self)
            return time() - self.initTime
        end,
        sleep = function(self,seconds)
            if self.initTime == 0 then
                self.initTime = time()
                self.finishtime = self.initTime + seconds
            end
        end,
        isFinished = function(self)
            if time() > self.finishtime then 
                self.finishtime = 0
                self.initTime = 0
                return true 
            else 
                return false
            end 
        end 
    }
end 

function CollisionMap(x,y,width,height)
    return {
        x = x,
        y = y,
        maxX = x + width,
        maxY = y + height,
        okPositionX = function(self, xp)
            xok = false 
            if xp > self.x and xp < self.maxX then 
                xok = true
            end 
            return xok
        end,
        okPositionY = function(self, yp)
            yok = false 
            if yp > self.y and yp < self.maxY then 
                yok = true
            end 
            return yok
        end
    }
end