--
-- Project: background.lua
-- Description: 
--
-- Version: 1.0
-- Managed with http://CoronaProjectManager.com
--
-- Copyright 2012 . All Rights Reserved.
-- 
module(..., package.seeall)

local Positions=nil;



GameMode=1
-- 1 game
-- 0 editor
ControlButtonWidth=50;
local TimerSet=false
------------------
local EditorButton=nil;
local ButtonPause = nil;
local ButtonMenu = nil;
local ButtonReplay = nil;
local ButtonCameraSwitch=nil
local Loading=nil
----- controls ---
local MoveLeftButton = nil
local MoveRightButton = nil
local JumpButton = nil
local buttonInitialOpacity=0.3
------------------
isGamePlaying=false

local AllTransition={}

local function CancelAllTransition()
    for i=1, #AllTransition  do

        transition.cancel(AllTransition[i])
        AllTransition[i]=nil

    end
    i=nil
    AllTransition={}
end
-- -------------------------------------------------------- Game Buttons

local function is3x4screen()
    if(display.pixelHeight==1024 and display.pixelWidth==768) then return true; end;
    
    if(display.pixelHeight==2048 and display.pixelWidth==1536) then return true; end;
    
    return false;
        
end

local MoveLeftButtonPressed=false;
local MoveRightButtonPressed=false;
local MoveTimer=nil;


local function doMove(d)
    --MoveLeftButtonPressed and 
    if mousecharacter.mouseTouchingFloor>0 then
         local w=mousecharacter.wheel
         local vx,vy=w:getLinearVelocity()
         local f=mousecharacter.MouseRunForce;
         
         --if mousecharacter.mouseTouchingFloor<=0 then
             --f=mousecharacter.MouseAirRunForce;
         --end
         
         if thegame.CurrentSlot.CurrentBag==4 then
             -- if you carry garbage bin
             f=f/3;
         end
         
         
         
         vx=math.floor(vx);
         if d==1 then
            if vx<0 then
                 mousecharacter:StopMouse();
            end
            if vx<mousecharacter.MouseRunLimit then
                w:applyForce(f*d,0, w.x, w.y)
                if thegame.CurrentSlot.CurrentShoes==1 then
                    thegame.CurrentSlot.Energy=thegame.CurrentSlot.Energy-2;
                end
                --move right
            end
        else  
            if vx>0 then
                 mousecharacter:StopMouse();
            end
            
            if vx>-mousecharacter.MouseRunLimit then
                w:applyForce(f*d,0, w.x, w.y)
                if thegame.CurrentSlot.CurrentShoes==1 then
                    thegame.CurrentSlot.Energy=thegame.CurrentSlot.Energy-2;
                end
                --move left
            end
        end
    end
end

local function doMoveToTheLeft()
    doMove(-1);
end

local function doMoveToTheRight()
    doMove(1);
end


local function removeMoveEvent()
    if MoveTimer~=nil then
                 timer.cancel(MoveTimer) 
                 MoveTimer=nil
                 
                 
                 --MoveLeftButton.alpha=buttonInitialOpacity;
                 --MoveRightButton.alpha=buttonInitialOpacity;
        end
end

function UncheckButtons(self)
    if MoveLeftButton==nil or MoveRightButton==nil then
        return false;
    end
    --Uncheck Buttons
    removeMoveEvent();
    
    MoveLeftButtonPressed=false;
    MoveLeftButton.alpha=buttonInitialOpacity;
    
    MoveRightButtonPressed=false;
    MoveRightButton.alpha=buttonInitialOpacity;
end

