--
-- Project: Mouse Math
-- Description: 
--
-- Version: 1.0
-- Managed with http://CoronaProjectManager.com
--
-- Copyright 2012 . All Rights Reserved.
-- 
module(..., package.seeall)

-- Mouse Physical Abilities ----------
MouseJumpForce=nil
--700 --1
--1000 --2
--1200 --3
MouseAirRunForce=nil
MouseRunForce=nil
MouseRunLimit=nil

local JumpNextToWall;


local MouseCurrentBallImage=nil;
--------------------------------------
mouseTouchingFloor=nil;
mouseNextToWall=nil;
jumpingNextToWall=nil;

--local FaceFront=false
local EyesSide=nil
local EyesFront=nil
local Front=nil
local EyesState=nil
local changeFaceTimers={}
local changeEyesTimers={}
local tail_shake=0
local tail_shake_d=1
local moveto=0
local timeFromDirectionChange=0


local ReadyToTurn=false


local turnTimer=nil
local mouseVisorTimer=nil

local character_Xoffsets={}
local character_Yoffsets={}
local isMouseOk=true

local WheelVisor=nil;
local FootVisor=nil;
local MiceVisor=nil;


------
local leg=1
local leg_max=0
local head=nil
local neck=nil
local basketimage=nil
--local basketimage1=nil
--local basketimage2=nil
torso=nil
wheel=nil
local leg_back = nil
local arm_back = nil
local tail = nil
------
local character=nil

local characterJoints_Wheel = nil
local characterJoints_Torso = nil
local characterJoints_Neck = nil
		
local function removeCharacterJoints(removeNeckJoint)

        if(characterJoints_Wheel~=nil) then
            display.remove(characterJoints_Wheel)
            characterJoints_Wheel=nil
        end
        
        if(characterJoints_Torso~=nil) then
            display.remove(characterJoints_Torso)
            characterJoints_Torso=nil
        end
	
	if removeNeckJoint==true then
            if(characterJoints_Neck~=nil) then
            
		display.remove(characterJoints_Neck)
                characterJoints_Neck=nil
            end
	end

end



function removeMouse()
    
    RemoveMiceVisor(nil);
    mouseVisorTimer=nil
    
    display.remove(WheelVisor);
    WheelVisor=nil;
    
    display.remove(FootVisor);
    FootVisor=nil;
    
    

    display.remove(MouseCurrentBallImage);
    MouseCurrentBallImage=nil;
    
    mouseTouchingFloor=nil;
    mouseNextToWall=nil;
    jumpingNextToWall=nil;
    removeCharacterJoints(true)

    EraseAllTimers()
    
    display.remove(EyesSide)
    EyesSide=nil
   
    display.remove(EyesFront)
    EyesFront=nil
    
    Front=nil
    EyesState=nil
    changeFaceTimers=nil
    changeEyesTimers=nil
    tail_shake=nil
    tail_shake_d=nil
    moveto=nil
    timeFromDirectionChange=nil
    ReadyToTurn=nil
    

    turnTimer=nil
    
    --mouseJumpTimer=nil
    --mouseJumpTimer2=nil
    character_Xoffsets=nil
    character_Yoffsets=nil
    leg=nil
    leg_max=nil
    display.remove(head)
    head=nil
    display.remove(neck)
    neck=nil
    display.remove(torso)
    torso=nil
    display.remove(wheel)
    wheel=nil
    display.remove(leg_back)
    leg_back=nil
    display.remove(arm_back)
    arm_back=nil
    display.remove(tail)
    tail=nil
    
    display.remove(basketimage)
    basketimage=nil

    display.remove(character)
    character=nil
    
    

end



local function UpdateEyes()
  

    if Front then

        EyesSide.isVisible=false
        EyesFront:stopAtFrame(EyesState)
        EyesFront.y=head.y+5
        EyesFront.x=head.x--*head.xScale
        EyesFront.xScale=head.xScale
        EyesFront.rotation=head.rotation
        EyesFront.isVisible=true
    else

        EyesFront.isVisible=false
        EyesSide:stopAtFrame(EyesState)
        EyesSide.y=head.y+7
        EyesSide.x=head.x+5*head.xScale
        EyesSide.xScale=head.xScale
        EyesSide.rotation=0--head.rotation
        EyesSide.isVisible=true
    end
    

end


local function createCharacterJoints(startX,startY,side,createNeckJoint)

	characterJoints_Wheel = physics.newJoint ( "pivot",  torso, wheel, startX,startY+character_Yoffsets.wheel)
	characterJoints_Wheel.isLimitEnabled =false
	
	characterJoints_Torso = physics.newJoint ( "pivot", torso, neck, startX, startY+15)--character_Yoffsets.torso-torso.height*0.5

	characterJoints_Torso.isLimitEnabled = true
	characterJoints_Torso:setRotationLimits( -5, 5)
	

	if createNeckJoint==true then
		--characterJoints_Neck = physics.newJoint ( "pivot", neck, head, startX, startY+character_Yoffsets.neck)--+character_Yoffsets.neck
                characterJoints_Neck = physics.newJoint ( "pivot", neck, head, startX, startY+character_Yoffsets.head)--+character_Yoffsets.neck
		characterJoints_Neck.isLimitEnabled = true
		characterJoints_Neck:setRotationLimits (3, -3)
	end
        

        UpdateMiceVisor();
        
    
