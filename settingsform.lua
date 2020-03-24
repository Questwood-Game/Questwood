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


--local GGData = require( "GGData" )
local c=175
local y=93

local ButtonBack=nil
local ButtonMusic=nil
local ButtonSound=nil


local coverDeskSettings=nil
local settings_window=nil


local AllTransition={}

local function CancelAllTransition()
    for i=1, #AllTransition  do

        transition.cancel(AllTransition[i])
        AllTransition[i]=nil

    end
    i=nil
    AllTransition={}
end


function DoBack(self)
    CancelAllTransition()
    advertising:HideAd();
    
    display.remove(coverDeskSettings)
    coverDeskSettings=nil
    
    display.remove(settings_window)
    settings_window=nil
    
    mainmenu:ShowHideButtons(true);
    
end

function MusicOff(event)
    if event.phase == "ended" then
        display.remove(ButtonMusic)
        ButtonMusic=nil

        loadsounds.PlayMusic=false;
        
        if(thegame.BackGroundMusicChannel~=-1) then
            audio.stop(thegame.BackGroundMusicChannel)
        end
        thegame.BackGroundMusicChannel=-1
    
        --local userstate = GGData:new( "userstate" )
        local userstate = ice:loadBox( "userstate" )
        userstate:store( "playmusic", loadsounds.PlayMusic)
        userstate:save()
        --userstate=nil;
    
        ButtonMusic = widget.newButton{
            id="MusicOffButton",left=c-100,top=y,
            defaultFile = "src/images/buttons/button_music_off.png",
            overFile = "src/images/buttons/button_hover_music_off.png",
            onRelease =MusicOn,
            width=50,
            height=50
        }
        settings_window:insert (ButtonMusic)
    end
end

