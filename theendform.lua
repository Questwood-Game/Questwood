--
-- Project: theendform.lua
-- Description: 
--
-- Version: 1.0
-- Managed with http://CoronaProjectManager.com
--
-- Copyright 2012 . All Rights Reserved.
-- 
module(..., package.seeall)

local FullVersionURL="samsungapps://ProductDetail/com.madmousegame.mousemath"
--local FullVersionURL="http://www.amazon.com/gp/product/B00CHTGFMY"
--local FullVersionURL="http://www.amazon.com/gp/mas/dl/product/B00CHTGFMY" -- not sure
--local FullVersionURL="http://slideme.org/application/mouse-math"
--local FullVersionURL="https://play.google.com/store/apps/details?id=com.madmousegame.mousemath" -- for browser
--local FullVersionURL="market://details?id=com.madmousegame.mousemath"

local coverDesk=nil
local theend_window=nil

local AllTransition={}

local function CancelAllTransition()
    for i=1, #AllTransition  do

        transition.cancel(AllTransition[i])
        AllTransition[i]=nil

    end
    i=nil
    AllTransition={}
end

function DrawTheendWindow(self)
   

        coverDesk = display.newRect(0, 0,display.contentWidth*2,display.contentHeight*2)
	coverDesk:setFillColor(0,0,0, 250)
        --coverDesk:set ReferencePoint( display.CenterCenterReferencePoint)
        coverDesk.x=display.contentWidth*0.5
        coverDesk.y=display.contentHeight*0.5--0
        coverDesk.alpha=0

        AllTransition[#AllTransition+1]=transition.to( coverDesk, { time=500, alpha=0.8 } )
                    
        local w=400
        local h=300
                        
	theend_window = display.newGroup();

        theend_window.width= w
        theend_window.height= h
        
	theend_window.x =display.contentWidth*0.5-200
	theend_window.y =0---300-- 0-theend_window.height
        theend_window.alpha=1
        

        

        
        local board = display.newImageRect("src/images/stages/theend.png",236,146)
        --board:set ReferencePoint( display.CenterCenterReferencePoint )
        board.x=w*0.5--+236*0.5
        board.y=h*0.5+10--+146*0.5
	theend_window:insert (board)


        --local onSimulator = system.getInfo( "environment" ) == "simulator"
        --local platformVersion = system.getInfo( "platformVersion" )
        --local olderVersion = tonumber(string.sub( platformVersion, 1, 1 )) < 4
        local yOffset=65
        local yOffset2=15;
        local textString="Congratulations!"

        local myText = display.newText(textString, 0, 0, "Colophon DBZ", 36 )
        
        myText.x=w*0.5
        myText.y=yOffset-2

        myText:setTextColor(20,0,0)
        theend_window:insert (myText) 
        
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
        
        theend_window:insert (myText2) 
        
        
        -- fade object to completely transparent and move the object as well
        AllTransition[#AllTransition+1]=transition.to( theend_window, { time=300, y=0+yOffset2 } )
        AllTransition[#AllTransition+1]=transition.to( theend_window, {delay=300, time=100, y=20+yOffset2 } )
        AllTransition[#AllTransition+1]=transition.to( theend_window, {delay=400, time=100, y=-10+yOffset2 } )
        AllTransition[#AllTransition+1]=transition.to( theend_window, {delay=500, time=100, y=0+yOffset2 } )

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
function DrawTheendWindow_old(self)


        coverDesk = display.newRect(0, 0,display.contentWidth*2,display.contentHeight*2)
	coverDesk:setFillColor(0,0,0, 250)
        --coverDesk:set ReferencePoint( display.CenterCenterReferencePoint)
        coverDesk.x=display.contentWidth*0.5
        coverDesk.y=display.contentHeight*0.5--0
        coverDesk.alpha=0

        AllTransition[#AllTransition+1]=transition.to( coverDesk, { time=500, alpha=0.8 } )
                    
                        
	theend_window = display.newGroup();
        local w=400
        local h=200
        theend_window.width= 400
        theend_window.height= 300
        
	theend_window.x =display.contentWidth*0.5-200
	theend_window.y =-300-- 0-theend_window.height
        theend_window.alpha=1
        


        
        local board = display.newImageRect( "src/images/stages/stage.jpg",400,350 )
        
        board.anchorX=0;
        board.anchorY=0;
        --board:set ReferencePoint( display.TopLeftReferencePoint )
        board.x=0
        board.y=0
	theend_window:insert (board)

        --local onSimulator = system.getInfo( "environment" ) == "simulator"
        --local platformVersion = system.getInfo( "platformVersion" )
        --local olderVersion = tonumber(string.sub( platformVersion, 1, 1 )) < 4
        local fontName = "Grinched"
        local fontSize = 50


        local myText = display.newText( "Congratulations!", 0, 0, fontName, fontSize )
        
        myText.x=theend_window.width*0.5
        myText.y=68

        myText:setTextColor(20,0,0)
        theend_window:insert (myText) 

        local myText2 = display.newText( "Congratulations!", 0, 0, fontName, fontSize )
        myText2.x=theend_window.width*0.5
        myText2.y=70
        myText2:setTextColor(255,200,0)
        myText2.alpha=0.5
        
        theend_window:insert (myText2) 
        
        
        -- fade object to completely transparent and move the object as well
        AllTransition[#AllTransition+1]=transition.to( theend_window, { time=300, alpha=1.0, x=theend_window.x, y=0 } )
        AllTransition[#AllTransition+1]=transition.to( theend_window, {delay=300, time=100, alpha=1.0, x=theend_window.x, y=20 } )
        AllTransition[#AllTransition+1]=transition.to( theend_window, {delay=400, time=100, alpha=1.0, x=theend_window.x, y=-10 } )
        AllTransition[#AllTransition+1]=transition.to( theend_window, {delay=500, time=100, alpha=1.0, x=theend_window.x, y=0 } )

        local tStep=100
        local startTime=300
        AllTransition[#AllTransition+1]=transition.to( myText2, {delay=startTime, time=tStep,  x=theend_window.width*0.5, y=71 } )
        AllTransition[#AllTransition+1]=transition.to( myText2, {delay=startTime+tStep*1, time=tStep,  x=theend_window.width*0.5+1, y=71 } )
        AllTransition[#AllTransition+1]=transition.to( myText2, {delay=startTime+tStep*2, time=tStep, x=theend_window.width*0.5+1, y=69 } )
        AllTransition[#AllTransition+1]=transition.to( myText2, {delay=startTime+tStep*3, time=tStep, x=theend_window.width*0.5-1, y=69 } )
        AllTransition[#AllTransition+1]=transition.to( myText2, {delay=startTime+tStep*4, time=tStep, x=theend_window.width*0.5-1, y=70 } )
        AllTransition[#AllTransition+1]=transition.to( myText2, {delay=startTime+tStep*5, time=tStep, x=theend_window.width*0.5, y=66 } )
        AllTransition[#AllTransition+1]=transition.to( myText2, {delay=startTime+tStep*6, time=tStep, alpha=1.0 } )

        
        if levels.NumberOfLevels==8 then 
            local myText2 = display.newText( "Get All 24 Levels", 0, 0, fontName, 28 )
            myText2:setTextColor(240,0,0)
            myText2.x=theend_window.width*0.5
            myText2.y=130
            
            myText2.alpha=1
        
        theend_window:insert (myText2) 
        else
            local myText2 = display.newText( "You did it!", 0, 0, fontName, 26 )
            myText2:setTextColor(0,100,0)
            myText2.x=theend_window.width*0.5
            myText2.y=120
            
            myText2.alpha=1
        
        theend_window:insert (myText2) 
        end
            
end


function createButtons(self)

    local c=200-60
    local y=270-20-10

    ButtonWebsite = widget.newButton{
        left=c,top=y,
	defaultFile = "src/images/buttons/button_info.png",
	overFile = "src/images/buttons/button_hover_info.png",
	onRelease =Website,
        width=50,
        height=50
    }
    theend_window:insert (ButtonWebsite)

    ButtonMenu = widget.newButton{
        left=c+70,top=y,
	defaultFile = "src/images/buttons/button_menu.png",
	overFile = "src/images/buttons/button_hover_menu.png",
	onRelease =Menu,
        width=50,
        height=50
    }
    theend_window:insert (ButtonMenu)

    
end

function Website(event)
    if event.phase == "ended" then
        CancelAllTransition()
        
        --if levels.NumberOfLevels==8 then 
          --  system.openURL( FullVersionURL)
            
        --else
            system.openURL( "http://questwoodgame.com/congratulations" )
        --end
        
        
    end
end

local function doMenu()
        CancelAllTransition()
        advertising:HideAd();
        display.remove(coverDesk)
        coverDesk=nil
        display.remove(ButtonWebsite)
        ButtonWebsite=nil
        display.remove(ButtonMenu)
        ButtonMenu=nil
    
        display.remove(theend_window)
        theend_window=nil
        
        mainmenu:OpenMainMenu() 
end

function Menu(event)
    if event.phase == "ended" then
        doMenu()
   end
end

function onKeyEvent( event )
    local keyName = event.keyName;
    if (event.phase == "up" and (keyName=="back" or keyName=="menu")) then
            Runtime:removeEventListener( "key", onKeyEvent )
            doMenu()
            
            return true;
    end
    return false;
end

function TheEnd(self)
    advertising:HideAd()
    DrawTheendWindow()

    createButtons()
    
    advertising:ShowAd()
    
    --add the runtime event listener
    if system.getInfo( "platformName" ) == "Android" then  
        Runtime:addEventListener( "key", onKeyEvent )
    end
    advertising:ShowAd()
end