end




local function PrepareEyes(self)
    
    local folder="src/images/mouse/"
    EyesState=1
    Front=false
    
    
    --SpriteArrow = movieclip.newAnim{ "spritearrow_1.png", "spritearrow_2.png", "spritearrow_3.png" }
    EyesSide = movieclip.newAnim({ folder.."manny_eyes_1.png", folder.."manny_eyes_2.png", folder.."manny_eyes_3.png"},6,10,0.5,1)
    EyesFront = movieclip.newAnim({  folder.."manny_eyes_f1.png", folder.."manny_eyes_f2.png", folder.."manny_eyes_f3.png"},16,10,0.5,1)
    --EyesSide.anchorY=10;
    --EyesSide:set Reference Point(display.BottomCenterReferencePoint);
    --EyesFront.anchorY=10;
    --EyesFront:set Reference Point(display.BottomCenterReferencePoint);
    --Eyes.x=-10000
    --Eyes.y=-10000
    
    EyesSide.isVisible = false;
    EyesFront.isVisible = false;
    character:insert (EyesSide)
    character:insert (EyesFront)
    
    --UpdateEyes()
    
    --]]--
end


local function onFootSensor( self, event )
    
    if(not buttons.isGamePlaying or buttons.physics_paused or buttons.GameMode~=1) then
            return;
        end
        
    
    local eom=event.other.myName
        if(eom~="character" and eom~="MiceVisor") then
                
                if ( event.phase == "began" ) then
                    mouseNextToWall=mouseNextToWall+1
                   
                elseif ( event.phase == "ended" ) then
                   
                    mouseNextToWall=mouseNextToWall-1;
                    if(mouseNextToWall<0) then
                        mouseNextToWall=0;
                    end

                end
        end


end

local function StopMouseHorizontalMovement()
    
    local vx,vy=wheel:getLinearVelocity();
    
    wheel:setLinearVelocity( 0,vy )
    wheel.angularVelocity=0
                        
    torso:setLinearVelocity( 0,vy )
    torso.angularVelocity=0
                        
    neck:setLinearVelocity( 0,vy )
    neck.angularVelocity=0
                        
    head:setLinearVelocity( 0,vy )
    head.angularVelocity=0
end

local function onWheelSensor( self, event )
    
    if(not buttons.isGamePlaying or buttons.physics_paused or buttons.GameMode~=1) then
            return;
        end
        
    
    local eom=event.other.myName
        if(eom~="character" and eom~="MiceVisor") then
                
                --print ("eom="..eom)
                
                
                if ( event.phase == "began" ) then
                    
                    --if eom=="enemy" then
                    --    enemy:enemyAttack(event.target.x, event.other.bodyIndex);
                    --    return 
                    --end
                    
                    mouseTouchingFloor=mouseTouchingFloor+1
                   
                   if jumpingNextToWall==2 then
                       StopMouseHorizontalMovement();
                       jumpingNextToWall=0;
                   end
                elseif ( event.phase == "ended" ) then
                   
                    mouseTouchingFloor=mouseTouchingFloor-1;
                    --wheel.angularVelocity=0;
                end
        end


end

local function CreateSensors()
           
        
        FootVisor=display.newRect(0, 0, 10, 30)
        FootVisor.anchorY=0;
        --FootVisor:set ReferencePoint( display.TopCenterReferencePoint );
        FootVisor:setFillColor(255, 0,0, 0);
        game:insert(FootVisor);
        FootVisor.x=wheel.x;
        FootVisor.y=wheel.y+2;
        FootVisor.myName="FootVisor";
        physics.addBody (FootVisor,{ isSensor = true });
        FootVisor.collision = onFootSensor;
        FootVisor:addEventListener( "collision", FootVisor);
        
        
                
        WheelVisor=display.newRect(0, 0, 15, 10)
        WheelVisor.anchorY=0;
        --WheelVisor:set ReferencePoint( display.TopCenterReferencePoint );
        WheelVisor:setFillColor(0, 255,255, 0);
        game:insert(WheelVisor);
        WheelVisor.x=wheel.x;
        WheelVisor.y=wheel.y+2;
        WheelVisor.myName="WheelVisor";
        physics.addBody (WheelVisor,{ isSensor = true });
        WheelVisor.collision = onWheelSensor;
        WheelVisor:addEventListener( "collision", WheelVisor);
        
        
        mouseVisorTimer=timer.performWithDelay(1000,UpdateMiceVisor,1)
end

