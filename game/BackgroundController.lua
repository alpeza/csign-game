VELOCITY_FACTOR=2
POPING_EFFECT=SCREEN_WIDTH
DENSITY=3

TOP_BUILDINGS = {64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79}
MIDDLE_BUILDINGS = {80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95}
BOTTOM_BUILDINGS = {96,97,98,99,100,101,101,102,103,104,105,106,107,108,109,110,111}
BASE_PARALLAX=2

function Background()
    return {
        ypos = 0,
        seawave = sinFactory(260,128,128 - 50,50,500,3,12,0.01,1,1),
        bgo_ly1 = GenBackgroundObjects(CollisionMap(0,0,SCREEN_WIDTH,40),{8,9,10,11,12,13,14}, BASE_PARALLAX * VELOCITY_FACTOR,2*DENSITY),
        bgo_ly2 = GenBackgroundObjects(CollisionMap(0,4,SCREEN_WIDTH,40),{24,25,25,25,25,26,26,26,26,26,27,28}, BASE_PARALLAX/2 * VELOCITY_FACTOR,2*DENSITY),
        bgo_ly3 = GenBuildings(CollisionMap(0,65,SCREEN_WIDTH,40),BOTTOM_BUILDINGS, MIDDLE_BUILDINGS, TOP_BUILDINGS,BASE_PARALLAX/3 * VELOCITY_FACTOR,5*DENSITY),
        bgo_ly4 = GenBuildings(CollisionMap(0,70,SCREEN_WIDTH,20),BOTTOM_BUILDINGS, MIDDLE_BUILDINGS, TOP_BUILDINGS,BASE_PARALLAX/4 * VELOCITY_FACTOR,20*DENSITY),
        bgo_ly5 = GenBuildings(CollisionMap(0,70,SCREEN_WIDTH,10),BOTTOM_BUILDINGS, MIDDLE_BUILDINGS, TOP_BUILDINGS,BASE_PARALLAX/5 * VELOCITY_FACTOR,20*DENSITY),
        init = function(self)
            self.seawave:init()
            self.bgo_ly1:init()
            self.bgo_ly2:init()
            self.bgo_ly3:init()
            self.bgo_ly4:init()
            self.bgo_ly5:init()
        end,
        update = function(self)
            self.bgo_ly1:update()
            self.bgo_ly2:update()
            self.bgo_ly3:update()
            self.bgo_ly4:update()
            self.bgo_ly5:update()
        end,
        draw = function(self)
            self.bgo_ly5:draw()
            self.bgo_ly4:draw()
            self.bgo_ly3:draw()
            map(0, 0, 0, 0, 128, 32)
            self.bgo_ly2:draw()
            self.bgo_ly1:draw()
            self.seawave:draw()
        end
    }
end


function BackgroundObject(x,y, sprite,velocity)
    return {
        x = x + POPING_EFFECT,
        y = y,
        deleteable = false,
        sprite = sprite,
        velocity = velocity,
        draw = function(self)
            spr(self.sprite,self.x,self.y)
        end,
        update = function(self)
            self.x -= self.velocity
            if self.x + 16 < 0 then
                self.deleteable = true
            end
        end
    }
end

function ProceduralBuilding(x,y,bottomArray, middleArray, topArray, floors,velocity)
    return {
        x = x + POPING_EFFECT,
        y = y,
        deleteable = false,
        bottomArray = bottomArray,
        middleArray = middleArray,
        topArray = topArray,
        velocity = velocity,
        floors = floors,
        top_sprite = 0,
        middle_sprites = {},
        bottom_sprite = 0,
        floor_h=8,
        init = function(self)
            self.top_sprite = rnd(self.topArray)
            for i = 1,self.floors,1 do 
                add(self.middle_sprites, rnd(self.middleArray))
            end
            self.bottom_sprite = rnd(self.bottomArray)
        end,
        draw = function(self)
            _cury = self.y
            spr(self.bottom_sprite,self.x,_cury)
            _cury -= self.floor_h
            for f in all(self.middle_sprites) do 
                spr(f,self.x,_cury)
                _cury -= self.floor_h
            end
            spr(self.top_sprite,self.x,_cury)
        end,
        update = function(self)
            self.x -= self.velocity
            if self.x + 16 < 0 then
                self.deleteable = true
            end
        end
    }
end


function GenBackgroundObjects(collisionMapArea,sprites,velocity,total)
    return {
        area = collisionMapArea,
        objectArr = {},
        init = function(self)
            for i = 1,total,1 do 
                self:genElement()
            end
        end,
        genElement = function(self)
            xtmp = self.area.x + flr(rnd(self.area.maxX))
            ytmp = self.area.y + flr(rnd(self.area.maxY))
            add(self.objectArr, BackgroundObject(xtmp,ytmp,rnd(sprites),velocity))
        end,
        draw = function(self)
            for p in all(self.objectArr) do
                p:draw()
            end                  
        end,
        update = function(self)
            for p in all(self.objectArr) do
                if p.deleteable then 
                    del(self.objectArr, p)
                    self:genElement()
                else 
                    p:update()
                end
            end           
        end
    }
end


function GenBuildings(collisionMapArea,bottomArray, middleArray, topArray,velocity,total)
    return {
        area = collisionMapArea,
        objectArr = {},
        init = function(self)
            for i = 1,total,1 do 
                self:genBuilding()
            end
        end,
        genBuilding = function(self)
            xtmp = self.area.x + flr(rnd(self.area.maxX))
            ytmp = self.area.y
            _pb = ProceduralBuilding(xtmp,ytmp,bottomArray, middleArray, topArray, flr(rnd((self.area.maxY - self.area.y)/8)),velocity)
            _pb:init()
            add(self.objectArr,_pb)
        end,
        draw = function(self)
            for p in all(self.objectArr) do
                p:draw()
            end                  
        end,
        update = function(self)
            for p in all(self.objectArr) do
                if p.deleteable then 
                    del(self.objectArr, p)
                    self:genBuilding()
                else 
                    p:update()
                end
            end           
        end
    }
end