--
-- Project: Brave Mouse
-- Description: 
--
-- Version: 1.0
-- Ivan Komlev
-- Copyright 2012 . All Rights Reserved.
-- 

------------------------------------------------------------------------
-- Construct castle (body type defaults to "dynamic" when not specified)

module(..., package.seeall)

--Orientation=0
--OrientationText="no"

local GameX_Last=-1;
local GameY_Last=-1;

WorldEnemies={};
WorldSprites={};
WorldWalls={}
--BGSprites={}

TrapBodyIndex=nil

TrapIsOpen=true
--ScreenMinX=0
--ScreenMaxX=0
local InfoBoxGroup=nil;
local EnergyBar=nil;

local CoinCounter=nil;
local CoinCounter_Shadow=nil;
local CoinIcons=nil;
local HeartIcons=nil;
local HeartState=1;
local CoinState=1;

ScreenXd=0

--NumberOfItems=0
--NumberOfItemsUsed=0

local WatchVisible=false
--local WatchScreenX=nil
if(WatchVisible)then
    local WatchCenter=nil
    local CurrentWatchCenter=nil
end

local CoinTimers={}
local CoinIconTimers={}


local function RemoveCoinIconTimers()
    
    if CoinIconTimers~=nil then 
        for i=1, #CoinIconTimers  do
            
            timer.cancel(CoinIconTimers[i])
            CoinIconTimers[i]=nil
            
        end
    end
    i=nil
    CoinIconTimers={}
end

local function RemoveCoinTimers()

    if CoinTimers~=nil then 
        for i=1, #CoinTimers  do
            
            timer.cancel(CoinTimers[i])
            CoinTimers[i]=nil
            
        end
    end
    i=nil
    CoinTimers={}
end


function moveInfoBoxGroup(self,bag_or_store)
    
    if advertising.ShowAdvertising then
        if bag_or_store then
            InfoBoxGroup.x=75
            InfoBoxGroup.y=-30
        else
            InfoBoxGroup.x=0
            InfoBoxGroup.y=0
        end    
    
    end
    
    
end

--[[]
local function enemyTouch(event)
    if(event.phase== "ended") then
        print ("Enemy Touch");
    end
end
--]]
local function BodyTouch(event)
    
    if(not buttons.isGamePlaying or buttons.physics_paused or buttons.GameMode~=1) then
        return;
    end
        
        
    if(event.phase== "ended") then

        local index=event.target.bodyIndex;
        --if index==-10000 then
        --    print ("Enemy");
        --end
        
        local abs=math.abs
        
        local dX=abs(WorldSprites[index].x-mousecharacter.torso.x);
        local dY=abs(WorldSprites[index].y-mousecharacter.torso.y);
        local d=math.floor(math.sqrt(dX*dX+dY*dY));
        
        if(d<50) then
            if WorldSprites[index].myName=="door" then
                thegame:ShowMessage("Opening the door...",3);
                        
                storehouse:ShowStoreWindow();
                
                
            else
                thegame:TakeBody(index);
            end
            
        else
            if WorldSprites[index].myName=="door" then
                thegame:ShowMessage("The door is too far.",2);
            else
                thegame:ShowMessage("Too far.",2);
            end
            

        end
        
    end
end

function addTouchListenersToSpecialBodies(self,index)
    if index==nil then
        
    
        for i,line in ipairs(WorldSprites) do
            local n=WorldSprites[i].myName;
            
            if(n=="bag" or n=="food" or n=="shoes" or n=="gem" or n=="door" or n=="ball") then
                WorldSprites[i]:addEventListener( "touch", BodyTouch);
            end
        
        end
    else
        WorldSprites[index]:addEventListener( "touch", BodyTouch);
    end
    
    
    --if(body_name=="bag") then
      
    --end
end

--[[]
function addTouchListenersToEnemy(self,index)
    if index==nil then
        
    
        for i,line in ipairs(WorldEnemies) do
            --local n=WorldEnemies[i].myName;
            
                print ("cat");
                
            

                WorldEnemies[i]:addEventListener( "touch", enemyTouch);

        
        end
    else
        WorldEnemies[index]:addEventListener( "touch", enemyTouch);
    end
    
    
    --if(body_name=="bag") then
      
    --end
end
--]]