function checkIfLeftButtonPressed(self,x,y)
    if MoveLeftButton==nil or MoveRightButton==nil then
        return false;
    end
    
    local thw=MoveLeftButton.width*0.5;
    local thh=MoveLeftButton.height*0.5;
    local tx=MoveLeftButton.x;
    local ty=MoveLeftButton.y;
    if x>=tx-thw and x<=tx+thw and  y>=ty-thh and y<=ty+thh then
        if (MoveLeftButtonPressed==false) then
            MoveLeftButtonPressed=true;
            MoveLeftButton.alpha=1;
            removeMoveEvent();
                        
            mousecharacter:TurnCharacter(-1,false);
            
            
            MoveTimer=timer.performWithDelay(100,doMoveToTheLeft,0);
        end
        return true;
    else
        --Away from the button
        if(MoveLeftButtonPressed)then
            mousecharacter:StopMouse();
            removeMoveEvent();
            MoveLeftButtonPressed=false;
            MoveLeftButton.alpha=buttonInitialOpacity;    
        end
        
        return false;
    end
end


function checkIfRightButtonPressed(self,x,y)
    if MoveLeftButton==nil or MoveRightButton==nil then
        return false;
    end
    
    local thw=MoveRightButton.width*0.5;
    local thh=MoveRightButton.height*0.5;
    local tx=MoveRightButton.x;
    local ty=MoveRightButton.y;
    if x>=tx-thw and x<=tx+thw and  y>=ty-thh and y<=ty+thh then
        if (MoveRightButtonPressed==false) then
            MoveRightButtonPressed=true;
            MoveRightButton.alpha=1;
            removeMoveEvent();
            
            mousecharacter:TurnCharacter(1,false);
        
            MoveTimer=timer.performWithDelay(100,doMoveToTheRight,0);
        end
        return true;
    else
        if(MoveRightButtonPressed) then
            mousecharacter:StopMouse();
            removeMoveEvent();
            MoveRightButtonPressed=false;
            MoveRightButton.alpha=buttonInitialOpacity;    
        end
        
        return false;
    end
end

function Jump(event)
    local phase = event.phase 
    if phase== "began" and not TimerSet  then
        
        
        if mousecharacter.mouseTouchingFloor>0 then
            local w=mousecharacter.wheel;
            --local vx,vy=w:getLinearVelocity()
            --w:setLinearVelocity( vx,0 );
            mousecharacter:StopMouseVerticalMovement();
            
            
            loadsounds:PlayMouseJumpSound(mousecharacter.MouseJumpForce*0.0005-0.2);
            
            
            w:applyForce(0,-mousecharacter.MouseJumpForce, w.x, w.y)
            --jump
            JumpButton.alpha=1
            thegame.CurrentSlot.Energy=thegame.CurrentSlot.Energy-10;
            
            if mousecharacter.mouseNextToWall>0 then
                -- Jump on to something if possible
                mousecharacter.jumpingNextToWall=1;
                --Jumping next to the wall
            end
            
            
        end
    end
    
    if phase== "ended" then
        JumpButton.alpha=buttonInitialOpacity;
    end
end
--[[
function MoveRight(event)
    if not TimerSet  then
        
        local phase = event.phase
        local target = event.target
        local x=event.x
        local y=event.y
        local thw=target.width*0.5;
        local thh=target.height*0.5;

        
        if phase== "began" then
            removeMoveEvent()
            MoveRightButtonPressed=true;
            
            MoveTimer=timer.performWithDelay(100,doMoveToTheRight,0);
            MoveRightButton.alpha=1;
        elseif phase== "ended" then
            removeMoveEvent()
            MoveRightButtonPressed=false;
            MoveRightButton.alpha=buttonInitialOpacity;
        end
        
        
    end
end

--]]

local function removeControls()
    
    removeMoveEvent();
    
    if(MoveLeftButton~=nil and MoveLeftButton.x~=nil) then
        
        --MoveLeftButton:removeEventListener( "touch", MoveLeft)
        display.remove(MoveLeftButton)
        MoveLeftButton=nil
    end
    

    if(MoveRightButton~=nil and MoveRightButton.x~=nil) then
        --MoveRightButton:removeEventListener( "touch", MoveRight)
        display.remove(MoveRightButton)
        MoveRightButton=nil
    end
    
    
    if(JumpButton~=nil and JumpButton.x~=nil) then
        JumpButton:removeEventListener( "touch", Jump)
        display.remove(JumpButton)
        JumpButton=nil
    end

end




