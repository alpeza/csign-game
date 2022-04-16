function can_move(x,y,w,h,flag)
    if (solid(x,y,flag)) return false
    if (solid(x+w,y,flag)) return false
    if (solid(x,y+h,flag)) return false
    if (solid(x+w,y+h,flag)) return false
      return true
 end
 
 function solid(x,y,mflag)
    local map_x=flr(x/8)
    local map_y=flr(y/8)
    local map_sprite=mget(map_x,map_y)
    local flag=fget(map_sprite)
    return flag==mflag
 end
 

function TableCharacter(sprite)
   return {
      sprite = sprite,
      draw = function(self,x,y, freq)
         spr(self.sprite,x,y)
         sfb = sinFactory(100,x,y +2 ,freq,100,2,7,0.01,1,0)
         sfb:init()
         sfb:draw()
      end
   }
end


function SurferCharacter(sprites,collisionMap,tableCharacter)
   return {
       pos = Vector2((collisionMap.x + collisionMap.maxX)/2 ,(collisionMap.y + collisionMap.maxY)/2),
       _nx = 0,
       _ny = 0,
       tableb = tableCharacter,
       cmap = collisionMap,
       gunController = GunController(),
       overlaps = 0,
       w = 7,
       h = 7,
       velocity=3,
       sprites=sprites,
       current_sprite = 1,
       freq=40,
       draw = function(self)
          spr(self.sprites[self.current_sprite],self.pos.x,self.pos.y)
          self.tableb:draw(self.pos.x, self.pos.y + self.h + 1,self.freq)
          self.gunController:draw()
       end,
       update = function(self)
          self.current_sprite=5
          self.freq = 40
          if (btn(⬅️)) then
             self._nx-=self.velocity
             self.current_sprite=3
          elseif (btn(➡️)) then
             self.current_sprite=4
             self._nx+=self.velocity
             self.freq = 70
          elseif (btn(⬆️)) then
             self._ny-=self.velocity
             self.current_sprite=1
          elseif (btn(⬇️)) then
             self._ny+=self.velocity
             self.current_sprite=2
          end
          -- validamos las colisiones
          if self.cmap:okPositionX(self.pos.x+self._nx) then
            self.pos.x+=self._nx
          end
          if self.cmap:okPositionY(self.pos.y+self._ny) then
            self.pos.y+=self._ny
          end 

          self._nx,self._ny=0,0
          -- Acciones de disparo
          self.gunController:update(Vector2(self.pos.x, self.pos.y + 10))
          
       end
    }
 end