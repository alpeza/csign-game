-- Sistema variado de particulas para
-- PICO8
function Particles()
    return {
        effects = {},
        init = function(self)
            local a= 1
        end,
        update = function(self)
            for fx in all(self.effects) do
                --lifetime
                fx.t+=1
                if fx.t>fx.die then del(effects,fx) end
                --color depends on lifetime
                if fx.t/fx.die < 1/#fx.c_table then
                    fx.c=fx.c_table[1]
                elseif fx.t/fx.die < 2/#fx.c_table then
                    fx.c=fx.c_table[2]
                elseif fx.t/fx.die < 3/#fx.c_table then
                    fx.c=fx.c_table[3]
                else
                    fx.c=fx.c_table[4]
                end
                --physics
                if fx.grav then fx.dy+=.5 end
                if fx.grow then fx.r+=.1 end
                if fx.shrink then fx.r-=.1 end
                --move
                fx.x+=fx.dx
                fx.y+=fx.dy
                -- Eliminacion
                if time() > fx.initTime + PARTICLES_MAX_LIFE_TIME_SECONDS then del(self.effects,fx) end
            end
           

        end,
        draw = function(self)
            for fx in all(self.effects) do
                --draw pixel for size 1, draw circle for larger
                if fx.r<=1 then
                    pset(fx.x,fx.y,fx.c)
                else
                    circfill(fx.x,fx.y,fx.r,fx.c)
                end
            end
        end,
        add_fx = function (self,x,y,die,dx,dy,grav,grow,shrink,r,c_table)
            local fx={
                x=x,
                y=y,
                t=0,
                initTime = time(),
                die=die,
                dx=dx,
                dy=dy,
                grav=grav,
                grow=grow,
                shrink=shrink,
                r=r,
                c=0,
                c_table=c_table
            }
            add(self.effects,fx)
        end,
        effect_explode = function(self,x,y,r,c_table,num)
            for i=0, num do
                self:add_fx(
                    x,         -- x
                    y,         -- y
                    30+rnd(25),-- die
                    rnd(2)-1,  -- dx
                    rnd(2)-1,  -- dy
                    false,     -- gravity
                    false,     -- grow
                    true,      -- shrink
                    r,         -- radius
                    c_table    -- color_table
                )
            end
        end,
        effect_fire = function(self,x,y,w,c_table,num)
            for i=0, num do
                --settings
                self:add_fx(
                    x+rnd(w)-w/2,  -- x
                    y+rnd(w)-w/2,  -- y
                    30+rnd(10),-- die
                    0,         -- dx
                    -.5,       -- dy
                    false,     -- gravity
                    false,     -- grow
                    true,      -- shrink
                    2,         -- radius
                    c_table    -- color_table
                )
            end
        end,
        effect_tail = function(self,x,y,w,c_table,num)
            for i=0, num do
                self:add_fx(
                    x+rnd(w)-w/2,  -- x
                    y+rnd(w)-w/2,  -- y
                    40+rnd(30),  -- die
                    0,         -- dx
                    0,         -- dy
                    false,     -- gravity
                    false,     -- grow
                    false,     -- shrink
                    1,         -- radius
                    c_table    -- color_table
                )
            end        
        end,
        effect_bullet = function(self,x,y,w,c_table,num)
            for i=0, num do
                self:add_fx(
                    x+rnd(w)-w/10,  -- x
                    y+rnd(w)-w/10,  -- y
                    30+rnd(10),  -- die
                    0,         -- dx
                    .2,       -- dy
                    false,     -- gravity
                    true,     -- grow
                    true,     -- shrink
                    1,         -- radius
                    c_table    -- color_table
                )
            end        
        end
    }
end 