local WinLoseTimer=nil

function StopWinLose()
    if WinLoseTimer then
        timer.cancel(WinLoseTimer) 
        WinLoseTimer=nil
    end
end

--local isWaterBublesPlaying=false;




local function updateEnergyBar()
    if(mousecharacter.wheel==nil) then
        return;
    end

    if(not buttons.isGamePlaying or buttons.GameMode~=1) then
        return;
    end
    
    
    

    local o =150
    if(mousecharacter.wheel.y>levels.GameScreenHeight+300) then

        RemoveCoinIconTimers()
        RemoveCoinTimers()
        
        --if(isWaterBublesPlaying==false ) then      
          --          isWaterBublesPlaying=true;
                    loadsounds:PlayWaterSplashSound(2)
        --end
        
        
        loadsounds:PlayTryAgainSound(2);
        
            
        loseform:Lost("drown");--task_strings, TaskItemCount,NumberOfTasks, Answer)
    elseif(thegame.CurrentSlot.Energy<100) then    
        RemoveCoinIconTimers()
        RemoveCoinTimers()
        
        loadsounds:PlayTryAgainSound(1)
        loseform:Lost("noenergy");--NO MORE ENERGY
        
        
    elseif(thegame.CurrentSlot.Energy<333) then
        EnergyBar:setFillColor(255,0,0, o);
    elseif(thegame.CurrentSlot.Energy>=333 and thegame.CurrentSlot.Energy<666) then
        EnergyBar:setFillColor(255,255,0, o);
    elseif(thegame.CurrentSlot.Energy>=667 and thegame.CurrentSlot.Energy<=1000) then
        EnergyBar:setFillColor(0,255,0, o);
    elseif(thegame.CurrentSlot.Energy>1000 and thegame.CurrentSlot.Energy<1333) then
        EnergyBar:setFillColor(255,0,255,o);
    elseif(thegame.CurrentSlot.Energy>=1334 and thegame.CurrentSlot.Energy<1666) then
        EnergyBar:setFillColor(255,100,255, 255);
    elseif(thegame.CurrentSlot.Energy>=1667 and thegame.CurrentSlot.Energy<1950) then
        EnergyBar:setFillColor(255,50,50, 255);
    elseif(thegame.CurrentSlot.Energy>=1950 and thegame.CurrentSlot.Energy<2000) then
        EnergyBar:setFillColor(100,0,0, 255);
    elseif(thegame.CurrentSlot.Energy>=2000) then

        RemoveCoinIconTimers()
        RemoveCoinTimers()
        
        loadsounds:PlayTryAgainSound(1)
        

        
        loseform:Lost("overeat");--task_strings, TaskItemCount,NumberOfTasks, Answer)
        return
    end
    
    
    
    --print ("e="..thegame.CurrentSlot.Energy);
    local sc=thegame.CurrentSlot.Energy*0.1-10
    --print ("sc="..sc);
    EnergyBar.xScale=sc--sc-100;
    
    --mousecharacter.MouseAirRunForce=thegame.CurrentSlot.Energy*0.03;
    mousecharacter.MouseRunForce=thegame.CurrentSlot.Energy*0.25;
    if(mousecharacter.MouseRunForce<150) then
        mousecharacter.MouseRunForce=150
    end
    --print ("mrf="..mousecharacter.MouseRunForce)
    mousecharacter.MouseJumpForce=400+thegame.CurrentSlot.Energy*0.5;
        
    if thegame.CurrentSlot.CurrentShoes==4 then
        mousecharacter.MouseRunLimit=thegame.CurrentSlot.Energy*0.2;        
    else
        mousecharacter.MouseRunLimit=thegame.CurrentSlot.Energy*0.1;
    end
    
    
end


