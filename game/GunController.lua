function Bullet(x,y,velocity,sprite)
    return {
        x = x,
        y = y,
        w = 8,
        h = 8,
        sprite = sprite,
        velocity = velocity,
        particles = Particles(),
        particles_trail_width = 4,
        particles_trail_colors = {14,1,0},
        particles_trail_amount = 2,
        initTime = time(),
        enabled = true,
        isEnabled = function(self)
            return self.enabled
        end,
        draw = function(self)
            if self.enabled then
                spr(self.sprite,self.x,self.y)
            end
            self.particles:draw()
        end,
        update = function(self)
            -- self.orientation:print()
            self.x +=  1 * self.velocity 
            --self.y +=  -1 * self.velocity
            -- Particulas
            self.particles:update()
            self.particles:effect_bullet(self.x,self.y,
            self.particles_trail_width,self.particles_trail_colors,
            self.particles_trail_amount)
        end
    }
end 

function deepcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[deepcopy(orig_key)] = deepcopy(orig_value)
        end
        setmetatable(copy, deepcopy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

bulletArray = {}
function GunController()
    return {
        current_sprite = 76,
        bullet_sfx = 3,
        position = Vector2(13*8,0),
        t = timer(),
        animTimer = timer(),
        canShotFlag = true,
        cbulletArray = bulletArray,
        bulletDuration = 10,
        -- +++++ Functions ++++++
        draw = function(self)
            spr(self.current_sprite,self.position.x,self.position.y)
            for bullet in all(self.cbulletArray) do 
                bullet:draw()
            end
        end,
        update = function(self, cpos)
            self.posicion = cpos
            self:mainFunction()
            -- Actializamos la posición de los bullets 
            for bullet in all(self.cbulletArray) do 
                bullet:update()
            end 
        end,
        mainFunction = function(self)
            -- Función de disparo
            if btnp(🅾️) and self.canShotFlag then
                sfx(self.bullet_sfx)
                -- local tmpc = deepcopy(c)
                add(self.cbulletArray,Bullet(self.posicion.x,self.posicion.y,PICKUP_POWERUP_BULLET_BULLET_VELOCITY,PICKUP_POWERUP_BULLET_BULLET_SPRITE))
                self.canShotFlag = false
            end 
            if not btn(🅾️) then
                self.canShotFlag = true
            end 
      
           -- Control de borrado
           for bullet in all(self.cbulletArray) do 
                if time() > bullet.initTime +  self.bulletDuration then
                    del(self.cbulletArray, bullet)
                end 
           end 
        end 
    }
end