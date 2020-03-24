
-- Demonstrates sprite sheet animations, with different frame rates
-- 
-- Version: 1.0
-- 
-- Sample code is MIT licensed, see http://www.coronalabs.com/links/code/license
-- Copyright (C) 2010 Corona Labs Inc. All Rights Reserved.



system.activate( "multitouch" )
widget = require( "widget" )

local physics = require("physics")
physics.start()
local LastOrientation=0;
      
local isDebug=false;




if (isDebug) then
    physics.setDrawMode( 'debug' );
end

display.setStatusBar( display.HiddenStatusBar );


--INCLUDES
require( "ice" );


--local sprite = require( "sprite" );
local movieclip = require("movieclip");
local background = require( "background" );
local enemy = require( "enemy" );
local world = require( "world" );
local levels = require( "levels" );
local loadsounds = require( "loadsounds" );
local advertising = require( "advertising" );
local ui = require( "ui" );
local cMessageBox = require( "cMessageBox" );


local sprite_collection = require( "sprite_collection" );
--local movements = require "movements"
--      character = require "character"

local bag = require "bag";
local storehouse = require "storehouse";

--local usercharacter = require "usercharacter"
local mousecharacter = require "mousecharacter";


--local saveload = require( "saveload" )
local buttons = require( "buttons" );
local thegame = require( "thegame" );

local winform = require( "winform" );
local loseform = require( "loseform" );
local theendform = require( "theendform" );

local mainmenu = require( "mainmenu" );
local settingsform = require( "settingsform" );
local helpform = require( "helpform" );


local googlePayLicense="MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAhXlZ9ueEreJiZwLnooxkU3z/JloM2JmDKZqndL58UTpcje+nh5OIABuZoa+zIq1dAhQfL9TXbnapXAp2XDQsclMdxS60oDovyRX9tNa3+DmluByLtbzCllcD6YGfV4o69r1q51cgjZZBxKDaS5rcq3xsya0l5/R5K4Tg/Kiazq3Fca4A67tjLH3bH3igJe6l+/+9jbpFq5N5iY8kLnj6SvQXb6KnkcrDt8Zl1FxYoYcvtmKav71GZ6P0JT7x6cB0PX60McbpeJs9QAXMmThOLYVlT3V24eU6lIfFbXdojYNZX8XVtbfRPueh2XV8Mg3IMpc9QWcDyhN8ZrmYCiEaVQIDAQAB"
-- -------------------------- Google’s New Licensing Process
--[[
local licensing = require( "licensing" )
licensing.init( "google" )

local function licensingListener( event )

   local verified = event.isVerified
   if not event.isVerified then
      --failed verify app from the play store, we print a message
      print( "Pirates: Walk the Plank!!!" )
      native.requestExit()  --assuming this is how we handle pirates
   end
end

licensing.verify( licensingListener )
]]--
-- -------------------------- end of Google’s New Licensing Process
    
local userstate = ice:loadBox( "userstate" )


loadsounds.PlaySound=userstate:retrieve( "playsound" )
loadsounds.PlayMusic=userstate:retrieve( "playmusic" )
if loadsounds.PlaySound==nil then
    loadsounds.PlaySound=true
    loadsounds.PlayMusic=true
    
    userstate:store( "playsound", true )
    userstate:store( "playmusic", true )

    userstate:save()
end

buttons.physics_paused=true

sprite_collection:AddSprites()

-- Load Sounds
loadsounds:loadSounds();
advertising:PrepareAds();


if (isDebug==false) then   
    mainmenu:OpenMainMenu();
end



local function moveCamera()
    mousecharacter:MoveCharacter()
    
    world:moveCamera();
end

function onKeyEvent_Main( event )
    local keyName = event.keyName;
    if (event.phase == "up" and (keyName=="back" or keyName=="menu")) then

            Runtime:removeEventListener( "key", onKeyEvent_Main )
            
            if keyName=="menu" then
                buttons:MenuEvent();
            else
                --buttons:MenuEvent();
                buttons:QuitDialog();
            end
        return true;
    else
        return false;
    end
    
end

local function is3x4screen()
    if(display.pixelHeight==1024 and display.pixelWidth==768) then return true; end;
    if(display.pixelHeight==2048 and display.pixelWidth==1536) then return true; end;
    return false;
