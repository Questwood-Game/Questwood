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

local coverDesk=nil
local coverDesk2=nil
local coverDesk3=nil
local winner_window=nil
local Loading=nil
local Timers={}

local AllTransition={}

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


local function DisableGame(self)
    buttons.isGamePlaying=false;
    buttons.physics_paused=true
    physics.pause()

end


function DrawWinnerWindow(self)


        coverDesk = display.newRect(0, 0,display.contentWidth*2,display.contentHeight*2)
	coverDesk:setFillColor(0,0,0, 250)
        --coverDesk:set ReferencePoint( display.CenterCenterReferencePoint)
        coverDesk.x=display.contentWidth*0.5
        coverDesk.y=display.contentHeight*0.5--0
        coverDesk.alpha=0

        AllTransition[#AllTransition+1]=transition.to( coverDesk, { time=500, alpha=0.8 } )
                    
        local w=400
        local h=300
                        
	winner_window = display.newGroup();

        winner_window.width= w
        winner_window.height= h
        
	winner_window.x =display.contentWidth*0.5-200
	winner_window.y =0---300-- 0-winner_window.height
        winner_window.alpha=1
        

        

        
        local board = display.newImageRect("src/images/stages/win.png",236,146)
        --board:set ReferencePoint(display.CenterCenterReferencePoint )
        board.x=w*0.5--+236*0.5
        board.y=h*0.5+10--+146*0.5
	winner_window:insert (board)


        --local onSimulator = system.getInfo( "environment" ) == "simulator"
        --local platformVersion = system.getInfo( "platformVersion" )
        --local olderVersion = tonumber(string.sub( platformVersion, 1, 1 )) < 4
        local yOffset=60
        local yOffset2=17;
        local textString="Level "..string.format("%i", (thegame.CurrentSlot.CurrentLevel-1)).." Completed!"

        local myText = display.newText(textString, 0, 0, "Colophon DBZ", 36 )
        
        myText.x=w*0.5
        myText.y=yOffset-2

        myText:setTextColor(20,0,0)
        winner_window:insert (myText) 
        
        local fontName;
        --if system.getInfo( "platformName" ) == "iPhone OS" then
          --  fontName=native.systemFont;
        --else
            fontName="Colophon DBZ";
        --end

        local myText2 = display.newText( textString, 0, 0, fontName, 36 )
        myText2.x=w*0.5
        myText2.y=yOffset
        myText2:setTextColor(255,255,0)
        myText2.alpha=0.5
        
        winner_window:insert (myText2) 
        
        
        -- fade object to completely transparent and move the object as well
        AllTransition[#AllTransition+1]=transition.to( winner_window, { time=300, y=0+yOffset2 } )
        AllTransition[#AllTransition+1]=transition.to( winner_window, {delay=300, time=100, y=20+yOffset2 } )
        AllTransition[#AllTransition+1]=transition.to( winner_window, {delay=400, time=100, y=-10+yOffset2 } )
        AllTransition[#AllTransition+1]=transition.to( winner_window, {delay=500, time=100, y=0+yOffset2 } )

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
    local y=240---25

    ButtonMenu = widget.newButton{
        left=c-30,top=y,
	defaultFile = "src/images/buttons/button_menu.png",
	overFile = "src/images/buttons/button_hover_menu.png",
	onRelease =Menu,
        width=50,
        height=50
    }
    winner_window:insert (ButtonMenu)
    
    --ButtonMenu.x =c-ButtonMenu.width*1.5
    --ButtonMenu.y =y
--[[
    ButtonReplay = widget.newButton{
        left=c,top=y,
	defaultFile = "src/images/buttons/button_replay.png",
	overFile = "src/images/buttons/button_replay.png",
	onRelease =Replay,
	width=50,
        height=50
    }
    winner_window:insert (ButtonReplay)

    ]]
        ButtonNext = widget.newButton{
            left=c+30,top=y,
            defaultFile = "src/images/buttons/button_next.png",
            overFile = "src/images/buttons/button_hover_next.png",
            onRelease =Next,
            width=50,
            height=50
        }
        winner_window:insert (ButtonNext)
    
end



function DoReplay(self)
    CancelAllTransition()
    
    cancelTimers()
    
    advertising:HideAd();
    --if (coverDesk~=nil and coverDesk.x~=nil ) then
    --if coverDesk then
        display.remove(coverDesk)
        coverDesk=nil
    --end
    
    --if coverDesk2 then
        display.remove(coverDesk2)
        coverDesk2=nil
    --end
    
    display.remove(ButtonReset)
    ButtonReset=nil
    
    display.remove(ButtonMenu)
    ButtonMenu=nil
    
    --if ButtonNext then
        display.remove(ButtonNext)
        ButtonNext=nil
    --end
    
    display.remove(winner_window)
    winner_window=nil
    

    thegame:Replay(true)
    
    display.remove(Loading)
    Loading=nil
end

function DoNext(self)
    cancelTimers()
    CancelAllTransition()
    
    advertising:HideAd();
    
    
    
    --local userstate = ice:loadBox( "userstate" )
    --userstate:store( "currentlevel", thegame.CurrentLevel )
    --userstate:save()

    display.remove(coverDesk)
    coverDesk=nil
    
    display.remove(coverDesk3)
    coverDesk3=nil
    
    display.remove(ButtonReset)
    ButtonReset=nil
    
    display.remove(ButtonMenu)
    ButtonMenu=nil
    
    if ButtonNext then
        display.remove(ButtonNext)
        ButtonNext=nil
    end
    
    display.remove(winner_window)
    winner_window=nil


    if(thegame.CurrentSlot.CurrentLevel<=levels.NumberOfLevels) then
        thegame:Replay(true)
    else
        theendform.TheEnd()
    end
    
    display.remove(Loading)
    Loading=nil
end
function Next(event)
   if event.phase == "ended" then
        Runtime:removeEventListener( "key", onKeyEvent )
        
        coverDesk3 = display.newRect(0, 0,display.contentWidth*2,display.contentHeight*2)
	coverDesk3:setFillColor(0,0,0, 250)
        coverDesk3.anchorY=0;
        --coverDesk3:set ReferencePoint( display.TopCenterReferencePoint)
        coverDesk3.x=display.contentWidth*0.5
        coverDesk3.y=0
        coverDesk3.alpha=0
        AllTransition[#AllTransition+1]=transition.to( coverDesk3, { time=200, alpha=0.9 } )
        Timers[#Timers+1]=timer.performWithDelay(200,DoNext,1)
        
  
                
   end
end

local function doMenu()
        Loading = display.newImageRect( "src/images/misc/loading.png",122,48)
    --Loading:set ReferencePoint(display.CenterCenterReferencePoint);
    Loading.x=display.contentWidth*0.5
    Loading.y=display.contentHeight*0.5
        CancelAllTransition()
        cancelTimers()
        
        advertising:HideAd();
        
        display.remove(coverDesk)
        coverDesk=nil
    
        display.remove(ButtonReset)
        ButtonReset=nil
        display.remove(ButtonMenu)
        ButtonMenu=nil
    
        if ButtonNext then
            display.remove(ButtonNext)
            ButtonNext=nil
        end
        display.remove(winner_window)
        winner_window=nil
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


function Won(self)
    advertising:HideAd()
    mousecharacter:removeMouse()
    thegame.CurrentSlot.CurrentLevel=thegame.CurrentSlot.CurrentLevel+1
    thegame.CurrentSlot.Energy=800;
    thegame.CurrentSlot.RestartLevel=true;
    thegame:SaveCurrentSlot();
    
   
    Runtime:removeEventListener( "key", onKeyEvent_Main )   
    if(thegame.BackGroundMusicChannel~=-1) then
        audio.stop(thegame.BackGroundMusicChannel)
    end

    buttons:removeAllButtons()
    DisableGame()
    DrawWinnerWindow()
    
    createButtons()
    
    advertising:ShowAd()
    
    --add the runtime event listener
    if system.getInfo( "platformName" ) == "Android" then  
        Runtime:addEventListener( "key", onKeyEvent )
    end
    --local toDo=function()
      --  world:addCoins(10,170,225,winner_window)
    --end
    --Timers[#Timers+1]=timer.performWithDelay(2000,toDo,1)
    
    advertising:ShowAd()
end