local function createControls()
    local yOffset=0;
    if is3x4screen() then
        yOffset=20;
    end
    
    
    local y=display.contentHeight-50+yOffset;
    
        MoveRightButton = display.newImageRect( "src/images/controls/jump.png", 100,100)
        --ReferencePointFixed
	--MoveRightButton:set ReferencePoint(display.CenterCenterReferencePoint);
	MoveRightButton.x=150;
        MoveRightButton.xScale=-1;
	MoveRightButton.y=y;
        MoveRightButton.rotation=90;
        MoveRightButton.alpha=buttonInitialOpacity;
        
        --MoveRightButton:addEventListener( "touch", MoveRight)
        
        --------------------------
        
        MoveLeftButton = display.newImageRect( "src/images/controls/jump.png", 100,100)
        --ReferencePointFixed
	--MoveLeftButton:set ReferencePoint(display.CenterCenterReferencePoint);
	MoveLeftButton.x=50;
	MoveLeftButton.y=y;
        MoveLeftButton.rotation=270;
        MoveLeftButton.alpha=buttonInitialOpacity;
        
        --MoveLeftButton:addEventListener( "touch", MoveLeft)
        ----------------------------
        JumpButton = display.newImageRect( "src/images/controls/jump.png", 100,100)
        --ReferencePointFixed
	--JumpButton:set ReferencePoint(display.CenterCenterReferencePoint);
	JumpButton.x=display.contentWidth-50;
	JumpButton.y=y;
        JumpButton.rotation=0;
        JumpButton.alpha=buttonInitialOpacity;
        
        JumpButton:addEventListener( "touch", Jump)

end


function createGameButtons(self)



    local yOffset=0;
    if is3x4screen() then
        yOffset=20;
    end
    
    local l=0
    local l2=l+50--+2
    local r=display.contentWidth-50-2
    local r2=r-50-2
    local r3=r2-50-2
    local r4=r3-50-2
    local rb=r3-50-2-5
    
    local t=2-yOffset
    local t2=t+50+2
    local t3=t2+50+2
    local t4=t3+50+2
    local tb=display.contentHeight-50-2+yOffset
    
    if advertising.ShowAdvertising then
        --Positions={r,t,r,t2,r,t3,r,t4} -- with ad on left to corner
        --Positions={l,t2,l,t3,r,t2,r,t3} -- with ad on left to corner
        
        if system.getInfo( "platformName" ) == "iPhone OS" then
           Positions={r4,t,r3,t,r2,t,r,t} -- with ad on left top corner
        else
           -- android
           Positions={l,t,l,t2,r,t,rb,tb} -- with ad on center top
        end
        
    else
        Positions={l,t, l2,t, r,t, r2,t} -- no ads
    end
    
    isGamePlaying=true
    buttons.GameMode=1
    
    
    

ButtonMenu = widget.newButton{
        id="MenuButton",
        left=Positions[1],
        top=Positions[2],
	defaultFile = "src/images/buttons/button_menu.png",
	overFile = "src/images/buttons/button_hover_menu.png",
	onRelease =Menu,
	width=50,
        height=50
}


--CreateCameraButton()

ButtonReplay = widget.newButton{
        id="ReplayButton",
        left=Positions[3],
        top=Positions[4],
	defaultFile = "src/images/buttons/button_replay.png",
	overFile = "src/images/buttons/button_hover_replay.png",
	onRelease =Replay,
	width=50,
        height=50
}

   

ButtonPause = widget.newButton{
	defaultFile = "src/images/buttons/button_pause.png",
	overFile = "src/images/buttons/button_hover_pause.png",
	onRelease =Pause,
	width=50,
        height=50,
        left=Positions[5],
        top=Positions[6],
        id="PauseButton"
}


if(thegame.CurrentSlot.CurrentBag>1) then
    ButtonBag = widget.newButton{
	defaultFile = "src/images/buttons/button_hint.png",
	overFile = "src/images/buttons/button_hover_hint.png",
	onRelease =Bag,
	width=50,
        height=50,
        left=Positions[7],
        top=Positions[8],
        id="BagButton"
    }