end

local yo=0;
if(is3x4screen()) then
    yo=20;
end

if advertising.ShowAdvertising then
    --thegame.InfoBox.line1={357-60,69-yo}
    thegame.InfoBox.line1={0+350,72-yo}
    thegame.InfoBox.line2={0+60,70-yo}
else
    thegame.InfoBox.line1={210,20-yo}
    thegame.InfoBox.line2={120,40-yo}
end




function enableKeyEvent_Main()
    if system.getInfo( "platformName" ) == "Android" then  
        Runtime:addEventListener( "key", onKeyEvent_Main )
    end
end

background:CreateSky()
function LoadLevel(self)
    
    local l=thegame.LoadingShadow
    l.text = ""
    thegame.Loading.text = "Loading.6"
                
                
    system.setIdleTimer(false)
    
    buttons.physics_paused=true
    advertising:HideAd();
    thegame:StopAllPlaying();
    thegame.Loading.text = "Loading.7"
      
    CurrentLevelScores=0
        
    
   

    background_back = display.newGroup();
    background_back.isVisible=false  
    thegame.Loading.text = "Loading.8"
    game = display.newGroup();
    
    game.isVisible=false  
    
    thegame.Loading.text = "Loading.9"

    levels:CreateLevel(thegame.CurrentSlot.CurrentLevel)
    
    
    
    thegame.Loading.text = "Loading.10"
    
    thegame.background_front = display.newGroup();
    thegame.background_front.isVisible=false  
    
    thegame.background_veryfront = display.newGroup();
    thegame.background_veryfront.isVisible=false  
    
    thegame.Loading.text = "Loading.11"
    --local myText=display.newText("Load step 1",0,0,native.systemFont,20);myText.x=100;myText.y=30;myText:setTextColor(255,0,0);--game:insert (myText);
    
    levels:AddFronBackground();
    
    --local myText=display.newText("Load step 2",0,0,native.systemFont,20);myText.x=100;myText.y=50;myText:setTextColor(255,0,0);--game:insert (myText);
    physics.start()
    thegame.Loading.text = "Loading.12"
    --local myText=display.newText("Load step 3",0,0,native.systemFont,20);myText.x=100;myText.y=70;myText:setTextColor(255,0,0);--game:insert (myText);
    
    world:SetWalls()


    
    game.x = display.contentWidth*0.5---300---300
    game.y = 0---300  
    
    thegame.background_back.x = display.contentWidth*0.5-300
    thegame.background_back.y = 0  
    
    thegame.background_front.x = display.contentWidth*0.5-300
    thegame.background_front.y = 0
    thegame.Loading.text = "Loading.14"
    --local myText=display.newText("Load step 7",0,0,native.systemFont,20);myText.x=100;myText.y=150;myText:setTextColor(255,0,0);--game:insert (myText);
    
    --usercharacter:drawCharacter(thegame.UserPositionX,thegame.UserPositionY)
    --local myText=display.newText("Load step 8",0,0,native.systemFont,20);myText.x=100;myText.y=170;myText:setTextColor(255,0,0);--game:insert (myText);
    
    --world:SetBackground(1)
    thegame.Loading.text = "Loading.15"
    
    
    --local myText=display.newText("Load step 10",0,0,native.systemFont,20);myText.x=100;myText.y=210;myText:setTextColor(255,0,0);--game:insert (myText);
    thegame.Loading.text = "Loading.16"
    thegame:setSkyDropListener()
    
    --local myText=display.newText("Load step 11",0,0,native.systemFont,20);myText.x=100;myText.y=230;myText:setTextColor(255,0,0);--game:insert (myText);
    thegame.Loading.text = "Loading.17"
    buttons.GameMode=1
    
    
    --if(mousecharacter.wheel~=nil and mousecharacter.wheel.x~=nil) then
      --  WatchScreenX=math.floor(mousecharacter.wheel.x)
    --else
      --  WatchScreenX=0
    --end
    thegame.Loading.text = "Loading.18"
    --local myText=display.newText("Load step 12",0,0,native.systemFont,20);myText.x=100;myText.y=250;myText:setTextColor(255,0,0);--game:insert (myText);
    --mousecharacter.ReadyToTurn=false
    
    thegame.CameraSpeed=80
    
    
    
    thegame.Loading.text = "Loading.19"
    --local myText=display.newText("Load step 13",0,0,native.systemFont,20);myText.x=100;myText.y=250;myText:setTextColor(255,0,0);
    if (loadsounds.PlayMusic) then
        
        local background_melody= audio.loadSound(loadsounds.musicThemes[levels.MusicTheme])--"src/music/sounds-toy-melody.ogg")
        local availableChannel = audio.findFreeChannel()
        audio.setVolume( 0.2, { channel=availableChannel } )
        audio.play( background_melody, { channel=availableChannel,loops=-1 } )
        thegame.BackGroundMusicChannel=availableChannel
    else
            thegame.BackGroundMusicChannel=-1
    end
    thegame.Loading.text = "Loading.20"

    buttons.physics_paused=false
      
    local txt="Level "..string.format("%i", thegame.CurrentSlot.CurrentLevel)
    
    local fontName="Colophon DBZ";
   
    
    local myText = display.newText(txt, 0, 0, fontName,24 )
    myText.x=thegame.InfoBox.line1[1]+130
    myText.y=thegame.InfoBox.line1[2]
    myText:setTextColor(0,0,0)
    thegame.background_front:insert (myText) 
    --thegame.Loading.text = "Loading.21"
    --local myText=display.newText("Load step 16",0,0,native.systemFont,20);myText.x=300;myText.y=30;myText:setTextColor(255,0,0);
    local myText2 = display.newText(txt, 0, 0, fontName,24 )
    myText2.x=myText.x-1
    myText2.y=myText.y-1
    myText2:setTextColor(255,234,0)
    thegame.background_front:insert (myText2) 

        
    
        
    
    background.sky.isVisible=true
    thegame.background_back.isVisible=true
    game.isVisible=true
    thegame.background_front.isVisible=true
    thegame.Loading.text = "Loading.22"
    --local myText=display.newText("Load step 17",0,0,native.systemFont,20);myText.x=300;myText.y=50;myText:setTextColor(255,0,0);
    thegame.background_veryfront.isVisible=true
    
    
    world:PrepareCoins(thegame.InfoBox.line1[1],thegame.InfoBox.line1[2])
    world:updateCoinCounter(thegame.InfoBox.line1[1],thegame.InfoBox.line1[2],true)
    

    
    
    --if levels.ShowAds then
        advertising:ShowAd("text")
    --end
    
    local toDo=function()
        buttons:createGameButtons()
    end
    timer.performWithDelay(500,toDo,1)
    thegame.Loading.text = "Loading.23"
    buttons.isGamePlaying=true
    
    if system.getInfo( "platformName" ) == "Android" then  
        Runtime:addEventListener( "key", onKeyEvent_Main )
    end
    
    Runtime:addEventListener( "enterFrame", moveCamera )
    
    thegame.Loading.text = "Loading.24"
    --collectgarbage()
    --print( "MemUsage: " .. collectgarbage("count") )
    --local textMem = system.getInfo( "textureMemoryUsed" ) / 1000000
    --print( "TexMem:   " .. textMem )


    
    
end








function remove_enterFrameListener(self)
    Runtime:removeEventListener( "enterFrame", moveCamera )
end

--if isDebug then
--    LoadLevel()
--end


function DoSystemEvents(event)
    
    --if system.getInfo( "environment" ) ~= "simulator" then
    --end
    
    
    if event.type=="applicationSuspend" then
            --os.exit();
            
            print ("Suspend");
            if(buttons.isGamePlaying) then
                print ("Pause Game");
                buttons:PauseGame(false);
            end
    end
    if event.type == "applicationExit" then

        --buttons:QuitDialog()
    end

end


Runtime:addEventListener( "system", DoSystemEvents )



--[[
local myText2 = display.newText( system.orientation, 0, 0, native.systemFont, 30)
            myText2.x=250
            myText2.y=150
            myText2:setTextColor(0,0,255)
            --game:insert (myText2) 

--]]


--if(system.orientation=="landscapeLeft") then
  --  LastOrientation=-1; 
--else
  --  LastOrientation=1;
--end                


--if (isDebug) then
    --thegame.CurrentLevel=1;
  -- thegame:Replay(MustLoadLevel)
--end