local function UpdateCoinAnimation()
    if(not buttons.isGamePlaying or buttons.GameMode~=1) then
        return;
    end
    
    local CoinState_=1;
    
    
    CoinState=CoinState+1;
    if(CoinState>6) then
        CoinState=1;
    end
    
    if(CoinState>4) then
        CoinIcons.xScale=-1;
        CoinState_=8-CoinState;
    else
        CoinIcons.xScale=1;
        CoinState_=CoinState;
    end
    
    
    
    CoinIcons:stopAtFrame(CoinState_);
    
    local bitHeart=false
    
    if(thegame.CurrentSlot.Energy<333) then
        if(CoinState==1) then
            bitHeart=true;
        end
    elseif(thegame.CurrentSlot.Energy>=333 and thegame.CurrentSlot.Energy<666) then
        if(CoinState==1 or CoinState==4) then
            bitHeart=true;
        end
    elseif(thegame.CurrentSlot.Energy>=667 and thegame.CurrentSlot.Energy<=1000) then
        if(CoinState==1 or CoinState==3 or CoinState==5) then
            bitHeart=true;
        end
    elseif(thegame.CurrentSlot.Energy>1000 and thegame.CurrentSlot.Energy<1333) then
        
        if(CoinState==1 or CoinState==3 or CoinState==5 or CoinState==6) then
            bitHeart=true;
        end
    elseif(thegame.CurrentSlot.Energy>=1334 and thegame.CurrentSlot.Energy<1666) then
        if(CoinState==1 or CoinState==2 or CoinState==3 or CoinState==5 or CoinState==6) then
            bitHeart=true;
        end
    elseif(thegame.CurrentSlot.Energy>=667) then
        bitHeart=true;
    end

    if bitHeart then 
        HeartState=HeartState+1
        if HeartState>2 then
            HeartState=1
        end
        local HeartState_=1;
        
        
        if(HeartState==1) then
            HeartState_=1;
        end
        
        
        if(HeartState==2) then
            if(thegame.CurrentSlot.Energy>1000) then
                HeartState_=3;
                
            else
                HeartState_=2;
                
            end
        end
        
        --[[
        if(HeartState==3) then
            HeartState_=1;
        end
        
        if(HeartState==4) then
            HeartState_=3;
        end
        ]]--
        HeartIcons:stopAtFrame(HeartState_);
    end
    
    if buttons.physics_paused==false then
        if(thegame.CurrentSlot.Energy>1500 and thegame.CurrentSlot.CurrentShoes==1) then
            
            thegame.CurrentSlot.Energy=thegame.CurrentSlot.Energy-1
        elseif(thegame.CurrentSlot.Energy<900) then
            thegame.CurrentSlot.Energy=thegame.CurrentSlot.Energy+1
        end
    
    end
    
    updateEnergyBar();
    
end