end



    createControls();


    TimerSet=false
end

     


local function StartGame()
    system.setIdleTimer(false)
    
    CancelAllTransition()
    thegame:setSkyDropListener()
    isGamePlaying=true
    if(thegame.BackGroundMusicChannel~=-1) then
        audio.resume(thegame.BackGroundMusicChannel)
    end
    
    physics_paused=false
    physics.start()
    
    --if(ButtonStart~=nil) then
    display.remove(ButtonStart)
    ButtonStart=nil
    --end
    
    local yOffset=0;
    if is3x4screen() then
        yOffset=20;
    end
    
    
    ButtonPause = widget.newButton{
            id="PauseButton",
            left=Positions[5],
            top=Positions[6],
            defaultFile = "src/images/buttons/button_pause.png",
            overFile = "src/images/buttons/button_hover_pause.png",
            onRelease =Pause,
            label = "",
            font=defaultFontName,
            width=50,
            height=50
    }
    
    --CreateCameraButton()
    
    --if(coverDeskPause~=nil and coverDeskPause.x~=nil) then
    display.remove(coverDeskPause)
    coverDeskPause=nil
    --end
    
    --if(PauseText~=nil and PauseText.x~=nil) then
    display.remove(PauseText)
    PauseText=nil
    
    
    ButtonMenu.isVisible=true
    ButtonReplay.isVisible=true
    if(ButtonBag~=nil) then
            ButtonBag.isVisible=true;
    end
    
    advertising:ShowAd();
end


function Start(event)
    if "ended" == event.phase then
        advertising:HideAd();
        StartGame()
    end
end

function PauseGame(useDelay)
    
        
        
        advertising:HideAd()
        
        
        system.setIdleTimer( true)
        CancelAllTransition()
        thegame:removeSkyDropListener()
        isGamePlaying=false
    
        if(thegame.BackGroundMusicChannel~=-1) then
            audio.pause(thegame.BackGroundMusicChannel)
        end
    
        physics_paused=true
        physics.pause()
       
        if(ButtonPause~=nil) then
            display.remove(ButtonPause)
            ButtonPause=nil
        end
        
        if(ButtonBag~=nil) then
            ButtonBag.isVisible=false;
        end
    
    --[[
        if(ButtonCameraSwitch~=nil) then
            display.remove(ButtonCameraSwitch)
            ButtonCameraSwitch=nil
        end
        ]]
       
        if(ButtonMenu~=nil) then
        ButtonMenu.isVisible=false
        end
        
        if(ButtonReplay~=nil) then
        ButtonReplay.isVisible=false
        end

     
        coverDeskPause = display.newRect(0, 0,display.contentWidth*2,display.contentHeight*2)
	coverDeskPause:setFillColor(0,0,0, 250)
        --ReferencePointFixed
        --coverDeskPause:set ReferencePoint( display.CenterCenterReferencePoint)
        coverDeskPause.x=display.contentWidth*0.5
        coverDeskPause.y=display.contentHeight*0.5
        if useDelay then
            coverDeskPause.alpha=0
        else
            coverDeskPause.alpha=0.7
        end
 
        
        local fontName = "Grinched"
        local fontSize = 48

        PauseText = display.newText( "PAUSE", 0, 0,125,80, fontName, fontSize )
        PauseText.anchorY=0;