function CreateMouse(self,originX, originY, model) 
    --JustEnteredWater=false;
    
    
    MouseJumpForce=500
    
    --700 --1
    --1000 --2
    --1200 --3
    MouseAirRunForce=20
    MouseRunForce=100
    MouseRunLimit=50

    
    
    
    
    
    
    
    
    
    mouseTouchingFloor=0;
    mouseNextToWall=0;
    jumpingNextToWall=0;
    isMouseOk   =true
    changeFaceTimers={}
    changeEyesTimers={}
    tail_shake=0
    tail_shake_d=1
    moveto=0
    timeFromDirectionChange=0
    ReadyToTurn=false
    

    character_Xoffsets={}
    character_Yoffsets={}
    leg=1
    leg_max=0


    local folder="src/images/mouse/"
    local prefix=""

    if model=="scotty" then 
	character_Xoffsets={leg_back=1, arm_back=0, tail=-8, torso=0, neck=0, head=0,leg_front=-2,arm_front=0,wheel=0}
	character_Yoffsets={leg_back=36, arm_back=0, tail=30, torso=25, neck=20, head=0,leg_front=40,arm_front=0,wheel=44}
	prefix="_right"

        elseif model=="manny" then

	character_Xoffsets={leg_back=1, arm_back=0, tail=-4, torso=0, neck=1, head=0,leg_front=-2,arm_front=0,wheel=0}
	character_Yoffsets={leg_back=41, arm_back=0, tail=30, torso=30, neck=24, head=-3,leg_front=45,arm_front=0,wheel=49}
	
	
    end



	character = display.newGroup ()
	 
	local startX = originX
	local startY = originY
	
	move_to=0
	leg = 1
	leg_max=0
	-- 0 no move
	-- 1 to right
	-- 2 to left
        
        local leg_files={folder.."manny_leg_barefoot.png",folder.."manny_leg_shoes.png",folder.."manny_leg_boots.png",folder.."manny_leg_trainers.png"};
	

-- Leg Back
        leg_back = movieclip.newAnim(leg_files,20,20,0.5,0);
	--leg_back = display.newImageRect(folder..model.."_leg_front_stand"..prefix..".png",16,20 )
        --leg_back.anchorY=0;
        --leg_back:set Reference Point(display.TopCenterReferencePoint);
        --leg_back:setFillColor(20, 0,0, 100);
	leg_back.x = startX+character_Xoffsets.leg_back
	leg_back.y = startY+character_Yoffsets.leg_back
	
	game:insert (leg_back)
        leg_back:stopAtFrame(thegame.CurrentSlot.CurrentShoes);

-- Arm Back
	arm_back = display.newImageRect(folder..model.."_arm_back"..prefix..".png",30,10 )
        arm_back.anchorX=0
	--arm_back:set ReferencePoint(display.CenterLeftReferencePoint);
	arm_back.x = startX+character_Xoffsets.arm_back
	arm_back.y = startY+character_Yoffsets.arm_back
	
	character:insert (arm_back)





        
        
-- Neck
	neck = display.newImageRect(folder..model.."_neck"..prefix..".png",14,20 )
        neck.anchorY=20;
	--neck:set Reference Point(display.BottomCenterReferencePoint);
	neck.x = startX+character_Xoffsets.neck
	neck.y = startY+character_Yoffsets.neck
	character:insert (neck)

--[[
      basketimage1= display.newImageRect(folder.."backpack_small.png",44,38 )
	basketimage1:set ReferencePoint(display.TopRightReferencePoint);
	basketimage1.x = startX-10
	basketimage1.y = startY+10
	character:insert (basketimage1)
        ]]
        

        
    --[[    
        basketimage= display.newImageRect(folder.."basket.png",44,38 )
	basketimage:set ReferencePoint(display.TopRightReferencePoint);
	basketimage.x = startX+5
	basketimage.y = startY+10
	character:insert (basketimage)








        local w1=10;
        local w2=8;
        local h=10;
        local s=2;
        local m=0;
        local BacketShape={-w1-m,-h,  -w2-m,h,   w2-m,h,   w1-m,-h,   w1-s-m,-h,   w2-s-m,h-s  };--, -w2+s-m,h-s,  -w1+s-m,-h  
        physics.addBody (basketimage, {bounce = 0.1, density=1, friction = 1, shape=BacketShape })

--]]

	

        ---------------------------------------------------


 -- Tail
	tail = display.newImageRect(folder..model.."_tail"..prefix..".png",18,42 )
        tail.anchorY=1;
        tail.anchorX=1;
	--tail:set Reference Point(display.BottomRightReferencePoint);
	tail.x = startX+character_Xoffsets.tail
	tail.y = startY+character_Yoffsets.tail
	character:insert (tail)       
	-- Torso
	torso = display.newImageRect(folder..model.."_torso"..prefix..".png",22,26 )
        --ReferencePointFixed
	--torso:set ReferencePoint(display.CenterCenterReferencePoint);
	torso.x = startX+character_Xoffsets.torso
        torso.y = startY+character_Yoffsets.torso
	character:insert (torso)



        basketimage= movieclip.newAnim({folder.."tie.png",folder.."backpack_small.png",folder.."backpack_normal.png",folder.."basket_closed.png"},44,38,1,0);--display.newImageRect(folder.."backpack_small.png",44,38 )
        --basketimage.anchorY=0;
        --basketimage.anchorX=0;--44;
	--basketimage:set Reference Point(display.TopRightReferencePoint);
	basketimage.x = startX-10;
	basketimage.y = startY+10;
	character:insert (basketimage);
        basketimage:stopAtFrame(thegame.CurrentSlot.CurrentBag);
        
        
	-- Head
        local headFiles={}
        for i=1,7 do
            headFiles[i]=folder.."manny_head_"..i..".png"
        end
        for i=1,7 do
            headFiles[i+7]=folder.."manny_head_f"..i..".png"
        end
        
        head = movieclip.newAnim(headFiles,38,38,0.5,0.5)

	--head = display.newImage(  model.."_head"..prefix..".png" )
	head.x = startX+character_Xoffsets.head
	head.y = startY+character_Yoffsets.head
	character:insert (head)