function PrepareCoins(self, x,y)
    InfoBoxGroup = display.newGroup();
    thegame.background_veryfront:insert (InfoBoxGroup);
    
    
    RemoveCoinIconTimers();
    
    if(CoinIcons) then
        display.remove(CoinIcons)
        CoinIcons=nil
    end
    
    local folder="src/images/misc/"
    --CoinState=1
    CoinIcons = movieclip.newAnim({ folder.."coin1a.png", folder.."coin2a.png", folder.."coin3a.png", folder.."coin4a.png"},16,16,0.5,0.5)
    --CoinIcons:set ReferencePoint(display.CenterCenterReferencePoint);
    
    CoinIcons.x=x-80
    CoinIcons.y=y-3
    
    
    HeartIcons = movieclip.newAnim({ folder.."heart1.png", folder.."heart2.png", folder.."heart3.png"},16,16,0.5,0.5)
    --HeartIcons:set ReferencePoint(display.CenterCenterReferencePoint);
    
    HeartIcons.x=thegame.InfoBox.line2[1]+10--+72;
    HeartIcons.y=thegame.InfoBox.line2[2]+0;
    
    InfoBoxGroup:insert (CoinIcons);
    InfoBoxGroup:insert (HeartIcons);
    
    EnergyBar = display.newImageRect("src/images/misc/energy_bar.png",1, 16);
    
    EnergyBar.anchorX=0;
    --EnergyBar:set ReferencePoint( display.CenterLeftReferencePoint)
    EnergyBar.x=thegame.InfoBox.line2[1]+30
    EnergyBar.y=thegame.InfoBox.line2[2]
    InfoBoxGroup:insert (EnergyBar);
    
    UpdateCoinAnimation();
    
    
    
    
    
    CoinIconTimers[#CoinIconTimers+1]=timer.performWithDelay(100,UpdateCoinAnimation,0)
    
    
    --
    
   

   
end


function updateCoinCounter(self,x,y,remove_coin_timers)
    
    
    --local x=315
    --local y=29
    local d=15-80
    
    --if CoinIcon==nil then
    
    --end
    
    if CoinCounter~=nil then
        
        --if(remove_coin_timers) then
        --  RemoveCoinTimers()
        --end
        
        display.remove(CoinCounter)
        CoinCounter=nil
        
        display.remove(CoinCounter_Shadow)
        CoinCounter_Shadow=nil
        
        
        
    end
    
    --PrepareCoins(x,y,insert_to);
    
    --CoinIcons = display.newImageRect("src/images/misc/coin.png",16, 16)
    
    --CoinIcon.x=x
    --CoinIcon.y=y-1
    
    --insert_to:insert (CoinIcon)
    
    local txt="x"..string.format("%i", thegame.CurrentSlot.ScoreCoins)
    local fontName;
    --if system.getInfo( "platformName" ) == "iPhone OS" then
    --      fontName=native.systemFont;
    --else
    fontName="Colophon DBZ";
    --end
    --fontName="Grinched";
    
    CoinCounter_Shadow = display.newText(txt, 0, 0, fontName,24 )
    CoinCounter_Shadow.anchorX=0;
    --CoinCounter_Shadow:set ReferencePoint( display.CenterLeftReferencePoint)
    CoinCounter_Shadow.x=x+1+d
    CoinCounter_Shadow.y=y+1-2
    CoinCounter_Shadow:setTextColor(0,0,0)
    InfoBoxGroup:insert (CoinCounter_Shadow)
    
    CoinCounter = display.newText(txt, 0, 0, fontName,24 )
    CoinCounter.anchorX=0;
    --CoinCounter:set ReferencePoint( display.CenterLeftReferencePoint)
    CoinCounter.x=x+d
    CoinCounter.y=y-2
    CoinCounter:setTextColor(255,234,0)
    InfoBoxGroup:insert (CoinCounter) 
    
end


function addCoins(self,number,x,y)
    
    
    
    local delay=0
    local t=1000/math.abs(number)
    if t<1 then 
        t=1
    end
    
    
    --if(#CoinTimers>0) then
        delay=0--t*#CoinTimers+t*5
    --end

    --CoinTimers[#CoinTimers+1] = timer.performWithDelay( delay, RemoveCoinTimers, 1 )
    -- RemoveCoinTimers();
    --RemoveCoinTimers();
    for i=1,math.abs(number) do
        
        local tIndex=#CoinTimers+1
        
        local toDo=function()
            
            
            if number>0 then
                thegame.CurrentSlot.ScoreCoins=thegame.CurrentSlot.ScoreCoins+1;
            else
                thegame.CurrentSlot.ScoreCoins=thegame.CurrentSlot.ScoreCoins-1;
            end
                

            updateCoinCounter(nil,x,y,false);
            
            --if #CoinTimers==tIndex then
            --  RemoveCoinTimers();
            --end
        end

        CoinTimers[#CoinTimers+1] = timer.performWithDelay( delay+t*i, toDo, 1 )
    end
    
end


function clearWorld(self)
    
    
    
    
    if EnergyBar~=nil and EnergyBar.x~=nil then
        display.remove(EnergyBar);
        EnergyBar=nil;
    end
    
    
    if(WatchVisible)then
        display.remove(WatchCenter)
        display.remove(CurrentWatchCenter)
        WatchCenter=nil
        CurrentWatchCenter=nil
    end
    
    thegame:StopAllPlaying()
    RemoveCoinTimers()
    
    
    thegame:RemoveSoundListeners()
    
    
    
    
    for i,line in ipairs(WorldEnemies) do
        if(WorldEnemies[i]~=nil) then
            WorldEnemies[i].isBodyActive = false
            WorldEnemies[i].y=10000
        end
        display.remove(WorldEnemies[i])
        WorldEnemies[i]=nil;
    end
    
    WorldEnemies=nil--{}
    
    
    
    
    for i,line in ipairs(WorldSprites) do
        if(WorldSprites[i]~=nil) then
            WorldSprites[i].isBodyActive = false
            WorldSprites[i].y=10000
        end
        display.remove(WorldSprites[i])
        WorldSprites[i]=nil;
    end
    
    WorldSprites=nil--{}
    TrapIsOpen=false
    --TrapBodyIndex=nil
    
    
    display.remove(TrapImage)
    TrapImage=nil
    
    display.remove(TrapSensor)
    TrapSensor=nil
    
    display.remove(PoolSensor)
    PoolSensor=nil
    
    display.remove(TrapStick)
    TrapStick=nil
    
    display.remove(TrapSide1)
    TrapSide1=nil
    
    display.remove(TrapSide2)
    TrapSide2=nil
    
    display.remove(TrapLeg)
    TrapLeg=nil
    
    
    if InfoBoxGroup~=nil and InfoBoxGroup.x~=nil then
        display.remove(InfoBoxGroup);
        InfoBoxGroup=nil;
    end
    
end




function clearLevel(self)
    enemy:removeSprites();
    
    
    if(WorldWalls) then
        for i,line in ipairs(WorldWalls) do
            display.remove(WorldWalls[i])
            WorldWalls[i]=nil
        end
        for i,line in ipairs(background.bg) do
            display.remove(background.bg[i])
            background.bg[i]=nil
        end
    end
    
    WorldWalls=nil;
    --BGSprites=nil;
end
--[[
function SetBackground(self, layer)
    
    --local bgCount=1
    for i,line in ipairs(BGSprites) do
        
        if BGSprites[i].layer==layer then
            
            local bgCount=#background.bg+1;

            background.bg[bgCount] = display.newImageRect( BGSprites[i].image,BGSprites[i].width, BGSprites[i].height)
            --background.bg[bgCount]:setFillColor(0, 255, 255    , 200)
            
            background.bg[bgCount]:set ReferencePoint( BGSprites[i].ReferencePoint )--BGSprites[i].ReferencePoint 
            background.bg[bgCount].x = BGSprites[i].x;
            background.bg[bgCount].y = BGSprites[i].y
            background.bg[bgCount].width=BGSprites[i].width;
            background.bg[bgCount].height=BGSprites[i].height
            background.bg[bgCount].xScale = BGSprites[i].xScale;
            background.bg[bgCount].yScale = BGSprites[i].yScale
            background.bg[bgCount].dx = BGSprites[i].dx
            background.bg[bgCount].originalX=BGSprites[i].x
            background.bg[bgCount].originalY=BGSprites[i].y
            background.bg[bgCount].layer=BGSprites[i].layer
            
            if(BGSprites[i].rotation~=nil) then
                background.bg[bgCount].rotation=BGSprites[i].rotation
            end
            
            if(BGSprites[i].layer==0) then
                thegame.background_back:insert( background.bg[bgCount])
            else
                thegame.background_front:insert( background.bg[bgCount])
            end
            bgCount=bgCount+1
            
        end
        
    end
    
    
end
--]]

function findSpriteByTitle(self,title)
    
    
    for i,line in ipairs(sprite_collection.SpriteColection) do
        local s=sprite_collection.SpriteColection[i]
        if s.title==title then
            return i
        end
    end
    return -1
end

function SetWalls(self)
    --Set World Walls
    local CollisionFilter = { categoryBits = 1, maskBits = 3 } 
    local CollisionFilterClose = { categoryBits = 4, maskBits = 3 } 
    
    for i,line in ipairs(WorldWalls) do
        
        
        game:insert(WorldWalls[i])
        
        if WorldWalls[i].physics~=nil then
            
            if(WorldWalls[i].myName==nil)then 
                WorldWalls[i].myName="Wall"
                physics.addBody(WorldWalls[i], "static", { friction=WorldWalls[i].physics.friction, bounce=WorldWalls[i].physics.bounce, filter=CollisionFilter }  )
            else
                
                physics.addBody(WorldWalls[i], "static", { friction=WorldWalls[i].physics.friction, bounce=WorldWalls[i].physics.bounce, filter=CollisionFilterClose }  )
            end
        end                                
        
        
        
    end
    
    
    --[[
    if(WatchVisible)then
        WatchCenter = display.newRect(0 ,0,10,10)
        WatchCenter:setFillColor(0,0,255,200)
        
        WatchCenter.x =0
        WatchCenter.y = 100
        WatchCenter.rotation=0
        --game:insert(WatchCenter)
    
        CurrentWatchCenter = display.newRect(0 ,0,10,10)
        CurrentWatchCenter:setFillColor(0,255,0,200)
        
        CurrentWatchCenter.x =0
        CurrentWatchCenter.y = 80
        CurrentWatchCenter.rotation=0
        --game:insert(CurrentWatchCenter)
    end
    ]]--
    
    
end

--[[
function ApplyForce(self, x,y)

   
    for i=1, #world.WorldSprites do
        local s=world.WorldSprites[i]
        if s~=nil and s and s.myName=="fallingbody" and s.y>levels.PipeLowerY and s.y< display.contentHeight-50  then
            local vx,vy=s:getLinearVelocity()
            if vx<200 then -- don't apply force if object moveing that fast

                if(s.y>levels.PipeLowerY) then -- apply force only if object already lower that pipe
                    --local d=s.y-levels.PipeLowerY
                    --if d<1 then d=1 end
                    --local f=x/d*10
                    s:applyForce(x,y, s.x, s.y)
                end
            end
            
        end
    end
    
end

--]]



--[[
local function onTrapCollision( self, event )
        if ( event.phase == "began" ) then
                
		if TrapIsOpen==true and self.myName=="InsideTrap" and event.other.myName=="character" then
                   local toDo= function()
                       --if TrapSensor~=nil then
                       display.remove(TrapSensor)
                       TrapSensor=nil
                       
                       --end
                    thegame:cancelAlltimers()
                    buttons:removeAllButtons();
                    closeTrap()
                   end
                   timer.performWithDelay(10,toDo,1)
 		end
        end
end
]]--
local function onPoolSensorCollision( self, event )
    
    if ( event.phase == "began" ) then
        if self.myName=="PoolSensor" and event.other.myName=="fallingbody" then
            
            local typeIndex=event.other.typeIndex
            local s=sprite_collection.SpriteColection[typeIndex]
            

            
            event.other:setLinearVelocity( 0,0 )
            
            
            
            
            
            --event.other.angularVelocity=0
            --Mouse is Over You
            --               local toDo = function()
            
            --if TrapIsOpen==true and TrapSensor then
            --    display.remove(TrapSensor
            --                            TrapSensor=nil
            --                     end
            --PoolSensor:removeEventListener( "collision", PoolSensor )
            
            --                 display.remove(PoolSensor)
            --               PoolSensor=nil
            
            --thegame:cancelAlltimers()
            --buttons:removeAllButtons();
            --MouseEatYou()
            --          end
            --WinLoseTimer=timer.performWithDelay(10,toDo,1)
            
        end
    end
end


function setPoolSensor(self, x, y, w)
    
    PoolSensor=display.newRect(0, 0, w, 10)
    
    PoolSensor:setFillColor(255, 0,255, 0)
    PoolSensor.anchorY=10;
    --PoolSensor:set ReferencePoint( display.BottomCenterReferencePoint )
    PoolSensor.x=x
    PoolSensor.y=y
    
    game:insert(PoolSensor)
    
    PoolSensor.myName="PoolSensor"
    physics.addBody (PoolSensor, "static",{ isSensor = true})
    PoolSensor.collision = onPoolSensorCollision
    PoolSensor:addEventListener( "collision", PoolSensor )
    
end

--[[
local function getViewWidth(x)
        local minx=100000
        local maxx=-100000
        local floor=math.floor
        
        for i=1,#x do
            if x[i]<minx then minx=floor(x[i]); end
            if(x[i]>=maxx) then maxx=floor(x[i]); end
        end

        
        return {floor(maxx-minx),floor(minx+(maxx-minx)*0.5)}
end
]]

local function PlusMinus(v1,v2,margin) 
    if v1-margin>v2 or v1+margin<v2 then
        return true;
    end
end

function moveCamera(self)
    
    if(buttons.physics_paused)then
        return false;
    end
    
    
    
    
    
    
    
    local CameraSpeed=20;
    
    local WindowWidth=display.contentWidth-250
    local WindowHeight=display.contentHeight-200
    
    local halfScreenW=WindowWidth*0.5
    local halfScreenH=WindowHeight*0.5
    
    local d=""
    local abs=math.abs
    local floor=math.floor
    local mcwx=0;
    local mcwy=0;
    if(mousecharacter.wheel~=nil) then
        mcwx=floor(mousecharacter.wheel.x);
        mcwy=floor(mousecharacter.wheel.y);
    end
    
    
    
    w=1;h=1
    
    
    local   WatchScreenX_New=floor(mcwx)
    local   WatchScreenY_New=floor(mcwy)
    
    --if(WatchScreenX==nil) then            
WatchScreenX=WatchScreenX_New    --end
    
    --if(WatchScreenY==nil) then            
    WatchScreenY=WatchScreenY_New    --end
    
    
    if (WatchScreenX_New-abs(w)<WatchScreenX-halfScreenW) or (WatchScreenX_New+abs(w)>WatchScreenX+halfScreenW) then
        --Away of sight
        WatchScreenX=WatchScreenX_New
    end
    
    if (WatchScreenY_New-abs(h)<WatchScreenY-halfScreenH) or (WatchScreenY_New+abs(h)>WatchScreenY+halfScreenH) then
        --Away of sight
        WatchScreenY=WatchScreenY_New
    end
    
  --[[
    if(WatchVisible)then
            WatchCenter.x=WatchScreenX_New
            CurrentWatchCenter.x=WatchScreenX
            
            WatchCenter.y=WatchScreenY_New
            CurrentWatchCenter.y=WatchScreenY
    end
    ]]--
    local halfScreenFullW=display.contentWidth*0.5
    local halfScreenFullH=display.contentHeight*0.5
    
    local newGameX=- WatchScreenX+halfScreenFullW
    local newGameY=- WatchScreenY+halfScreenFullH
    
    local DistanceX=floor(game.x)-newGameX
    local DistanceY=floor(game.y)-newGameY
    
    if(buttons.GameMode==1) then
        local hOffset=0
        local newGameX=floor(floor(game.x)-DistanceX/CameraSpeed);
        local xO=64;
        
         if(game.x~=newGameX) then
            if newGameX-xO<-(levels.GameScreenWidth-display.contentWidth) then
                newGameX=-(levels.GameScreenWidth-display.contentWidth)+xO;
                
            elseif newGameX+xO>0 then
                newGameX=-xO+0;
            end
            
            game.x = newGameX

        end
        
        local newGameY=floor(floor(game.y-hOffset)-DistanceY/CameraSpeed+hOffset)
        
        if(game.y~=newGameY) then

            if newGameY<-(levels.GameScreenHeight-display.contentHeight-30) then
                newGameY=-(levels.GameScreenHeight-display.contentHeight-30);
            end
            
            game.y = newGameY
        end
        
    end
    
    mousecharacter:MoveCharacter();
    enemy:update();
    
    --local screen = display.getCurrentStage().contentBounds      
    
    if GameX_Last~=game.x or GameY_Last~=game.y then
        background:MoveBackGround(game.x,game.y)
        levels.UpdateMap();
        
        GameX_Last=game.x;
        GameY_Last=game.y;
    end
    
    
end

-- tAjALAWA6A@A2A6A4A8A9A3A