--        PauseText:set ReferencePoint( display.TopCenterReferencePoint)
        PauseText.x=display.contentWidth*0.5
        PauseText.y=display.contentHeight*0.5-PauseText.height*0.5-20

        PauseText:setTextColor(255,200,0)
        
        
              
        ButtonStart = widget.newButton{
            id="PlayButton",
            defaultFile = "src/images/buttons/button_play.png",
            overFile = "src/images/buttons/button_hover_play.png",
            onRelease =Start,
            left=display.contentWidth*0.5-25,
            top=display.contentHeight*0.5+10,
            width=50,
            height=50
        }

        if useDelay then
            AllTransition[#AllTransition+1]=transition.to( coverDeskPause, { time=500, alpha=0.7 } )
            advertising:ShowAd()
        end
    
end

function Pause(event)
    local phase = event.phase 
    if "ended" == phase and not TimerSet  then
        
        PauseGame(true);
    end
end


function Bag(event)
    
    local phase = event.phase 
    if "ended" == phase and not TimerSet  then
        
        if(buttons.physics_paused or buttons.GameMode==0)then
            --Touch Sky when game paused - should be imposible
            return false
        end
        
        advertising:HideAd();
       
            
  --gameGroup:insert( testMsgBox )
  
  
        -- **********************************
            
        --storehouse:ShowStoreWindow();
        bag:ShowBagWindow()
        return true;
       
        
    end
    
 end

function doQuit(event)
    if "ended" == event.phase then

        advertising:HideAd();
        os.exit();
    end
end

function doNotQuit(event)
    if "ended" == event.phase then

        advertising:HideAd();
        display.remove(ButtonQuitYes)
        ButtonQuitYes=nil
        
        display.remove(ButtonQuitNo)
        ButtonQuitNo=nil
        
        --if(QuitText~=nil and QuitText.x~=nil) then
            display.remove(QuitText)
            QuitText=nil
        --end
        
        --if(coverDeskQuit~=nil and coverDeskQuit.x~=nil) then
            display.remove(coverDeskQuit)
            coverDeskQuit=nil
        --end
        
        
        if mainmenu.isMainMenuOpen then
            mainmenu:ShowHideButtons(true);
        else
            StartGame()
            enableKeyEvent_Main()
        end
    end
    
end


function QuitDialog(self)
        CancelAllTransition()
        --Do you want to quit?
        
        if isGamePlaying then
            --Pause the game
            thegame:removeSkyDropListener()
            
            if(thegame.BackGroundMusicChannel~=-1) then
                audio.pause(thegame.BackGroundMusicChannel)
            end
    
            physics_paused=true
            physics.pause()
       
            if(ButtonPause~=nil) then
                display.remove(ButtonPause)
                ButtonPause=nil
            end
    
            if(ButtonCameraSwitch~=nil) then
                display.remove(ButtonCameraSwitch)
                ButtonCameraSwitch=nil
            end
       
            ButtonMenu.isVisible=false
            ButtonReplay.isVisible=false
            
            isGamePlaying=false
        end
        
        if mainmenu.isMainMenuOpen then
            --Hide Cover Buttons
            mainmenu:ShowHideButtons(false)
        end
        
    
 
     
        coverDeskQuit = display.newRect(0, 0,display.contentWidth*2,display.contentHeight*2)
	coverDeskQuit:setFillColor(0,0,0, 250)
        --ReferencePointFixed
        --coverDeskQuit:set ReferencePoint( display.CenterCenterReferencePoint)
        coverDeskQuit.x=display.contentWidth*0.5
        coverDeskQuit.y=display.contentHeight*0.5
        coverDeskQuit.alpha=0
        
        
        local fontName;
        --if system.getInfo( "platformName" ) == "iPhone OS" then
          --  fontName=native.systemFont;
        --else
            fontName="Grinched";
        --end
        local fontSize = 36

        QuitText = display.newText( "Do you want to quit?", 0, 0,275,50, fontName, fontSize )
        QuitText.anchorY=0;
        --QuitText:set ReferencePoint( display.TopCenterReferencePoint)
        QuitText.x=display.contentWidth*0.5
        QuitText.y=display.contentHeight*0.5-QuitText.height*0.5-40

        QuitText:setTextColor(255,200,0)
        
        local x=display.contentWidth*0.5-25
        local y=display.contentHeight*0.5+10
              
        ButtonQuitYes = widget.newButton{
            id="QuitYesButton",
            defaultFile = "src/images/buttons/button_yes.png",
            overFile = "src/images/buttons/button_hover_yes.png",
            onRelease =doQuit,
            left=x-50,
            top=y,
            width=50,
            height=50
        }

        ButtonQuitNo = widget.newButton{
            id="QuitNoButton",
            defaultFile = "src/images/buttons/button_no.png",
            overFile = "src/images/buttons/button_hover_no.png",
            onRelease =doNotQuit,
            left=x+50,
            top=y,
            width=50,
            height=50
        }


        AllTransition[#AllTransition+1]=transition.to( coverDeskQuit, { time=400, alpha=0.8 } )

end




function removeAllButtons()
        --Remove Buttons
        CancelAllTransition();
        isGamePlaying=false;
    
        if(ButtonPause~=nil and ButtonPause.x~=nil) then
            display.remove( ButtonPause);
            ButtonPause=nil;
        end
        
        if(ButtonStart~=nil and ButtonStart.x~=nil) then
            display.remove( ButtonStart);
            ButtonStart=nil;
        end
        
        if(ButtonMenu~=nil) then
            display.remove( ButtonMenu);
            ButtonMenu=nil;
        end

        if(ButtonReplay~=nil and ButtonReplay.x~=nil) then
            display.remove( ButtonReplay);
            ButtonReplay=nil;
        end
        
        if(ButtonBag~=nil) then
            display.remove( ButtonBag);
            ButtonBag=nil;
        end
        
        --[[
        if(ButtonCameraSwitch~=nil and ButtonCameraSwitch.x~=nil) then
            display.remove( ButtonCameraSwitch)
            ButtonCameraSwitch=nil
        end
        ]]--
        
        
        
        if system.getInfo( "environment" ) == "simulator" then
            if(EditorButton ~=nil and EditorButton .x~=nil) then
                display.remove(EditorButton)
                EditorButton=nil
            end
        end 
        
        
        removeControls()
end

function DoReplay(self)
        CancelAllTransition()
        removeAllButtons()
        thegame:Replay(true)
        
        --if(coverDeskReplay~=nil and coverDeskReplay.x~=nil) then
          --  display.remove(coverDeskReplay)
            --coverDeskReplay=nil
        --end
end

function Replay(event)
    if "ended" == event.phase and not TimerSet then
        local index=thegame.CurrentSlot.index;
        thegame:setCurrentSlot(index);
    
    
        isGamePlaying=false;
        Runtime:removeEventListener( "key", onKeyEvent_Main )
        thegame:removeSkyDropListener()
        TimerSet =true
        buttons.physics_paused=true
        physics.pause()
        
        ButtonReplay.isVisible=false
        removeAllButtons()
        
        
        
        world.StopWinLose()    

       DoReplay()

    end
end


local function doMenu()
        system.setIdleTimer( true)
        CancelAllTransition()
        if(thegame.BackGroundMusicChannel~=-1) then
            audio.pause(thegame.BackGroundMusicChannel)
        end
    

    
        --if(coverDeskPause~=nil and coverDeskPause.x~=nil) then
        display.remove(coverDeskPause)
        coverDeskPause=nil
        --end
        

        
        mainmenu:OpenMainMenu()
        display.remove(Loading)
        Loading=nil
end
function MenuEvent()
    
    Loading = display.newImageRect( "src/images/misc/loading.png",122,48)
    --ReferencePointFixed
    --Loading:set ReferencePoint(display.CenterCenterReferencePoint);
    Loading.x=display.contentWidth*0.5
    Loading.y=display.contentHeight*0.5
        
    CancelAllTransition()
    Runtime:removeEventListener( "key", onKeyEvent_Main )
    thegame:removeSkyDropListener()
    removeAllButtons()
    TimerSet = true
        
    timer.performWithDelay( 10, doMenu, 1 )    
end

function Menu(event)
    
    if event.phase == "ended" and not TimerSet then
        MenuEvent()
    end
end

-- -------------------------------------------------------------------------------- Game Functions

function Switch2Editor(event)
    if "ended" == event.phase then
        
        
	--if(EditorButton) then
            display.remove(EditorButton)
            EditorButton=nil
        --end
	
	GameMode=0
	local editor = require( "editor" )
	editor:createEditorButtons()
        
        
   end
	
end