-- Leg Front
--manny_leg_barefoot-x2

        leg_front = movieclip.newAnim(leg_files,20,20,0.5,0);
	--leg_front = display.newImageRect(folder..model.."_leg_front_stand"..prefix..".png",16,20 )
        --leg_front.anchorY=0;
	--leg_front:set ReferencePoint(display.TopCenterReferencePoint);
	leg_front.x = startX+character_Xoffsets.leg_front
	leg_front.y = startY+character_Yoffsets.leg_front
	--leg_front.myName="character"
	character:insert (leg_front)
        leg_front:stopAtFrame(thegame.CurrentSlot.CurrentShoes);



PlaceBallIntoArms(nil,thegame.CurrentSlot.CurrentBall);
-- Arm Front
	arm_front = display.newImageRect(folder..model.."_arm_front"..prefix..".png",30,10 )
        arm_front.anchorX=0;
	--arm_front:set ReferencePoint(display.CenterLeftReferencePoint);
	arm_front.x = startX+character_Xoffsets.arm_front
	arm_front.y = startY+character_Yoffsets.arm_front
	--arm_front.myName="character"
	character:insert (arm_front)
	
        

                




	local wheel_r=7

	wheel = display.newCircle( 0, 0, wheel_r )
	wheel.x = startX+character_Xoffsets.wheel
	wheel.y = startY+character_Yoffsets.wheel
	wheel:setFillColor(0,0,0,0)
	
	character:insert (wheel)
	
	local d=1
        local e=0.1
        local f=0.4
	
	head.myName="character"
	physics.addBody (head, {bounce = e, density=1, friction=f, radius = 13})
	neck.myName="character"
	physics.addBody (neck, {bounce = e, density=1, friction = f})
	torso.myName="character"
	--physics.addBody (torso, {bounce = 0, density=1, friction = f, shape={-11,-11,11,-11,0,11} })
        --physics.addBody (torso, {bounce = 0, density=1, friction = f, shape={11,-11,-11,-11,0,11} })
        physics.addBody (torso, {bounce = 0, density=1, friction = f, shape={-11,-11,11,-11,0,11} })
	torso.isFixedRotation = true
	

        
        
        
	
	wheel.myName="character"
	physics.addBody (wheel, { bounce = 0.1, density=15, friction=f, radius = wheel_r})


	createCharacterJoints(startX,startY,1,true)
	
	wheel.isBullet=true

        PrepareEyes()

--local BacketJoint = physics.newJoint ( "pivot",  torso, basketimage, startX,startY)



        --wheel.collision = onWheelSensor
        --wheel:addEventListener( "collision", wheel)
        
        CreateSensors();
 
        
        
	return character
end


