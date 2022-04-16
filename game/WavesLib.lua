PI_NUMBER=3.14159265359
MAX_HEIGHT=128
MAX_WIDTH=128

MAX_HEIGHT=50
MAX_WIDTH=128



function sinParticle(ox,oy,frq,fs, amp, color,repeatY)
    return {
        draw = function(self,tim)
            num = tim
            y = amp * sin(2 * PI_NUMBER * frq * num / fs)
            pset(ox, y + oy, color)
            toy = oy
            for i = 1,repeatY,1 
            do 
                toy += 1
                pset(ox, y + toy, color)
            end
        end 
    }
end

function sinSprite(ox,oy,frq,fs, amp, sprite)
    return {
        draw = function(self,tim)
            num = tim
            y = amp * sin(2 * PI_NUMBER * frq * num / fs)
            pset(ox, y + oy, color)
            spr(sprite,ox,y + oy)
        end 
    }
end 



function sinFactory(total_particles,ox,oy,frq,fs, amp, color,delayer,pofset,repeatY)
    return {
        total_particles = total_particles,
        ox = ox,
        oy = oy,
        particles = {},
        curX = ox,
        repeatY = repeatY,
        init = function(self)
            for i = 1,self.total_particles,1 
            do 
                add(self.particles, sinParticle(self.curX,self.oy,frq,fs, amp, color,self.repeatY))
                self.curX -= pofset
            end
        end,
        draw = function(self)
            ctime = time()
            for p in all(self.particles) do
                p:draw(ctime)
                ctime -= delayer
            end
        end 
    }
end 