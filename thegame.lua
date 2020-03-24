--
-- Project: world.lua
-- Description: 
--
-- Version: 1.0
-- Managed with http://CoronaProjectManager.com
--
-- Copyright 2012 . All Rights Reserved.
-- 
module(..., package.seeall)

local json = require "json"
local MouseSound=false
thegame.background_back=nil
background_front=nil
background_veryfront=nil



Loading=nil
LoadingShadow=nil

FlagImage=nil;
local coverDeskReplay=nil

InfoBox={line1={50,19},line2={50,30}}



GameSlots={};
CurrentSlot=nil;



local MessageLabel=nil;
local MessageLabelShadow=nil;




local MessageTransition={};
local MessageTimers={};

local AllTransition={}
local function CancelAllTransition()
    local i;
    for i=1, #AllTransition  do

        transition.cancel(AllTransition[i])
        AllTransition[i]=nil

    end
    i=nil
    AllTransition={}
end


local LoseGameTimer=nil


local AllTimers={}
local function RemoveAllTimers()

    local i;
    if AllTimers~=nil then 
        for i=1, #AllTimers  do

            timer.cancel(AllTimers[i])
            AllTimers[i]=nil

        end
    end
    i=nil
    AllTimers={}
end


function StopAllPlaying()
    BackGroundMusicChannel=-1
    local result = audio.usedChannels

    if(result>0) then
        for i=1,result do
            audio.stop( i)

        end
   end
end

local function getsign(x)
    if(x>=0) then
        return 1;
    else
        return -1;
    end
end




function deleteMessage(self)
    local i;
    for i=1, #MessageTransition  do

        transition.cancel(MessageTransition[i]);
        MessageTransition[i]=nil;

    end
    i=nil
    MessageTransition={}

    
    if MessageTimers~=nil then 
        for i=1, #MessageTimers  do

            timer.cancel(MessageTimers[i])
            MessageTimers[i]=nil

        end
    end
    i=nil
    MessageTimers={}
    
    if MessageLabel~=nil then
            display.remove(MessageLabel);
            MessageLabel=nil;
            
            display.remove(MessageLabelShadow);
            MessageLabelShadow=nil;
            
    end
    
    
end

