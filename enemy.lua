--
-- Project: Quest Wood
-- Description: 
--
-- Version: 1.0
-- Ivan Komlev
-- Copyright 2015 . All Rights Reserved.
-- 

------------------------------------------------------------------------
-- Construct castle (body type defaults to "dynamic" when not specified)

module(..., package.seeall)

local enemyTypes={};

local sequenceData = {
                
                {name="bite",frames= {11,12,11,11,4},time=500,loopCount = 1,loopDirection = "forward"},
                {name="run",frames= {1,2,3,4,5,6,7,8},time=500,loopCount = 0,loopDirection = "forward"},
                {name="walk",frames= {4},time=300,loopCount = 0,loopDirection = "forward"},
                {name="sleep",frames= {9,10},time=5000,loopCount = 0,loopDirection = "forward" }
}


enemyTypes[1]={image="small_cat.png",w=29,h=22,frames=12,sw=58,sh=132,sequenceData=sequenceData};

Sprites={};

function loadEnemySprites(self)
    Sprites={};
    for i,line in ipairs(enemyTypes) do
        local t=enemyTypes[i];
        local sheetData2 = { width=t.w, height=t.h, numFrames=t.frames, sheetContentWidth=t.sw, sheetContentHeight=t.sh }
        local index=#Sprites+1;
        Sprites[index]={};
        Sprites[index].imageSheet = graphics.newImageSheet("src/images/enemy/"..t.image, sheetData2 );
        Sprites[index].sequenceData=t.sequenceData;
    end
    
    
    
end

function removeSprites(self)
    if(Sprites~=nil)  then
        for i,line in ipairs(Sprites) do
            display.remove(Sprites[i])
            Sprites[i]=nil;
        end
    
        Sprites=nil;
    end
end

local function getsign(x)
    if(x>=0) then
        return 1;
    else
        return -1;
    end
end

local function enemyAttack(userX, enemyIndex)
    --print ("enemyIndex="..enemyIndex);
    local w=world.WorldEnemies[enemyIndex];
    local wa=w.animation;
    --turn to face
    if userX<w.x then 
        wa.xScale=-1;
        
        
    end
    
    local vx,vy=w:getLinearVelocity();
    w:setLinearVelocity( 0, vy);
    
    w.state=3;
    wa:setSequence( "bite" )
    wa:play()
    
    --mousecharacter:MouseFeelBad();
    --Shock mouse
    
    local mw=mousecharacter.wheel
    local attraction=-10
    local m=getsign(w.x-mw.x)
    local dx=attraction*10*m--(s.x-wheel.x)/200*
    
    --if mousecharacter.torso.xScale~=m then
        mousecharacter:StopMouse();
    --end
    mousecharacter:TurnCharacter(m,false)
    mw:applyForce(dx,-200, mw.x, mw.y)
    
    w:applyForce(dx/5,-50, w.x, w.y)
    
    
    local toDo= function()
       w.state=-1;
    end
    timer.performWithDelay(500,toDo,1)
    
    
    local en=thegame.CurrentSlot.Energy;
    en=en-100;
    if en<1 then
        en=1
    end
    
    thegame.CurrentSlot.Energy=en;
    mousecharacter:changeFace(0,100,{4,5,4,5,4,5})
    
end


local function onEnemySensor(self,event)
    if ( event.phase == "began" ) then
        local eom=event.other.myName
        if(eom=="character") then
            --print ("Monster");
            enemyAttack(event.other.x, event.target.bodyIndex);
        end
    end
    
end

function addSensors(self)
    for i,line in ipairs(world.WorldEnemies) do
        local s=world.WorldEnemies[i];
        s.collision = onEnemySensor;
        s:addEventListener( "collision", s);
    end
end


local function distanceToUser(w,avx)
    local u=mousecharacter.wheel;
    
    local dx=math.floor(u.x-w.x);
    local dy=math.abs(math.floor(u.y-w.y));
    --print("dx="..dx)
    --print("dy="..dy)
    if dy<20 then
        
        --print("avx="..avx)
        if math.abs(dx)<100 and avx<30 then
            local d=getsign(dx);
            w:applyForce(2*d,0, w.x, w.y)
        end
    end
    
end


local function updateAnimationPosition()
    
    
    for i,line in ipairs(world.WorldEnemies) do
        
        local w=world.WorldEnemies[i];
        local vx,vy=w:getLinearVelocity();
        local wa=w.animation;
        local vx2=math.floor(vx);
        local avx=math.abs(vx2);
        
        distanceToUser(w,avx);
            
        local d=getsign(vx2);
        
        
        if w.state~=3 then
        
        if avx<5 then
            --w:setLinearVelocity( 0, vy)
            
            if w.state~=0 then
                --w.oldState=w.state;
                w.state=0;
                
                wa:setSequence( "sleep" )
                wa:play()
            end
        elseif avx<20 then
            --print ("Walking");
            --if(avx<20) then
                w:setLinearVelocity(20*d, vy)
            --end
            
            if w.state~=1 then
                --w.oldState=w.state;
                w.state=1;
                wa:setSequence( "walk" )
                wa:play()
            end
        else
            --print ("Running");
            if w.state~=2 then
                --w.oldState=w.state;
                w.state=2;
                wa:setSequence( "run" )
                wa:play()
            end
            
            
            --if avx>10 then
            local s=avx*0.03;
            if s<0.1 then
                s=0.1
                
            end
            wa.timeScale=s
            --elseif vx>avx then
                --wa.timeScale=2
            --end
        end
        
        end --if w.state~=3 then
        
        if w.state~=0 then
            
            wa.xScale=d;
        end
        
        wa.x=world.WorldEnemies[i].x;
        wa.y=world.WorldEnemies[i].y;
    end
    
end

function update(left)
    updateAnimationPosition();
end