function findAnotherBall(self,BallTitle)
   
    for i=1, #thegame.CurrentSlot.BagContent do
        if thegame.CurrentSlot.BagContent[i]==BallTitle then
            
            thegame.CurrentSlot.BagContent[i]=nil;       
            local b={};
            for i = 1,#thegame.CurrentSlot.BagContent do
                local n=thegame.CurrentSlot.BagContent[i];
                if(n~=nil) then
                    b[#b+1]=n;
                end
                thegame.CurrentSlot.BagContent[i]=nil;
            end
            thegame.CurrentSlot.BagContent=b;
            print ("Ball Found="..BallTitle);
            PlaceBallIntoArms(nil,BallTitle);
            return true;
        end
        
    end
    
    
    
end

function RemoveBallFromArms(self)
    if MouseCurrentBallImage==nil then
        return "";
        
    end
    
    display.remove(MouseCurrentBallImage);
    MouseCurrentBallImage=nil;
    
    local a=thegame.CurrentSlot.CurrentBall;
    thegame.CurrentSlot.CurrentBall="";
    return a;
end
function PlaceBallIntoArms(self,BallTitle)
    local type_index=levels:findSpriteByTitle(BallTitle);
    if type_index~=nil and type_index~=-1 then
                    local s=sprite_collection.SpriteColection[type_index];
                    
                    display.remove(MouseCurrentBallImage);
                    MouseCurrentBallImage=nil;
                    
                    
                    MouseCurrentBallImage = display.newImageRect("src/images/sprites/"..s.image,s.width,s.height );
                    --ReferencePointFixed
                    --MouseCurrentBallImage:set ReferencePoint(display.CenterCenterReferencePoint);
                    MouseCurrentBallImage.x = torso.x
                    MouseCurrentBallImage.y = torso.y
                    character:insert (MouseCurrentBallImage)
                    
                    
                    thegame.CurrentSlot.CurrentBall=BallTitle;
    end
    
end

function EraseAllTimers()
    if(mousecharacter.wheel==nil or mousecharacter.wheel.x==nil) then
            return 
    end
    
    if turnTimer~=nil then
        timer.cancel( turnTimer ) 
        turnTimer=nil
    end
    
    if mouseVisorTimer~=nil then
        timer.cancel(mouseVisorTimer);
        mouseVisorTimer=nil
    end
    
    --if mouseJumpTimer~=nil then
        --timer.cancel(mouseJumpTimer);
      --  mouseJumpTimer=nil
    --end
    
    --if mouseJumpTimer2~=nil then
        --timer.cancel(mouseJumpTimer2);
      --  mouseJumpTimer2=nil
    --end
    
    for i=1, #changeEyesTimers do
            timer.cancel( changeEyesTimers[i] ) 
            changeEyesTimers[i]=nil
    end
    changeEyesTimers={}
    
    for i=1, #changeFaceTimers do
            timer.cancel( changeFaceTimers[i] ) 
            changeFaceTimers[i]=nil
    end
    changeFaceTimers={}
    isWaterSplashPlaying=false;
end


local function getsign(x)
    if(x>=0) then
        return 1;
    else
        return -1;
    end
end
                  ---------------------------------------------------------  end of move me function

function RemoveMiceVisor(self)
    if mouseVisorTimer~=nil then
         timer.cancel(mouseVisorTimer);
         mouseVisorTimer=nil;
    end
    display.remove(MiceVisor);
    MiceVisor=nil;

    
end


function StopMouseVerticalMovement()
    
    local vx,vy=wheel:getLinearVelocity();
    
    wheel:setLinearVelocity(vx,0);
    --wheel.angularVelocity=0
                        
    torso:setLinearVelocity(vx,0);
    --torso.angularVelocity=0
                        
    neck:setLinearVelocity(vx,0)
    --neck.angularVelocity=0
                        
    head:setLinearVelocity(vx,0);
    --head.angularVelocity=0
end




local function onMiceVisorCollision( self, event )
	if(not buttons.isGamePlaying or buttons.physics_paused or buttons.GameMode~=1) then
            return;
        end

        

        if ( event.phase == "began" ) then
            --StopMouse(nil);
            
            
            local eom=event.other.myName
            
            
            
            
            if eom=="food" then
                    local s=world.WorldSprites[CheeseIndex]
                    local energyvalue=sprite_collection.SpriteColection[event.other.typeIndex].energyvalue;
                    RemoveMiceVisor(nil);
                    thegame:EatFood(event.other.bodyIndex,energyvalue);
                    mouseVisorTimer=timer.performWithDelay(1000,UpdateMiceVisor,1)

                    return 
                    
            elseif eom=="coin" then
                    local s=world.WorldSprites[CheeseIndex]
                    local moneyvalue=sprite_collection.SpriteColection[event.other.typeIndex].moneyvalue;
                    RemoveMiceVisor(nil);
                    thegame:TakeCoin(event.other.bodyIndex,moneyvalue);
                    mouseVisorTimer=timer.performWithDelay(1000,UpdateMiceVisor,1)
                    --MiceVisorState=MiceVisorState+1
                    return 
            elseif eom=="flag" then
                    RemoveMiceVisor(nil);
                    thegame:FlagFound();
                    mouseVisorTimer=timer.performWithDelay(1000,UpdateMiceVisor,1)
                    --MiceVisorState=MiceVisorState+1
                    return 
            --elseif eom=="enemy" then
            
                --enemy:enemyAttack(event.target.x, event.other.bodyIndex);
                --return 
                
            elseif eom=="body" then
            else
                
                --if eom~="character" then
                    
                  --  StopMouseHorizontalMovement();    
                --end
            end
            
            

                            
           

        elseif ( event.phase == "ended" ) then

        end
end

function UpdateMiceVisor(self)
    
        
        if buttons.physics_paused then
            return
        end
    
        RemoveMiceVisor(nil)

        
        
            MiceVisor=display.newRect(0, 0, 10, 80)
            MiceVisor.anchorY=80;
            --MiceVisor:set ReferencePoint( display.BottomCenterReferencePoint )
            MiceVisor:setFillColor(0, 255,0, 0)
            game:insert(MiceVisor)
            MiceVisor.x=0
            MiceVisor.y=0
            MiceVisor.myName="MiceVisor"
            physics.addBody (MiceVisor,{ isSensor = true })
            MiceVisor.collision = onMiceVisorCollision
            MiceVisor:addEventListener( "collision", MiceVisor )

end




function TurnCharacter(self,TurnTo,ChangeFace)
   
    if buttons.physics_paused then
        return
    end
    
    
    if torso.xScale==TurnTo or ReadyToTurn then
		return false
    end
        

    ReadyToTurn=true
    
    

    if turnTimer~=nil then
        timer.cancel( turnTimer ) 
        turnTimer=nil
    end    
    local myclosure= function() DoTurnCharacter(TurnTo); end
    turnTimer=timer.performWithDelay(200,myclosure,1)
    
    if(ChangeFace) then
        changeFace(nil,0,100,{11,10,4,1})    
    end
end


local function ChangeLeg(self)
        if buttons.physics_paused then
            return
        end
    
    
	if(wheel.angularVelocity>50) then

		local m=math.sin(math.rad(leg_front.rotation))
		if(leg==1) then
			if(m<leg_max) then
				--change leg
				leg=0
			else
				leg_max=m
			end
		else
			if(m>leg_max) then
				--change leg
				leg=1
			else
				leg_max=m
			end
		end
	end -- of: if(wheel.angularVelocity>100) then
	
	
end --of function


function MouseFeelBad(self)
    torso.angularVelocity=10
    --head.angularVelocity=1000
    isMouseOk=false
end

local isWaterSplashPlaying=false;

local function HeadStability(vy)
    if(isMouseOk) then
            -- mouse holds head when ok
            if levels:CheckIfInWater(wheel.x,wheel.y) then
                -- < 25  - sink rapidly
                local v=0.5
                if vy>100 then
                    
                                
                    head:applyForce( 0,-200, head.x, head.y) -- slowdown
                    
                    if(isWaterSplashPlaying==false ) then      
                            isWaterSplashPlaying=true;
                            
                            loadsounds:PlayWaterSplashSound(1)
                            
                            
                            local myclosure= function() isWaterSplashPlaying=false; end
                            changeEyesTimers[#changeEyesTimers+1]=timer.performWithDelay(1000,myclosure,1)
                            
                    end
                
                else
                    head:applyForce( 0,-17, head.x, head.y)
                    --v=0.1
                    
                --    JustEnteredWater=true;
                end
                
                
                
                
            else
                if mouseTouchingFloor>0 then
                    head:applyForce( 0,-3, head.x, head.y);
                else
                    head:applyForce( 0,10, head.x, head.y);
                end
            end
        else
            --wheel:applyForce( 10*torso.xScale,30, wheel.x, wheel.y)
            head:applyForce( 10*-torso.xScale,30, head.x, head.y)
        end
end

local function Movements()
    -- depricated
    if(move_to==1) then
		wheel:applyForce( 20,0, wheel.x, wheel.y)
	end
	
	

	if(move_to==2) then
		wheel:applyForce( -20,0, wheel.x, wheel.y)
	end
	
	if(move_to==-1) then
		local vx, vy = wheel:getLinearVelocity()
		
		if(vx>10) then
			wheel:applyForce( -20,0, wheel.x, wheel.y)
			wheel.angularVelocity=0
		else
			obj.move_to=0
		end
		
	end
	
	if(move_to==-2) then
		local vx, vy = wheel:getLinearVelocity()
		
		if(vx<10) then
			wheel:applyForce(20,0, wheel.x, wheel.y)
			wheel.angularVelocity=0
		else
			move_to=0
		end

	end
end

local function UpdateBallPosition()
    if MouseCurrentBallImage~=nil then
        MouseCurrentBallImage.x = torso.x+15*torso.xScale;
        --MouseCurrentBallImage.y = torso.y;
    end            
end
local function UpdateBagPosition()
    if(torso.xScale==1) then
            basketimage.xScale=1
            basketimage.x=wheel.x+9---10;
            basketimage.y=wheel.y-45--+10+3+1;
            
            --basketimage2.xScale=1
            --basketimage2.x=wheel.x+9;
            --basketimage2.y=wheel.y-45;
            
        else
            
            basketimage.xScale=-1
            basketimage.x=wheel.x-10;
            basketimage.y=wheel.y-45--+10+3+1;
            
            --basketimage2.xScale=-1
            --basketimage2.x=wheel.x-10;
            --basketimage2.y=wheel.y-45;
        end
end

local function UpdateTail()
    
if torso.xScale==1 then
	--tail.x=torso.x-(torso.width*0.5)
        tail.x=torso.x+character_Xoffsets.tail
else
    
	--tail.x=torso.x+(torso.width*0.5)
        tail.x=torso.x-character_Xoffsets.tail
end
tail.y=torso.y+torso.height*0.5
local shake_level=math.abs(math.floor(wheel.angularVelocity/100))+1

--if shake_level==0 then
	

tail_shake=tail_shake+tail_shake_d
if tail_shake>shake_level or tail_shake<-shake_level then
tail_shake_d=-tail_shake_d
end

local tailAngle=math.floor(wheel.angularVelocity/50)


if tailAngle>25 then
	tailAngle=25
end

if tailAngle<-25 then
	tailAngle=-25
end

tail.rotation=-tailAngle+(15)*torso.xScale
        

end


local function WheelAndMiceVisorUpdate()
    if(MiceVisor~=nil) then
            if(MiceVisor.x~=nil) then
                MiceVisor.y= wheel.y+5---wheel.radius
                MiceVisor.x= wheel.x+15*torso.xScale
                

                
            end
        end
        
        if(WheelVisor~=nil) then
            if(WheelVisor.x~=nil) then
                
                WheelVisor.y= wheel.y+2;
                WheelVisor.x= wheel.x;
                

                
            end
        end
        
        if(FootVisor~=nil) then
            if(FootVisor.x~=nil) then
                
                FootVisor.y= wheel.y-25;
                FootVisor.x= wheel.x+15*torso.xScale;
                

                
            end
        end
        
        
end


local function UpdateLegs()
    
local s=math.sin(math.rad(wheel.rotation))
local r=s*(wheel.angularVelocity/10+5)--where 7 is leg angle cooficient

local s2=math.sin(math.rad(wheel.rotation*0.5))
local r2=s2*(wheel.angularVelocity/10+5)--where 7 is leg angle cooficient

local max_leg_angle=70

if(r>max_leg_angle) then
	r=max_leg_angle
end
	
if(r<-max_leg_angle) then
	r=-max_leg_angle
end
	
local x=wheel.x--+game.x

ChangeLeg(r)


local kx=0--2
local ky=12
local leg_d=1

-- legs

leg_back.x=x+1-kx
leg_back.y=wheel.y-1-ky+leg_d-leg_d*leg  -- +10
leg_back.rotation=-r

leg_front.x=x-2-kx
leg_front.y=wheel.y-ky+leg_d*leg  --+10
leg_front.rotation=r
return r2;
end

local function UpdateArms(r2)
    local ar=r2*1.5
local max_arm_angle=50
local h=0;

if MouseCurrentBallImage~=nil then
    max_arm_angle=10
    ar=r2*0.2
    h=-50;
    MouseCurrentBallImage.y = torso.y-math.abs(ar)*.10;
end

if(ar>max_arm_angle) then
	ar=max_arm_angle
end
	
if(ar<-max_arm_angle) then
	ar=-max_arm_angle
end



--if(ar<min_arm_angle) then
--	ar=min_arm_angle
--end




arm_back.x=torso.x+1
arm_back.y=torso.y-13
arm_back.rotation=-ar+(90+h)*torso.xScale-5

arm_front.x=torso.x+1
arm_front.y=torso.y-13
arm_front.rotation=ar+2+(90+h)*torso.xScale

end

function MoveCharacter(self)
    if(mousecharacter.wheel==nil or mousecharacter.wheel.x==nil) then
            return false;
    end
    if(buttons.physics_paused)then
        return false;
    end   
    
    local vx,vy=wheel:getLinearVelocity()
    
    if math.abs(vx)<20 then
        StopMouseHorizontalMovement();
    end
    
    if math.abs(wheel.angularVelocity)<1 then
        wheel.angularVelocity=0
    end 
    
    if jumpingNextToWall==1 and vy+100>0 then
        if mouseNextToWall==0 then
            wheel:applyForce(200*torso.xScale,vy, wheel.x, wheel.y)
            jumpingNextToWall=2;
        end
    
        
    end

    if(getsign(vx)~=torso.xScale) then
        --moving to another direction
        if math.abs(vx)>100 then
                -- turn body
                 TurnCharacter(nil,getsign(vx),true)
        end
        
    end
    
    WheelAndMiceVisorUpdate()
        
    UpdateBallPosition();
        
    UpdateBagPosition();

    HeadStability(vy);

    UpdateEyes();
    
    UpdateArms(UpdateLegs());

    UpdateTail();

end 



function StopMouse(self)
    --wheel:setLinearVelocity( 0,0 )
    --wheel.angularVelocity=0
    
    wheel:setLinearVelocity( 0,0 )
    wheel.angularVelocity=0
                        
    torso:setLinearVelocity( 0,0 )
    torso.angularVelocity=0
                        
    neck:setLinearVelocity( 0,0 )
    neck.angularVelocity=0
                        
    head:setLinearVelocity( 0,0 )
    head.angularVelocity=0
end

function RunForCheese(self,CheeseIndex)
    
    local s=world.WorldSprites[CheeseIndex]
    local attraction=sprite_collection.SpriteColection[s.typeIndex].attraction
    local m=getsign(s.x-wheel.x)
    local dx=attraction*10*m--(s.x-wheel.x)/200*
    
    if torso.xScale~=m then
        StopMouse()
    end
    TurnCharacter(nil,m,false)
    wheel:applyForce(dx,0, wheel.x, wheel.y)
end



function changeEyes(self,delay,speed,sequence)
    
  
    
    
    for i=1, #changeEyesTimers do
            timer.cancel( changeEyesTimers[i] ) 
            changeEyesTimers[i]=nil
    end
    changeEyesTimers={}
    local myclosure={}

    for i,line in ipairs(sequence) do
        
        if(sequence[i]>0 and sequence[i]<4) then
            
            local index=sequence[i]

            myclosure[i]= function() EyesSide:stopAtFrame(index);EyesState=index;Front=false; end
            changeEyesTimers[#changeEyesTimers+1]=timer.performWithDelay(delay+(i-1)*speed,myclosure[i],1)
        end
        
        if(sequence[i]>3 and sequence[i]<7) then
            local index=sequence[i]-3

            myclosure[i]= function() EyesFront:stopAtFrame(index);EyesState=index;Front=true; end
            changeEyesTimers[#changeEyesTimers+1]=timer.performWithDelay(delay+(i-1)*speed,myclosure[i],1)
        end
        
    end

end

function blinkEyes(self)

    
    
    changeEyes(nil,0,100,{1,2,3,2,1})
end

function changeShoes(self,index)
    if(index>4) then
        index=1;
    end
    
    thegame.CurrentSlot.CurrentShoes=index;
    leg_back:stopAtFrame(index);
    leg_front:stopAtFrame(index);
end

function changeBag(self,index,copacity)
    if(index>4) then
        index=1;
    end
    
    thegame.CurrentSlot.CurrentBag=index;
    thegame.CurrentSlot.CurrentBagCopacity=copacity;
    basketimage:stopAtFrame(index);
end

function changeFaceAnySide(self,delay,speed,sequence,front_)

    
    for i=1, #changeFaceTimers do
            timer.cancel( changeFaceTimers[i] ) 
            changeFaceTimers[i]=nil
    end
    changeFaceTimers={}
    
    local myclosure={}
    for i,line in ipairs(sequence) do
        
        if(sequence[i]>0 and sequence[i]<8) then
            local index=sequence[i]
            if(front_)then
                index=index+7
            end
            myclosure[i]= function() head:stopAtFrame(index);if index>7 then Front=true else Front=false end end
            changeFaceTimers[#changeFaceTimers+1]=timer.performWithDelay(delay+(i-1)*speed,myclosure[i],1)
        end
    end

end

function changeFace(self,delay,speed,sequence)
        

        
    for i=1, #changeFaceTimers do
            timer.cancel( changeFaceTimers[i] ) 
            changeFaceTimers[i]=nil
    end
    changeFaceTimers={}
    
    local myclosure={}
    for i,line in ipairs(sequence) do
        
        if(sequence[i]>0 and sequence[i]<15) then
            local index=sequence[i]

            myclosure[i]= function() 
                head:stopAtFrame(index);
                if index>7 then 
                    Front=true
                else
                    Front=false
                end
            end
            changeFaceTimers[#changeFaceTimers+1]=timer.performWithDelay(delay+(i-1)*speed,myclosure[i],1)
        end
    end

end


function DoTurnCharacter(TurnTo)

        if buttons.physics_paused then
            return
        end

	
	local startX=wheel.x
	local startY=wheel.y-character_Yoffsets.wheel
		
	local s=TurnTo
	tail.xScale = s
	if TurnTo==1 then
		--tail:set Reference Point(display.BottomRightReferencePoint);
	else
		--tail:set Reference Point(display.BottomLeftReferencePoint);
	end
	
	
removeCharacterJoints(true)


			leg_back.xScale = s
			leg_back.x=startX+character_Xoffsets.leg_back*s
			
			arm_back.xScale = s
			arm_back.x=startX+character_Xoffsets.arm_back*s
			
			tail.xScale = s
			tail.x=startX+character_Xoffsets.tail*s
			tail.y=startY+character_Yoffsets.tail
			
			torso.xScale = s
			torso.x=startX+character_Xoffsets.torso*s
			torso.y=startY+character_Yoffsets.torso

			neck.xScale = s
			neck.x=startX+character_Xoffsets.neck*s
			neck.y=startY+character_Yoffsets.neck
			
			head.xScale = s
			head.x=startX+character_Xoffsets.head*s
			head.y=startY+character_Yoffsets.head
			
			leg_front.xScale = s
			leg_front.x=startX+character_Xoffsets.leg_front*s
			
			arm_front.xScale = s
			arm_front.x=startX+character_Xoffsets.arm_front*s
	
			--tail.rotation=-20*s
			neck.rotation=0
			head.rotation=0
			
	createCharacterJoints(startX,startY,TurnTo,true)
        
        
        ReadyToTurn=false
end