function ShowMessage(self, txt,t)
    
    deleteMessage(nil);
    
    local fontName="Grinched";
    local fontSize=36;
    if t==2 or t==3 then
        fontSize=28
    end
    
    if(MessageLabel==nil) then
        MessageLabelShadow = display.newText(txt, 0, 0, fontName, 36);
        --MessageLabelShadow:set ReferencePoint(display.CenterCenterReferencePoint);
        MessageLabelShadow.x=display.contentWidth*0.5+2;
        MessageLabelShadow.y=display.contentHeight*0.5+2;
    
        if t==1 then
            MessageLabelShadow:setTextColor(255,255,255,255);
        elseif t==2 then
            MessageLabelShadow:setTextColor(255,0,0,255);
        elseif t==3 then
            MessageLabelShadow:setTextColor(20,0,0,255);
        end
        MessageLabelShadow.xScale=0.1
        MessageLabelShadow.yScale=0.1
        
        
        MessageLabel = display.newText(txt, 0, 0, fontName, 36);
        --MessageLabel:set ReferencePoint(display.CenterCenterReferencePoint);
        MessageLabel.x=display.contentWidth*0.5;
        MessageLabel.y=display.contentHeight*0.5;
        
        if t==1 then
            MessageLabel:setTextColor(255,0,0,255);
        elseif t==2 then
            MessageLabel:setTextColor(255,255,255,255);
        end
        
        MessageLabel.xScale=0.1
        MessageLabel.yScale=0.1
        
        MessageTransition[#MessageTransition+1]=transition.to( MessageLabelShadow, {time=100, xScale=1,yScale=1} )
        MessageTransition[#MessageTransition+1]=transition.to( MessageLabelShadow, {delay=2000, time=500, alpha=0} )

        MessageTransition[#MessageTransition+1]=transition.to( MessageLabel, {time=100, xScale=1,yScale=1} )
        MessageTransition[#MessageTransition+1]=transition.to( MessageLabel, {delay=2000, time=500, alpha=0} )

        MessageTimers[#MessageTimers+1]=timer.performWithDelay(2600,deleteMessage,1);
    end
end












local function DoWin(task_strings)
    loadsounds:PlayWinSoundsSound();
        
    winform:Won(task_strings)
end

local function LevelWon(task_strings)
	
	-- You Won !!!

	TrapIsOpen=false
        thegame:removeSkyDropListener()

        buttons:removeAllButtons();
        thegame:cancelAlltimers();
        
        mousecharacter:StopMouse()
        	
	
			--local opacity=0
			--local weightSide=WorldSprites[TrapBodyIndex].width/8

	
			-- drop stick
			--TrapStick.x=TrapStick.x-10*TrapDirection
			--TrapStick:set ReferencePoint( display.CenterCenterReferencePoint )
			--TrapStick.rotation=-20*TrapDirection
			--TrapStick.myName="TrapStick"
			--physics.addBody (TrapStick, {bounce = 0.4, density=20, friction = 100})
			--TrapStick:applyForce( -1040*TrapDirection,0, TrapStick.x, TrapStick.y)
                        --
                        --TrapM:applyForce( 0,1040, TrapM.x, TrapM.y)
			--TrapDoor.rotation=-70
			--TrapDoorJoint.isLimitEnabled = false
			--TrapDoorJoint:setRotationLimits( -200, 5)
			--TrapDoor
			--TrapDoor:applyForce( -100,0, TrapDoor.x, TrapDoor.y)
                        --if(TrapLeg~=nil and TrapLeg.x~=nil) then
                          --  display.remove(TrapLeg)
                            --TrapLeg=nil
                        --end
                        
        mousecharacter:RemoveMiceVisor();
        

        local toDo=function ()
            DoWin();
        end
        WinLoseTimer=timer.performWithDelay(500,toDo,1)
        
end



function FlagFound()
        ShowMessage(nil,"You made it!",3);
    --won level
                                    removeSkyDropListener()
                                    cancelAlltimers()
                                    buttons:removeAllButtons();    
                                    mousecharacter:StopMouse();
                                    
                                    --FlagImage.x=x+12;

                                    AllTransition[#AllTransition+1]=transition.to(FlagImage, { time=500, y=FlagImage.y+40 } )    
                            
                                    
                                    
                                    local toDo= function()

                                    
                                        mousecharacter:EraseAllTimers();
                                        
                                        mousecharacter:RemoveMiceVisor();
                                        mousecharacter:StopMouse();
                                        
                                        buttons:removeAllButtons();
                                        LevelWon(task_strings);
                                    end
                                    AllTimers[#AllTimers+1]=timer.performWithDelay(550,toDo,1)
                                    
end




function EatFood(self, index,energyvalue) -- automatically
                            
    if(not buttons.isGamePlaying or buttons.physics_paused or buttons.GameMode~=1) then
        return;
    end
                            
              if(index~=nil )then
                  if world.WorldSprites[index]~=nil then
                        
                        loadsounds:PlayEatingSound();
                        
                        world.WorldSprites[index]:removeEventListener("postCollision", onBodyCollision)
                        local typeIndex=world.WorldSprites[index].typeIndex
                        
                        local doCollision = function()
                            if(world.WorldSprites[index]~=nil) then
                                world.WorldSprites[index].isBodyActive = false
                                world.WorldSprites[index].y=10000
                                display.remove(world.WorldSprites[index])
                                world.WorldSprites[index].isVisible=false
                                world.WorldSprites[index]=nil;
                                
                            end
                        end
                        
                        local collisionTimer = timer.performWithDelay( 10, doCollision, 1 )

                        mousecharacter:StopMouse();
                        thegame.CurrentSlot.Energy=thegame.CurrentSlot.Energy+energyvalue;
                        mousecharacter:changeFace(0,100,{2,3,4,10,11,8,11,10,8,1,4,3})

                        if thegame.CurrentSlot.Energy >1500 and thegame.CurrentSlot.Energy<=1700 then
                            ShowMessage(nil,"Don't overeat!",2);
                        elseif thegame.CurrentSlot.Energy >1700 and thegame.CurrentSlot.Energy<=1900 then
                            ShowMessage(nil,"Don't overeat!!",2);
                        elseif thegame.CurrentSlot.Energy >1900 then
                            ShowMessage(nil,"Don't overeat!!!",2);
                        end

                   end
              end          
                        
end




function TakeCoin(self, index,moneyvalue) -- automatically
                            
    if(not buttons.isGamePlaying or buttons.physics_paused or buttons.GameMode~=1) then
        return;
    end
                            
              if(index~=nil )then
                  if world.WorldSprites[index]~=nil then
                        
                        loadsounds:PlayCoinSound();
                        
                        world.WorldSprites[index]:removeEventListener("postCollision", onBodyCollision)
                        local typeIndex=world.WorldSprites[index].typeIndex
                        
                        
                        local doCollision1 = function()
                            world.WorldSprites[index].isBodyActive = false    
                        end
                        
                        local doCollision2 = function()
                            if(world.WorldSprites[index]~=nil) then
                                
                                world.WorldSprites[index].y=10000;
                                display.remove(world.WorldSprites[index]);
                                world.WorldSprites[index].isVisible=false;
                                world.WorldSprites[index]=nil;
                                
                            end
                        end
                        
                        local collisionTimer = timer.performWithDelay( 10, doCollision1, 1 )
                        
                        local scale=0.5;
                        AllTransition[#AllTransition+1]=transition.to( world.WorldSprites[index], { time=t,x=150-game.x, y=19-game.y,xScale=scale,yScale=scale } )    

                        local collisionTimer = timer.performWithDelay( 510, doCollision2, 1 )

                        mousecharacter:StopMouse();
                        world:addCoins(moneyvalue,thegame.InfoBox.line1[1],thegame.InfoBox.line1[2]);    
                       
                        mousecharacter:changeFace(0,100,{2,3,4,10,11,8,11,10,8,1,4,3})

                   end
              end          
                        
end



function TakeBody(self, index)
    
    if(not buttons.isGamePlaying or buttons.physics_paused or buttons.GameMode~=1) then
        return;
    end
        
        

              if(index~=nil )then
                  if world.WorldSprites[index]~=nil then
                        
                        local accept=false;        

                        
                        
                        local typeIndex=world.WorldSprites[index].typeIndex
                        
                        
                        local doCollision1 = function()
                            if world.WorldSprites[index]~=nil then
                                world.WorldSprites[index]:removeEventListener("postCollision", onBodyCollision)
                                world.WorldSprites[index].isBodyActive = false    
                            end
                        end
                        
                        local doCollision3 = function()
                            -- if accepted
                            if(world.WorldSprites[index]~=nil) then
                                    
                                    world.WorldSprites[index].y=10000
                                    display.remove(world.WorldSprites[index])
                                    world.WorldSprites[index].isVisible=false
                                    world.WorldSprites[index]=nil;
                                
                                
                                
                            end
                        end
                        
                        local doCollision2 = function()
                            local s=world.WorldSprites[index]
                            if(s~=nil) then
                                local t=world.WorldSprites[index].typeIndex;                        
                                local title=sprite_collection.SpriteColection[t].title;
                            
                        
                                if(world.WorldSprites[index].myName=="bag") then
                                
                                    local bagindex=sprite_collection.SpriteColection[t].bagindex;
                                    local bagcopacity=sprite_collection.SpriteColection[t].bagcopacity;
                            
                                    if(thegame.CurrentSlot.CurrentBag==1) then
                                        
                                    --don't have any bag yet
                                    --pick up the bug
                                        local doCollision4 = function()
                                            mousecharacter:changeBag(bagindex,bagcopacity);
                                            buttons:removeAllButtons();
                                            buttons:createGameButtons();
                                        end
                                        local collisionTimer = timer.performWithDelay( 600, doCollision4, 1 )
                                    
                                    
                                    
                                        accept=true;
                                    else
                                    -- I have a bag
                                    --[[
                                    if bagindex>thegame.CurrentSlot.CurrentBag then
                                        -- new one is bigger
                                        -- change bag and place old bag into new one
                                        if(thegame.CurrentSlot.CurrentBag==2) then
                                            title="SmallBackpack";
                                        elseif(thegame.CurrentSlot.CurrentBag==3) then
                                            title="NormalBackpack";
                                        elseif(thegame.CurrentSlot.CurrentBag==2) then
                                            title="ClosedBasket";
                                        end
                                        thegame.CurrentSlot.BagContent[#thegame.CurrentSlot.BagContent+1]=title;
                                        
                                        
                                        mousecharacter:changeBag(bagindex,bagcopacity);
                                        accept=true;
                                        
                                        
                                    else --]]
                                        -- new one same or smaller
                                        -- put new bag into existing bag
                                            local space=thegame.CurrentSlot.CurrentBagCopacity-#thegame.CurrentSlot.BagContent;

                                            if(space==0) then
                                                --You don't have enough space in the bag."
                                            
                                            else
                                                thegame.CurrentSlot.BagContent[#thegame.CurrentSlot.BagContent+1]=title;
                                                accept=true;
                                            end
                                        
                                        --end
                                    end
                                else
                                    if(thegame.CurrentSlot.CurrentBag==1) then
                                        thegame:ShowMessage("You don't have a bag yet.",2);
                                        --You don't have a bag yet.
                                    
                                    else
                                        local space=thegame.CurrentSlot.CurrentBagCopacity-#thegame.CurrentSlot.BagContent;
    
                                    
                                        if(space<1) then
                                            
                                            thegame:ShowMessage("Not enough space in the bag.",2);
                                        
                                        else
                                            thegame.CurrentSlot.BagContent[#thegame.CurrentSlot.BagContent+1]=title;
                                            accept=true;
                                        end
                                    
                                    end
                                end
                            
                            
                                if(accept) then

                                ------------------------------------------------------
                                    -- Play Sound if took the item
                                    loadsounds:PlayZipSound(1);
                                    
                                    if sprite_collection.SpriteColection[t].subtype=="gems" then
                                        loadsounds:PlayZipSound(2);
                                    end
                                    
                        
                                    AllTransition[#AllTransition+1]=transition.to( world.WorldSprites[index], { time=300, x=mousecharacter.torso.x,y=mousecharacter.torso.y-10 } )    

                                
                                    local collisionTimer = timer.performWithDelay( 510, doCollision3, 1 )
                                --world:addCoins(moneyvalue,thegame.InfoBox.line1[1],thegame.InfoBox.line1[2],background_front);    
                       
                                    mousecharacter:changeFace(0,100,{1,5,4,3,1})
                                else
                                    world.WorldSprites[index].isBodyActive = true;
                                    world.WorldSprites[index]:addEventListener("postCollision", onBodyCollision);
                                end
                            end
                        end
                        
                        
                        mousecharacter:StopMouse();
                        
                        
                            local collisionTimer = timer.performWithDelay( 10, doCollision1, 1 )
                        
                            

                            local collisionTimer = timer.performWithDelay( 100, doCollision2, 1 )

                            
                        

                   end
              end          

end


local function getAttractionSprite(UserArmLength_)
                
                local SpriteIndex=-1

		local MinDistance=1000000;

		local abs=math.abs
                --local sqrt=math.sqrt
                
		for i,line in ipairs(world.WorldSprites) do
			local s=world.WorldSprites[i]
                        
			if s and s.y~=nil and s.myName=="fallingbody" then
                                
                                local attraction=sprite_collection.SpriteColection[s.typeIndex].attraction
                                if attraction~=nil then

                      
                                    local dX=abs(mousecharacter.wheel.x-s.x)
                                    local dY=abs(mousecharacter.wheel.y-s.y)

                                    if dX<UserArmLength_ and dY<100 then
                                        if dX<MinDistance then 
                                            MinDistance=dX
                                            SpriteIndex=i
                                        end
                                    end
                               end
                                
			end
		end
		return SpriteIndex;

end



function findCheese(self)
    CheeseIndex=getAttractionSprite(200);
    if CheeseIndex~=-1 then
        mousecharacter:RunForCheese(CheeseIndex)
    end
end

local function CreateBodyClone(CurrenBodyIndex,JustDropped)
    
    
    local OldBody=world.WorldSprites[CurrenBodyIndex]
    local angularVelocity=OldBody.angularVelocity
    local lvX,lvY=OldBody:getLinearVelocity()
        
    if(buttons.physics_paused or buttons.GameMode==0)then
        return false
    end
    
    if angularVelocity==nil or lvX==nil or lvY==nil then 
        return false
    end
    OldBody.isBodyActive=false
    
    local s=sprite_collection.SpriteColection[OldBody.typeIndex]
    
    local NewBody=display.newImageRect( "src/images/sprites/"..s.image,s.width,s.height  )
    --NewBody:set ReferencePoint( display.CenterCenterReferencePoint)
    local CollisionFilter = { categoryBits = 1, maskBits = 5 }   
    
    
    if JustDropped then
        --NewBody:setFillColor(0,0,255,50)
        CollisionFilter = { categoryBits = 1, maskBits = 3 } 
    end
    
    game:insert(NewBody)
    NewBody.x=OldBody.x
    NewBody.y=OldBody.y
    NewBody.rotation=OldBody.rotation
    NewBody.bodyIndex=OldBody.bodyIndex
    NewBody.typeIndex=OldBody.typeIndex
    NewBody.myName=OldBody.myName
    NewBody.used=OldBody.used

    

    if(s.radius>0) then
        physics.addBody (NewBody, {bounce = s.bounce, density=s.density, friction = s.friction, radius=s.radius, filter=CollisionFilter})
    else
        if s.shape==nil then
            physics.addBody (NewBody, {bounce = s.bounce, density=s.density, friction = s.friction, filter=CollisionFilter})        
        else
            physics.addBody (NewBody, {shape=s.shape, bounce = s.bounce, density=s.density, friction = s.friction,filter=CollisionFilter})
        end
    end 
    
    NewBody.angularVelocity=angularVelocity
    
    
    NewBody:setLinearVelocity(lvX,lvY)
    
    
    
    return NewBody;
end



function onBodyCollision(event)
    

        if (event.force==nil) then
            return 
        end
               
        local t=world.WorldSprites[event.target.bodyIndex]  
        local vx,vy=t:getLinearVelocity()
        local v=math.sqrt(vx*vx+vy*vy);
        
        
        
        
        
        
        if (v<10 or event.force<0.1) then
           return 
        end
        local hit=v*event.force;

        
        
        if event.target.x+game.x<=0 or event.target.x+game.x>display.contentWidth then
            return false;
        end
        
        local o=event.other
        --if o.x+game.x<=0 or o.x+game.x>display.contentWidth then
          --  return false;
        --end
                      local volume=hit*0.01--event.force
        
                    if volume<0.1 then
                        volume=0
                    else
                        volume=1
                    end

                    
        local targetBody=world.WorldSprites[event.target.bodyIndex].myName
        local otherBody=o.myName
        if otherBody=="character" and event.target~=nil then
            --or targetBody=="fallingbody"
            if targetBody=="body"  then
                
    
                --local attraction=sprite_collection.SpriteColection[event.target.typeIndex].attraction
                --if attraction~=nil then

                --end
                

                if loadsounds.PlaySound and MouseSound~=true then


                    --local volume=1/10*v

                    if(volume>0.1) then
                        mousecharacter:changeFace(0,1000,{4,1})
                        mousecharacter:changeEyes(0,500,{3,2,1})
                    end
                    if(volume>0.2) then
                        
                        --mouse  cry only when you hit it hard
                        
                        loadsounds:PlayPainSound();
                                                
                        local DisableMouseSound = function()
                            MouseSound =false
                        end
                        
                        AllTimers[#AllTimers+1]=timer.performWithDelay(1000,DisableMouseSound,1)
                    end
                end
            end
        end
        
        --or targetBody=="fallingbody"
        
        --if targetBody=="body"  then
 --or otherBody=="PoolSensor"
            --if otherBody=="Wall" or otherBody=="body" or otherBody=="fallingbody" or otherBody=="CloseWall" then
            

            local typeIndex=event.target.typeIndex
            local s=sprite_collection.SpriteColection[typeIndex]
            --local vx,vy = event.target:getLinearVelocity()

            --local v=event.force
        
            --if v<1 then
              --  v=1
            --end
            --if(v>10) then
--                v=10
  --          end
        
    --        local volume=s.volume/10*v/5

                    
            if(volume>0.1) then
                --and s.hitsound~=-1 and #loadsounds.bodyHitSounds>0
                if (loadsounds.PlaySound ) then
                    loadsounds:PlayBodyHitSound(s,volume);

                end
                
                if(volume>0.4) then

                end
            end
            
           -- end
        --end

end

function add_postCollisionListener(self,newBodyIndex)
    world.WorldSprites[newBodyIndex]:addEventListener("postCollision", onBodyCollision);
end


local function DropBody(x,y)
    if buttons.physics_paused then
        return
    end
    
    local xd=mousecharacter.torso.x-x;
    local yd=mousecharacter.torso.y-y;
    local d=math.floor(math.sqrt(xd*xd+yd*yd));
    
    if d<80 then
        -- to close to drop an item.
        return;
    end

    local ball=mousecharacter:RemoveBallFromArms();
    if ball == "" then 
        return;
    end

    local t=mousecharacter.torso;

    
    local kD=0.4;

    
    local dfx=x-t.x
    local dfy=y-t.y
    
   
    
    
    if math.abs(dfx)<10 and math.abs(dfy)<10 then
        return false
    end
   
    
    
    local delay=100;
     if dfx>0 and t.xScale==-1 then
        mousecharacter:TurnCharacter(1,false);    
        delay=500;
    elseif dfx<0 and t.xScale==1 then
        mousecharacter:TurnCharacter(-1,false);    
        delay=500;
    end

    local dropBall=function()
        local newBodyIndex=levels:AddBody(ball,t.x+15*t.xScale,t.y,0,"ball");
        if(newBodyIndex~=-1) then
            local o=world.WorldSprites[newBodyIndex];
        
            o.isBullet = true;
            kD=kD*o.radius*0.11;
            local kX=dfx*kD;
            local kY=dfy*kD;
    
            o:applyForce(kX,kY, o.x-1, o.y-1)
            world:addTouchListenersToSpecialBodies(newBodyIndex);  
            world.WorldSprites[newBodyIndex]:addEventListener("postCollision", onBodyCollision);
        
        local findAnotherBall=function()
            mousecharacter:findAnotherBall(ball);
        end
        AllTimers[#AllTimers+1]=timer.performWithDelay(500,findAnotherBall,1)
    
    
        if(loadsounds.PlaySound) then
            --local index=world.WorldSprites[newBodyIndex].typeIndex
            --local s=sprite_collection.SpriteColection[index]
            --if(s.flysound~=-1) then
            
                --local availableChannel = audio.findFreeChannel()
                --if availableChannel>0 then
                    --audio.setVolume(1, { channel=availableChannel } )


                    local myclosure= function()
                        loadsounds:PlayBodyFlySound();
                        
                    end
                    AllTimers[#AllTimers+1]=timer.performWithDelay(250,myclosure,1)
                --end
            --end
        
            loadsounds:PlayUserDropSound()
            
        end
    
   
        mousecharacter:changeFace(0,500,{5})
    
        end
    end
    AllTimers[#AllTimers+1]=timer.performWithDelay(delay,dropBall,1)
    

    

        
    

    
end



function AddSoundListeners()
    for i,line in ipairs(world.WorldSprites) do
        if(world.WorldSprites[i]~=nil) then
            if world.WorldSprites[i] then
                --if world.WorldSprites[i].isVisible then
            world.WorldSprites[i]:addEventListener("postCollision", onBodyCollision)
        --end
            end
        end
    end
end

function RemoveSoundListeners(self)
    for i,line in ipairs(world.WorldSprites) do
        if(world.WorldSprites[i]~=nil) then
            if world.WorldSprites[i] then
                if world.WorldSprites[i].isVisible then
                    world.WorldSprites[i]:removeEventListener("postCollision", onBodyCollision)
                end
            end
        end
    end
end

function touchSky( event )
       
        
        if(buttons.physics_paused or buttons.GameMode==0)then
            --Touch Sky when game paused - should be imposible
            return false
        end
        
        if(event.x<display.contentWidth*0.5) then
            if(event.phase== "ended") then
                buttons:UncheckButtons();
                if mousecharacter.mouseTouchingFloor>0 then
                    mousecharacter:StopMouse();
                end
                return;
            end

            if buttons:checkIfLeftButtonPressed(event.x,event.y) then
                return;
            else
                
            end
        
            if buttons:checkIfRightButtonPressed(event.x,event.y) then
                return;
            end
        end

  	if(event.phase== "began" )then
            local doDropBody=function()
                DropBody(event.x-game.x,event.y-game.y);    
            end
            
            if event.y<display.contentHeight-100 then 
                AllTimers[#AllTimers+1]=timer.performWithDelay(10,doDropBody,1)    
            else
                if event.x<display.contentWidth-100 then 
                    AllTimers[#AllTimers+1]=timer.performWithDelay(10,doDropBody,1)    
                end
            end
 	      


            
        
            
        
        end 
end



function setSkyDropListener(self)
	background.sky:addEventListener( "touch", touchSky)
	
end

function removeSkyDropListener(self)
	background.sky:removeEventListener( "touch", touchSky)
	
end

function cancelAlltimers(self)
        RemoveAllTimers();
        world:StopWinLose();
        --usercharacter:EraseAllTimers()
        mousecharacter:EraseAllTimers()


end

function SaveCurrentSlot(self)
    local index=CurrentSlot.index;
    local l=CurrentSlot;
    GameSlots[index]={
                    name=l.name, 
                    CurrentLevel=l.CurrentLevel,
                    ScoreCoins=l.ScoreCoins,
                    Energy=l.Energy,
                    CurrentBall=l.CurrentBall,
                    CurrentShoes=l.CurrentShoes,
                    CurrentBag=l.CurrentBag,
                    CurrentBagCopacity=l.CurrentBagCopacity,
                    BagContent=l.BagContent,
                    index=index
                }

    saveGameSlot(nil, index);
end

function setCurrentSlot(self,index)
     local l=GameSlots[index]
       local bc={};
       for i=1,#l.BagContent do
           bc[i]=l.BagContent[i]
       end
       
        CurrentSlot=
                {
                    name=l.name, 
                    CurrentLevel=l.CurrentLevel,
                    ScoreCoins=l.ScoreCoins,
                    Energy=l.Energy,
                    CurrentBall=l.CurrentBall,
                    CurrentShoes=l.CurrentShoes,
                    CurrentBag=l.CurrentBag,
                    CurrentBagCopacity=l.CurrentBagCopacity,
                    BagContent=bc,
                    index=index
                }    
end


function resetSlot(self, index,title)
    
    GameSlots[index]={name=title, CurrentLevel=1,ScoreCoins=0,Energy=800,CurrentBall="",CurrentShoes=1,CurrentBag=1,CurrentBagCopacity=0,BagContent={}}
    --GameSlots[index]={name=title, CurrentLevel=1,ScoreCoins=0,Energy=800,CurrentBall="",CurrentShoes=1,CurrentBag=2,CurrentBagCopacity=5,BagContent={"Apple"}}
    saveGameSlot(nil, index);
end

function loadGameSlot(self, index)
    local userstate = ice:loadBox( "userstate" );
    
    local b=userstate:retrieve("SlotNumber"..index);
    if b~=nil then 
        local a=json.decode(b);
        

        if a~=nil then 
            --a.CurrentLevel=6-- to test 
            --a.Energy=800
            --a.CurrentBag=2 -- to test 
            --a.CurrentShoes=2
            --a.CurrentBall="Football"
            --a.CurrentBagCopacity=5 -- to test 
            --a.BagContent={"Cheese","Cheese","Shoes", "Apple"}
            --a.CurrentBall="TennisBall"
        end
        GameSlots[index]=a;
    else
        GameSlots[index]=nil;
    end
end

function saveGameSlot(self, index)
    
    
    local a=GameSlots[index];
    local b=json.encode(a);

    
    local userstate = ice:loadBox( "userstate" );
    userstate:store( "SlotNumber"..index, b);
    userstate:save();
    
end


local RemoveGameTimer=nil

local function WaitUntilGameIsRemoved()
                LoadingShadow.text = "Loading..."
                Loading.text = "Loading..."
            
                --local myText=display.newText("Reset step 22",0,0,native.systemFont,20);myText.x=300;myText.y=190;myText:setTextColor(0,0,255);
                RemoveAllTimers()
                
                LoadingShadow.text = "Loading...."
                Loading.text = "Loading...."
                --local myText=display.newText("Reset step 23",0,0,native.systemFont,20);myText.x=300;myText.y=210;myText:setTextColor(0,0,255);

                background.sky.isVisible=false;
                --timer.cancel(RemoveGameTimer)
                --RemoveGameTimer=nil
                LoadLevel();
                LoadingShadow.text = "Loading"
                Loading.text = "Loading"
                --local myText=display.newText("Reset step 24",0,0,native.systemFont,20);myText.x=300;myText.y=230;myText:setTextColor(0,0,255);
                
                display.remove(LoadingShadow)
                LoadingShadow=nil
                
                display.remove(Loading)
                Loading=nil
                --local myText=display.newText("Reset step 25",0,0,native.systemFont,20);myText.x=300;myText.y=250;myText:setTextColor(0,0,255);
                
                
                display.remove(coverDeskReplay)
                --local myText=display.newText("Reset step 26",0,0,native.systemFont,20);myText.x=300;myText.y=270;myText:setTextColor(0,0,255);
                coverDeskReplay=nil
                CancelAllTransition()
                
                --updateEnergyBar();
                --local myText=display.newText("Reset step 27",0,0,native.systemFont,20);myText.x=300;myText.y=290;myText:setTextColor(0,0,255);
end



function Replay(self,MustLoadLevel)
        
        display.remove(FlagImage);
        FlagImage=nil
        
        
        deleteMessage();

        
        coverDeskReplay = display.newRect(0, 0,display.contentWidth*2,display.contentHeight*2)
	coverDeskReplay:setFillColor(0,0,0, 250)
        --coverDeskReplay:set ReferencePoint( display.CenterCenterReferencePoint)
        coverDeskReplay.x=display.contentWidth*0.5
        coverDeskReplay.y=display.contentHeight*0.5
        coverDeskReplay.alpha=0
        
        AllTransition[#AllTransition+1]=        transition.to( coverDeskReplay, { time=100, alpha=0.9 } )
        
        
        
        RemoveAllTimers()
        
    
        local fontName = "Grinched"
        local fontSize = 50
        local txt=nil;
        --if(thegame.GameLanguage=="rus") then
          --  fontName = "Basic Comical NC"
            --txt="Загрузка...";
        --else
            txt="Loading."
        --end

        
        LoadingShadow = display.newText(txt , 0, 0, fontName, fontSize )
        --LoadingShadow:set ReferencePoint(display.CenterCenterReferencePoint);
        LoadingShadow.x=display.contentWidth*0.5+3
        LoadingShadow.y=display.contentHeight*0.5+3
        LoadingShadow:setTextColor(0,0,0)
        
        Loading = display.newText(txt , 0, 0, fontName, fontSize )
        --Loading:set ReferencePoint(display.CenterCenterReferencePoint);
        Loading.x=display.contentWidth*0.5
        Loading.y=display.contentHeight*0.5
        Loading:setTextColor(255,200,0)

        
        

        
        
        display.remove(SpriteArrow)
        SpriteArrow=nil
        
       
        remove_enterFrameListener()
        
        cancelAlltimers();
        
        
            
        mousecharacter:EraseAllTimers()
        
        
        if game~=nil then
                world:clearWorld()
                world:clearLevel()
        end
        levels:nulLevel()
        
        display.remove(background_back)
        background_back=nil
        
        

        display.remove(background_front)
        background_front=nil
        
        display.remove(background_veryfront)
        background_veryfront=nil
        
        
        local toDo1=function()
             --local myText=display.newText("Reset step 16.a",0,0,native.systemFont,20);myText.x=300;myText.y=70;myText:setTextColor(0,255,0);
            buttons.physics_paused=true
        --end
        --local toDo2=function()
          --  local myText=display.newText("Reset step 16.1",0,0,native.systemFont,20);myText.x=300;myText.y=90;myText:setTextColor(0,255,0);
            physics.pause()
        --end
        --local toDo3=function()
            --local myText=display.newText("Reset step 17",0,0,native.systemFont,20);myText.x=300;myText.y=110;myText:setTextColor(0,255,0);

           -- physics.stop()
        --end
        --local toDo4=function()
          --  local myText=display.newText("Reset step 18",0,0,native.systemFont,20);myText.x=300;myText.y=130;myText:setTextColor(0,255,0);
            mousecharacter:removeMouse()
        --end
        --local toDo5=function()
          --  local myText=display.newText("Reset step 19",0,0,native.systemFont,20);myText.x=300;myText.y=150;myText:setTextColor(0,255,0);
            --usercharacter:removeCharacter()
        --end
        --local toDo6=function()

          --  local myText=display.newText("Reset step 20",0,0,native.systemFont,20);myText.x=300;myText.y=170;myText:setTextColor(0,255,0);
            display.remove(game);
            game=nil;
            
            
            LoadingShadow.text = "Loading.."
            Loading.text = "Loading.."
                        
        end
        
        local t1=timer.performWithDelay(300,toDo1,1);
        --local t2=timer.performWithDelay(1000,toDo2,1);
        --local t3=timer.performWithDelay(1500,toDo3,1);
        --local t4=timer.performWithDelay(2000,toDo4,1);
        --local t5=timer.performWithDelay(2500,toDo5,1);
        --local t6=timer.performWithDelay(3000,toDo6,1);
        
        --AllTimers[#AllTimers+1]=
        local t2=timer.performWithDelay(700,WaitUntilGameIsRemoved,1);--no need to clean this timer
        --local myText=display.newText("Reset step 21",0,0,native.systemFont,20);myText.x=300;myText.y=50;myText:setTextColor(0,255,0); 
        --end
        
end