function MusicOn(event)
    if event.phase == "ended" then
        display.remove(ButtonMusic)
        ButtonMusic=nil

        loadsounds.PlayMusic=true
        if(thegame.BackGroundMusicChannel~=-1) then
            --print ("1");
            audio.stop(thegame.BackGroundMusicChannel)
            --print ("2");
        end
        thegame.BackGroundMusicChannel=-1
    
        --local userstate = GGData:new( "userstate" )
        local userstate = ice:loadBox( "userstate" )
        userstate:store( "playmusic", loadsounds.PlayMusic)
        userstate:save()
        --userstate=nil

        ButtonMusic = widget.newButton{
            left=c-100,top=y,
            defaultFile = "src/images/buttons/button_music_on.png",
            overFile = "src/images/buttons/button_hover_music_on.png",
            onRelease =MusicOff,
            width=50,
            height=50
        }
        settings_window:insert (ButtonMusic)
        
        if(#loadsounds.musicThemes>0) then
        
            local background_melody= audio.loadSound(loadsounds.musicThemes[1])
            local availableChannel = audio.findFreeChannel()
            thegame.BackGroundMusicChannel=availableChannel
    
            audio.setVolume( 0.5, { channel=availableChannel } )
            audio.play( background_melody, { channel=availableChannel,loops=-1 } )

            local myclosure= function() audio.pause(thegame.BackGroundMusicChannel) end
            timer.performWithDelay(2500,myclosure,1)
        end
    
    end
end


function SoundOff(event)
    if event.phase == "ended" then
        display.remove(ButtonSound)
        ButtonSound=nil

        loadsounds.PlaySound=false
    
        local userstate = ice:loadBox( "userstate" )
        userstate:store( "playsound", loadsounds.PlaySound)
        userstate:save()

        ButtonSound = widget.newButton{
            left=c,top=y,
            defaultFile = "src/images/buttons/button_sound_off.png",
            overFile = "src/images/buttons/button_hover_sound_off.png",
            onRelease =SoundOn,
            width=50,
            height=50
        }
        settings_window:insert (ButtonSound)
    end
end

function SoundOn(event)
    if event.phase == "ended" then
        display.remove(ButtonSound)
        ButtonSound=nil

        loadsounds.PlaySound=true
    
        local userstate = ice:loadBox( "userstate" )
        userstate:store( "playsound", loadsounds.PlaySound)
        userstate:save()

        ButtonSound = widget.newButton{
            left=c,top=y,
            defaultFile = "src/images/buttons/button_sound_on.png",
            overFile = "src/images/buttons/button_hover_sound_on.png",
            onRelease =SoundOff,
            width=50,
            height=50
        }
        settings_window:insert (ButtonSound)
                       
        loadsounds:PlayWinSoundsSound();

   end
end

local function BackEvent()
        Runtime:removeEventListener( "key", onKeyEvent )
    
    
        display.remove(ButtonBack)
        ButtonBack=nil
        display.remove(ButtonMusic)
        ButtonMusic=nil
        display.remove(ButtonSound)
        ButtonSound=nil
   
        
        AllTransition[#AllTransition+1]=transition.to( coverDeskSettings, { time=200, alpha=0 } )
        timer.performWithDelay(200,DoBack,1)
end

function Back(event)
    if event.phase == "ended" then
        BackEvent()
    end
        
end
local function BackEvent()
        Runtime:removeEventListener( "key", onKeyEvent )
    
    
        display.remove(ButtonBack)
        ButtonBack=nil
        display.remove(ButtonMusic)
        ButtonMusic=nil
        display.remove(ButtonSound)
        ButtonSound=nil
     
        
        
        AllTransition[#AllTransition+1]=transition.to( coverDeskSettings, { time=200, alpha=0 } )
        timer.performWithDelay(200,DoBack,1)
end


local function is3x4screen()
    if(display.pixelHeight==1024 and display.pixelWidth==768) then return true; end;
    
    if(display.pixelHeight==2048 and display.pixelWidth==1536) then return true; end;
    
    return false;
        
end


local function createButtons(self)
    local yOffset=0
    if is3x4screen() then
        yOffset=20;
    end
--left=c-50,top=y+100,
    ButtonBack = widget.newButton{
        left=2,top=2-yOffset,
            
            defaultFile = "src/images/buttons/button_back.png",
            overFile = "src/images/buttons/button_hover_back.png",
            onRelease =Back,
            width=50,
            height=50
    }
    

    
    ----------------------
    if(loadsounds.PlayMusic) then 
        ButtonMusic = widget.newButton{
            left=c-100,top=y,
            defaultFile = "src/images/buttons/button_music_on.png",
            overFile = "src/images/buttons/button_hover_music_on.png",
            onRelease =MusicOff,
            width=50,
            height=50
        }
        settings_window:insert (ButtonMusic)
        
        
   else
        ButtonMusic = widget.newButton{
            left=c-100,top=y,
            defaultFile = "src/images/buttons/button_music_off.png",
            overFile = "src/images/buttons/button_hover_music_off.png",
            onRelease =MusicOn,
            width=50,
            height=50
        }
        settings_window:insert (ButtonMusic)
        
    end
    ---------------------
 
     if(loadsounds.PlaySound) then 
        ButtonSound = widget.newButton{
            left=c,top=y,
            defaultFile = "src/images/buttons/button_sound_on.png",
            overFile = "src/images/buttons/button_hover_sound_on.png",
            onRelease =SoundOff,
            width=50,
            height=50
        }
        settings_window:insert (ButtonSound)
        
        
   else
        ButtonSound = widget.newButton{
            left=c,top=y,
            defaultFile = "src/images/buttons/button_sound_off.png",
            overFile = "src/images/buttons/button_hover_sound_off.png",
            onRelease =SoundOn,
            width=50,
            height=50
        }
        settings_window:insert (ButtonSound)

    end
    
    
    
   
           
end


local function DrawSettingsWindow(self)
        

        coverDeskSettings = display.newRect(0, 0,display.contentWidth*2,display.contentHeight*2)
	coverDeskSettings:setFillColor(0,0,0, 250)
        --ReferencePointFixed
        --coverDeskSettings:set ReferencePoint( display.CenterCenterReferencePoint)
        coverDeskSettings.x=display.contentWidth*0.5
        coverDeskSettings.y=display.contentHeight*0.5
        coverDeskSettings.alpha=0
        AllTransition[#AllTransition+1]=transition.to( coverDeskSettings, { time=500, alpha=0.8 } )
                    
                        
	settings_window = display.newGroup();

        settings_window.width= 300
        settings_window.height= 232
        
	settings_window.x =display.contentWidth*0.5-150
	settings_window.y =-300-- 0-winner_window.height
        settings_window.alpha=1
        




        
        local board = display.newImageRect( "src/images/stages/form.png",300,232 )
        board.anchorX=0;
        board.anchorY=0;
        --board:set ReferencePoint( display.TopLeftReferencePoint )
        board.x=0
        board.y=0
	settings_window:insert (board)
       
       
       
        createButtons();
        
        
        
        -- fade object to completely transparent and move the object as well
        AllTransition[#AllTransition+1]=transition.to( settings_window, { time=300, alpha=1.0, x=settings_window.x, y=0 } )
        AllTransition[#AllTransition+1]=transition.to( settings_window, {delay=300, time=100, alpha=1.0, x=settings_window.x, y=20 } )
        AllTransition[#AllTransition+1]=transition.to( settings_window, {delay=400, time=100, alpha=1.0, x=settings_window.x, y=-10 } )
        AllTransition[#AllTransition+1]=transition.to( settings_window, {delay=500, time=100, alpha=1.0, x=settings_window.x, y=0 } )


end


function onKeyEvent( event )

    if (event.phase == "up" and event.keyName=="back" ) then
        Runtime:removeEventListener( "key", onKeyEvent )
        BackEvent()
        return true;
    end
    return false;
end


function OpenSettingsForm(self)
    advertising:HideAd()
    --buttons:removeAllButtons()

    DrawSettingsWindow()
    --advertising:ShowAd()
    
    --add the runtime event listener
    if system.getInfo( "platformName" ) == "Android" then  
        Runtime:addEventListener( "key", onKeyEvent )
    end
end


