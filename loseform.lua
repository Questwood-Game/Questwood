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
local Timers={}
local AllTransition={}
local coverDesk=nil
local coverDesk2=nil
local loser_window=nil
local Loading=nil
local function CancelAllTransition()
    for i=1, #AllTransition  do

        transition.cancel(AllTransition[i])
        AllTransition[i]=nil

    end
    i=nil
    AllTransition={}
end

local function cancelTimers()
    for i=1, #Timers do
            timer.cancel( Timers[i] ) 
            Timers[i]=nil
    end
    Timers={}
end


function DisableGame(self)
    buttons.isGamePlaying=false;
    buttons.physics_paused=true
    physics.pause()
    
end


local function DrawLoserWindow(formImage)
        CancelAllTransition()
        cancelTimers()
        
        coverDesk = display.newRect(0, 0,display.contentWidth*2,display.contentHeight*2)
	coverDesk:setFillColor(0,0,0, 250)
        --ReferencePointFixed
        --coverDesk:set ReferencePoint( display.CenterCenterReferencePoint)
        coverDesk.x=display.contentWidth*0.5
        coverDesk.y=display.contentHeight*0.5--0
        coverDesk.alpha=0
	--game:insert (coverDesk)
        AllTransition[#AllTransition+1]=transition.to( coverDesk, { time=500, alpha=0.8 } )
                    
               local w=400
               local h=300
                        
	loser_window = display.newGroup();

        loser_window.width= w
        loser_window.height= h
        
	loser_window.x =display.contentWidth*0.5-200
	loser_window.y =0---280-- 0-loser_window.height
        loser_window.alpha=1
        

        --local stageFile=nil
        --if RunOutOfItems then
            --stageFile="tryagainstage.jpg"
        --else
            --stageFile="loststage.jpg"
        --end
        
        local board = display.newImageRect("src/images/stages/"..formImage..".png",236,146)
        --ReferencePointFixed
        --board:set ReferencePoint( display.CenterCenterReferencePoint )
        
        board.x=w*0.5--+236*0.5
        board.y=h*0.5+10--+146*0.5
	loser_window:insert (board)
--[[]]--


        local onSimulator = system.getInfo( "environment" ) == "simulator"
        local platformVersion = system.getInfo( "platformVersion" )
        local olderVersion = tonumber(string.sub( platformVersion, 1, 1 )) < 4
        local fontName = "Grinched"
        local fontSize = 50

        -- if on older device (and not on simulator) ...
       
        --if not onSimulator and olderVersion then
        --    if string.sub( platformVersion, 1, 3 ) ~= "3.2" then
        --        fontName = "Helvetica"
        --        fontSize = 48
        --    end
        --end
 --[[]]--
        
        local yOffset=60;
        local yOffset2=20;

        local myText = display.newText( "Try Again", 0, 0, "Grinched", 48 )
        
        myText.x=w*0.5
        myText.y=2+yOffset;

        myText:setTextColor(20,0,0)
        loser_window:insert (myText) 

        local myText2 = display.newText( "Try Again", 0, 0, "Grinched", 48 )
        myText2.x=w*0.5
        myText2.y=70
        myText2:setTextColor(255,10,0)
        myText2.alpha=0.5
        
        loser_window:insert (myText2) 
        
        
        -- fade object to completely transparent and move the object as well
        AllTransition[#AllTransition+1]=transition.to( loser_window, { time=300, alpha=1.0, y=0+yOffset2 } )
        AllTransition[#AllTransition+1]=transition.to( loser_window, {delay=300, time=100,  y=20+yOffset2 } )
        AllTransition[#AllTransition+1]=transition.to( loser_window, {delay=400, time=100,  y=-10+yOffset2} )
        AllTransition[#AllTransition+1]=transition.to( loser_window, {delay=500, time=100,  y=0+yOffset2} )

        local tStep=100
        local startTime=300
        AllTransition[#AllTransition+1]=transition.to( myText2, {delay=startTime, time=tStep,  x=w*0.5, y=yOffset+1 } )
        AllTransition[#AllTransition+1]=transition.to( myText2, {delay=startTime+tStep*1, time=tStep,  x=w*0.5+1, y=yOffset+1 } )
        AllTransition[#AllTransition+1]=transition.to( myText2, {delay=startTime+tStep*2, time=tStep, x=w*0.5+1, y=yOffset-1 } )
        AllTransition[#AllTransition+1]=transition.to( myText2, {delay=startTime+tStep*3, time=tStep, x=w*0.5-1, y=yOffset-1 } )
        AllTransition[#AllTransition+1]=transition.to( myText2, {delay=startTime+tStep*4, time=tStep, x=w*0.5-1, y=yOffset } )
        AllTransition[#AllTransition+1]=transition.to( myText2, {delay=startTime+tStep*5, time=tStep, x=w*0.5, y=yOffset-4 } )
        AllTransition[#AllTransition+1]=transition.to( myText2, {delay=startTime+tStep*6, time=tStep, alpha=1.0 } )

 
end

function createButtons(self)

    local c=200-25
    local y=240--+50

    ButtonMenu = widget.newButton{
        left=c-40,top=y,
	defaultFile = "src/images/buttons/button_menu.png",
	overFile = "src/images/buttons/button_hover_menu.png",
	onRelease =Menu,
        width=50,
        height=50
    }
    loser_window:insert (ButtonMenu)
    

    ButtonReplay = widget.newButton{
        left=c+40,top=y,
	defaultFile = "src/images/buttons/button_replay.png",
	overFile = "src/images/buttons/button_hover_replay.png",
	onRelease =Replay,
	width=50,
        height=50
    }
    loser_window:insert (ButtonReplay)
  
    
end



function DoReplay(self)
    CancelAllTransition()
    cancelTimers()
    --if (coverDesk~=nil and coverDesk.x~=nil ) then
    --if coverDesk then
        display.remove(coverDesk)
        coverDesk=nil
    --end
    
    --if coverDesk2 then
        display.remove(coverDesk2)
        coverDesk2=nil
    --end
    
    --display.remove(ButtonReset)
    --ButtonReset=nil
    
    --display.remove(ButtonMenu)
    --ButtonMenu=nil
    
    --if ButtonNext then
      --  display.remove(ButtonNext)
--        ButtonNext=nil
  --  end
    display.remove(loser_window)
    loser_window=nil

    thegame:Replay(true)
end

local function ReplayEvent()
        
        print ("replay Level");
        display.remove(ButtonReplay)
        ButtonReplay=nil
    
        display.remove(ButtonMenu)
        ButtonMenu=nil
    
        coverDesk2 = display.newRect(0, 0,display.contentWidth*2,display.contentHeight*2)
	coverDesk2:setFillColor(0,0,0, 250)
        coverDesk2.anchorY=0;
--        coverDesk2:set ReferencePoint( display.TopCenterReferencePoint)
        coverDesk2.x=display.contentWidth*0.5
        coverDesk2.y=0
        coverDesk2.alpha=0
        AllTransition[#AllTransition+1]=transition.to( coverDesk2, { time=200, alpha=0.9 } )
        timer.performWithDelay(200,DoReplay,1)
        
end

function Replay(event)
    if event.phase == "ended" then
        Runtime:removeEventListener( "key", onKeyEvent )
        ReplayEvent()
    end
end

local function doMenu()
        Loading = display.newImageRect( "src/images/misc/loading.png",122,48)
        --ReferencePointFixed
    --Loading:set ReferencePoint(display.CenterCenterReferencePoint);
    Loading.x=display.contentWidth*0.5
    Loading.y=display.contentHeight*0.5
    
        CancelAllTransition()
        cancelTimers()
        
        advertising:HideAd();
        display.remove(coverDesk)
        coverDesk=nil
        display.remove(ButtonReplay)
        ButtonReplay=nil
        display.remove(ButtonMenu)
        ButtonMenu=nil
    
        if ButtonNext then
            display.remove(ButtonNext)
            ButtonNext=nil
        end
        display.remove(loser_window)
        loser_window=nil
        mainmenu:OpenMainMenu()
        display.remove(Loading)
        Loading=nil
end

function Menu(event)
    if event.phase == "ended" then
        Runtime:removeEventListener( "key", onKeyEvent )
        doMenu()
   end
end

function onKeyEvent( event )
    local keyName = event.keyName;
    if (event.phase == "up" and (keyName=="back" or keyName=="menu")) then
            Runtime:removeEventListener( "key", onKeyEvent )
            
            if keyName=="menu" then
                doMenu()
            else
                ReplayEvent()
            end
            return true;
    end
    return false;
end

function Lost(self,formImage)--,task_strings, TaskItemCount,NumberOfTasks, Answer)
    advertising:HideAd()
    
    --local l=thegame.GameSlots[thegame.CurrentSlot.index]
    mousecharacter:removeMouse()
    
    local index=thegame.CurrentSlot.index;
    thegame:setCurrentSlot(index);
    thegame.CurrentSlot.RestartLevel=true
    
    
    --thegame.CurrentSlot=l;
    
    
    Runtime:removeEventListener( "key", onKeyEvent_Main )
    if(thegame.BackGroundMusicChannel~=-1) then
        print ("Stop bg music");
        audio.stop(thegame.BackGroundMusicChannel)
        print ("Bg music stopped");
    end

    buttons:removeAllButtons()
    DisableGame()
    DrawLoserWindow(formImage)
    --DrawTaskResults(task_strings, TaskItemCount,NumberOfTasks, Answer)
    
    createButtons()
    
    
    
    --add the runtime event listener
    if system.getInfo( "platformName" ) == "Android" then  
        Runtime:addEventListener( "key", onKeyEvent )
    end
    
    advertising:ShowAd()
end
