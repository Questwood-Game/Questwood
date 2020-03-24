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
local gameVersion ="v.1.3.0"
local showExitButton=false;

 -- for further reference
local createSlotButtons=nil;
local SlotTap=nil;
local removeButtons=nil;
local RefreshSlotButtons=nil;
local SlotInfoGroup=nil;
-- etc

local SlotButtons=nil;

local inputBox=nil;
local DeleteTipBox=nil;
local DeleteTipLabels=nil;


isMainMenuOpen=false

local coverDesk=nil
local coverDesk2=nil
local coverDesk_Reset=nil
local mainmenu_window=nil
local AllTransition={}

local function CancelAllTransition()
    for i=1, #AllTransition  do

        transition.cancel(AllTransition[i])
        AllTransition[i]=nil

    end
    i=nil
    AllTransition={}
end


local AllTimers={}
local function RemoveAllTimers()
    --print ("#AllTimers="..#AllTimers)
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

local function is3x4screen()
    if(display.pixelHeight==1024 and display.pixelWidth==768) then return true; end;
    
    if(display.pixelHeight==2048 and display.pixelWidth==1536) then return true; end;
    
    return false;
        
end


local function removeSlotButtons()
            for i=1, 3 do
                display.remove(SlotButtons[i]);
                SlotButtons[i]=nil;
        
                display.remove(SlotInfoGroup[i]);
                SlotInfoGroup[i]=nil;
        
            end
            SlotButtons=nil;   
            SlotInfoGroup=nil;
end

local function DisableGame(self)
    
    buttons.isGamePlaying=false;
    buttons.physics_paused=true
    physics.pause()

end

local function typeVersion()

        local fontName;
        --if system.getInfo( "platformName" ) == "iPhone OS" then
          --  fontName=native.systemFont;
        --else
            fontName="Grinched";
        --end

        local QuitText = display.newText( gameVersion, 0, 0, fontName, 10 )
        
        QuitText.anchorY=0
        --QuitText:set ReferencePoint( display.TopCenterReferencePoint)
        QuitText.x=140
        QuitText.y=116

        QuitText:setTextColor(70,43,3,255)
        mainmenu_window:insert (QuitText)
        
end


local function DrawMainMenuWindow()
        --display.contentHeight=320
        local s3x4=is3x4screen();
        
        coverDesk = display.newRect(0, 0,display.contentWidth*2,display.contentHeight*2);
	coverDesk:setFillColor(0,0,0, 250);
        --ReferencePointFixed
        --coverDesk:set ReferencePoint( display.CenterCenterReferencePoint);
        coverDesk.x=display.contentWidth*0.5;
        coverDesk.y=display.contentHeight*0.5;
        coverDesk.alpha=0;
	--game:insert (coverDesk)
        AllTransition[#AllTransition+1]=transition.to( coverDesk, { time=500, alpha=0.8 } )
                    
                        
	mainmenu_window = display.newGroup();

        local yh=160--192--160
        
        --world.getRealScreenSize();
        --print(display.pixelHeight.."x"..display.pixelWidth)
        
        
        --;;system.getInfo("architectureInfo"))
        --local halfW = display.viewableContentWidth
        --local halfH = display.viewableContentHeight
        --print(halfW)
        
        
        mainmenu_window.width= 600
        mainmenu_window.height=320--384--768/2 --320
        
	mainmenu_window.x =display.contentWidth*0.5---320
	mainmenu_window.y =160--92---300
        mainmenu_window.alpha=0
                             
        local is3x4=""; 
        local h=320
        if s3x4 then
             is3x4="_3x4"; h=384;
        end

        --print("is3x4="..is3x4)
        
        local board_image=""
        if levels.NumberOfLevels==8 then 
            board_image="level_selection_lite.jpg";
        else
            board_image="level_selection"..is3x4..".jpg";
        end
        local board = display.newImageRect( "src/images/levels/"..board_image,600, h)
        
        board.x=0;
        board.y=0;
	mainmenu_window:insert (board);
        
        

        
        -- fade object to completely transparent and move the object as well
        AllTransition[#AllTransition+1]=transition.to( mainmenu_window, { time=300, alpha=1.0 } )
        
end

local function Settings(event)
    if inputBox~=nil then
        return;
    end
    
    if event.phase == "ended" then
        
        --[[]
        dialogCloud = cMessageBox.newMessageBox{
    msgBoxType = "MB_YesNo",
    background ="src/images/stages/dialog.png",
    width = 364,
    height= 232,
    captionText = "Test 1",
    captionSize="18",
    buttonImages=myButtonImages,
    borderSizeX=20,
    borderSizeY=30,
    messageText = msg,
    messageJustify = display.CenterReferencePoint,
    onEvent = onBuyItemDone,
    captionColor = {255,255, 255, 255 },
    messageColor = {255,255, 255, 255 }
    }
    ]]
        
        
        ShowHideButtons(nil,false);
        CancelAllTransition()
        Runtime:removeEventListener( "key", onKeyEvent )
        settingsform:OpenSettingsForm()
        
    end
end

local function Info(event)
    if inputBox~=nil then
        return;
    end
    
    if event.phase == "ended" then
        ShowHideButtons(nil,false);
        CancelAllTransition()
        Runtime:removeEventListener( "key", onKeyEvent )
        helpform:OpenHelpForm()
    end
end


local function textListener( event )

    
    --if event.phase == "began" then
       
    --elseif event.phase == "ended" then

    --else
    if event.phase == "ended" or event.phase == "submitted" then
        
        

        if inputBox~=nil and inputBox.text~=nil and inputBox.text~="" then
            local index=inputBox.index;
            
            local a=inputBox.text;
            local l=string.len(a);
            if l>12 then
                a=string.sub (a,1,12);    
            end
            
            if string.lower(a)=="delete" then
                
                local c=thegame.CurrentSlot;
                local l=thegame.GameSlots[index];
                if c~=nil and l~=nil and c.index==index and c.CurrentLevel==l.CurrentLevel then
                        thegame.CurrentSlot=nil;
                end
                
                thegame.GameSlots[index]=nil;
                thegame:saveGameSlot(index);
                
            elseif inputBox.resetSlot then
                thegame:resetSlot(index,a);
            else
                thegame.GameSlots[index].name=a;
                thegame:saveGameSlot(index);
            end
            
        end
        RefreshSlotButtons()
        
        display.remove(inputBox);
        inputBox=nil;
        
        if(DeleteTipBox~=nil) then
            display.remove(DeleteTipBox);
            DeleteTipBox=nil;
        end
        
        if(DeleteTipLabels~=nil) then
            display.remove(DeleteTipLabels);
            DeleteTipLabels=nil;
        end
        
        

    --elseif event.phase == "editing" then

        --print( event.newCharacters )
        --print( event.oldText )
        --print( event.startPosition )
        --print( event.text )

    end
end






local function doPlayLevel()
    RemoveAllTimers()
    isMainMenuOpen=false
    
    if(coverDesk)then
        display.remove(coverDesk)
        coverDesk=nil
    end
    if(coverDesk2)then
        display.remove(coverDesk2)
        coverDesk2=nil
    end

    
    CancelAllTransition()
    display.remove(mainmenu_window)
    mainmenu_window=nil


    if(thegame.CurrentSlot.CurrentLevel<=levels.NumberOfLevels) then
        thegame:Replay(true)
    else
        theendform.TheEnd()
    end
    
    --display.remove(Loading)
    --Loading=nil
end



local function PlayLevel()
   
        Runtime:removeEventListener( "key", onKeyEvent )
        removeButtons()

        
        coverDesk3 = display.newRect(0, 0,display.contentWidth*2,display.contentHeight*2)
	coverDesk3:setFillColor(0,0,0, 1)
        --ReferencePointFixed
        --coverDesk3:set ReferencePoint( display.CenterCenterReferencePoint)
        coverDesk3.x=display.contentWidth*0.5
        coverDesk3.y=display.contentHeight*0.5
        coverDesk3.alpha=0
        AllTransition[#AllTransition+1]=transition.to( coverDesk3, { time=200, alpha=0.9 } )
       
        AllTimers[#AllTimers+1]=timer.performWithDelay(200,doPlayLevel,1)
        

end


local function DoPlay()
    RemoveAllTimers();
    system.setIdleTimer(false)
    print ("system.setIdleTimer(false)");
    
    isMainMenuOpen=false
    
    if(thegame.BackGroundMusicChannel~=-1) then
        audio.resume(thegame.BackGroundMusicChannel)
    end
    
    
    if coverDesk~=nil then
        display.remove(coverDesk)
        coverDesk=nil
    end
    
    if coverDesk2~=nil then
        display.remove(coverDesk2)
        coverDesk2=nil
    end
    
    removeButtons()
    
    CancelAllTransition()
    display.remove(mainmenu_window)
    mainmenu_window=nil
    
    buttons:createGameButtons()
    

    buttons.physics_paused=false;
    physics.start()
    thegame:setSkyDropListener()
    enableKeyEvent_Main()
    buttons.isGamePlaying=true;
    --if levels.ShowAds then
        advertising:ShowAd()
    --end
    
end


local function Play()

        Runtime:removeEventListener( "key", onKeyEvent )
        
        AllTransition[#AllTransition+1]=transition.to( coverDesk, { time=200, alpha=0 } )
        timer.performWithDelay(200,DoPlay,1)
       
end



local function removeSlotButtonListeners()
    for i=1, 3 do
        SlotButtons[i]:removeEventListener( "touch", SlotTap);
    end
end


local function doEditSlot(index,x,y,resetSlot)
        removeSlotButtonListeners()
        
        
            
            
        
            SlotInfoGroup[index].isVisible=false;
        
            --[[
            if system.getInfo( "environment" ) == "simulator" and 1==1 then
                inputBox = display.newRoundedRect(x, y, 100, 20, 12);
                inputBox:addEventListener( "touch", textListener);
                mainmenu_window:insert (inputBox);
            else
                ]]
                
                inputBox=native.newTextField(x+242, y+161, 100, 20);
                inputBox.anchorX=0;
                inputBox.anchorY=0;
                if(thegame.GameSlots[index]~=nil) then
                    inputBox.text=thegame.GameSlots[index].name;
                else
                    inputBox.text="";
                end
                    
                inputBox.userInput = textListener;
                
                inputBox:addEventListener( "userInput", textListener);
            --end
            
            inputBox.setTextColor = {0,0,0,255};
            inputBox.index=index;
            inputBox.resetSlot=resetSlot;
            
            native.setKeyboardFocus(inputBox)
            
            if(thegame.GameSlots[index]~=nil) then
            
                local dLy=-display.contentHeight*0.5-1;
                if is3x4screen() then
                    dLy=dLy-20;
                end
            
                DeleteTipBox = display.newRect(0, 0,display.contentWidth*1.5,25)
                DeleteTipBox:setFillColor(0,62/255,28/255,1)
                
                DeleteTipBox.anchorY=0;
                --DeleteTipBox:set ReferencePoint( display.TopCenterReferencePoint)
                DeleteTipBox.x=0
                DeleteTipBox.y=dLy-25
                mainmenu_window:insert (DeleteTipBox);
                --DeleteTipBox.alpha=1
            
            
                DeleteTipLabels=display.newText('To delete the Slot type "delete"',0,0,"Basic Comical NC",16);
                DeleteTipLabels.x=0;
                DeleteTipLabels.y=dLy+12-25;
                DeleteTipLabels:setTextColor(1,1,1,1);
                mainmenu_window:insert (DeleteTipLabels);
            
            
            
                AllTransition[#AllTransition+1]=transition.to( DeleteTipBox, {delay=1000, time=500, y=dLy } )
                AllTransition[#AllTransition+1]=transition.to( DeleteTipLabels, {delay=1000, time=500, y=dLy+12 } )

                AllTransition[#AllTransition+1]=transition.to( DeleteTipBox, {delay=10000, time=800, y=dLy-25 } )
                AllTransition[#AllTransition+1]=transition.to( DeleteTipLabels, {delay=10000, time=800, y=dLy+12-25 } )
            
            end
            
end

function RefreshSlotButtons()
    removeSlotButtons();
        
    SlotButtons={}
    SlotInfoGroup={}
    
    local x=-156;
    local y=-110-25;
    
    for i=1, 3 do
                createSlotButtons(x,y);
                y=y+54;
    end
 
end

function SlotTap(event)
    if inputBox==nil then
        --print("event.phase="..event.phase);
    

        if event.phase == "began" then
            thegame:deleteMessage();
            
            local index=event.target.index;
            local EditSlot=function()
                --print ("Timer Fire");
                RemoveAllTimers();
                
                --[[
                if system.getInfo( "environment" ) == "simulator" and 1==1 then
                    
                    local c=thegame.CurrentSlot;
                    local l=thegame.GameSlots[index];
                    if c~=nil and l~=nil and c.index==index and c.CurrentLevel==l.CurrentLevel then
                        thegame.CurrentSlot=nil;
                    end
                    
                    thegame.GameSlots[index]=nil;
                    thegame:saveGameSlot(index);
                    RefreshSlotButtons();
                else
                    ]]
                    
                    doEditSlot(index,event.target.x+20,event.target.y+15,false);
                    
                --end
            end
            
            if(thegame.GameSlots[index]~=nil) then
                RemoveAllTimers();
                --print ("Timer Set");
                AllTimers[#AllTimers+1]=timer.performWithDelay(1000,EditSlot,1)
            else
                doEditSlot(index,event.target.x+20,event.target.y+15,true);
            end
            
        elseif event.phase == "ended" then
            RemoveAllTimers();
            
            local index=event.target.index;
            if(thegame.GameSlots[index]~=nil) then
                local l=thegame.GameSlots[index];
                local c=thegame.CurrentSlot;
                if l.CurrentLevel>levels.NumberOfLevels then
                    thegame:ShowMessage("All levels completed!",3);
                elseif c~=nil and l~=nil and c.index==index then
                    if c.RestartLevel then
                        thegame:setCurrentSlot(index);
                        PlayLevel();
                    else
                        Play();    
                    end
                    
                else
                    thegame:setCurrentSlot(index);
                    PlayLevel();
                end
            else
                --[[
                if system.getInfo( "environment" ) == "simulator" and 1==1 then
                    thegame:resetSlot(index,"New "..index);
                    RefreshSlotButtons();
                else
                 ]]
                    doEditSlot(index,event.target.x+20,event.target.y+15,true);    
                --end
                
            end
        end
    end
end


function createSlotButtons(x,y)
    local index=#SlotInfoGroup+1
    
    
    
    SlotButtons[index] = display.newImageRect( "src/images/buttons/sign_arrow_150x54.png", 150,54);
    
    SlotButtons[index].anchorX=0
    SlotButtons[index].anchorY=0
    --SlotButtons[index]:set ReferencePoint(display.TopLeftReferencePoint);
    SlotButtons[index].x=x;
    SlotButtons[index].y=y;
    SlotButtons[index].index=index;
    SlotButtons[index]:addEventListener( "touch", SlotTap);
        
    SlotInfoGroup[index]= display.newGroup();
    
    SlotInfoGroup[index].anchorX=0;
    SlotInfoGroup[index].anchorY=0;
    --SlotInfoGroup[index]:set ReferencePoint(display.TopLeftReferencePoint);
    SlotInfoGroup[index].x=0;
    SlotInfoGroup[index].y=0;
    --mainmenu_window:insert (SlotInfoGroup[index]);
--[[    
    SlotButtons[index] = widget.newButton{
            id="SettingsButton",left=x,top=y,
            defaultFile = "src/images/buttons/sign_arrow_150x54.png",
            overFile = "src/images/buttons/sign_arrow_150x54.png",
            onRelease =SlotTap,
            onEvent =SlotTap2Edit,
            width=150,
            height=54,
            label = ""
    }
]]
    local c=thegame.CurrentSlot;
    local l=thegame.GameSlots[index];
    if l==nil then
        SlotButtons[index]:setFillColor(250,200,200, 255)
    elseif l.CurrentLevel>levels.NumberOfLevels then
        SlotButtons[index]:setFillColor(250,0,0, 255)
    elseif c~=nil and c.index==index and c.CurrentLevel==l.CurrentLevel then
        SlotButtons[index]:setFillColor(0,250,250, 255)
    end

    mainmenu_window:insert (SlotButtons[index]);
    
    SlotButtons[index].index=index;
    
    thegame:loadGameSlot(index);
    
    local fontName="Grinched";
    local SlotLabel=nil;
    
    if(thegame.GameSlots[index]==nil) then

        SlotLabel = display.newText("Empty Slot", 0, 0, fontName, 16 )
        SlotLabel.y=y+190-13;

    else
        local a=thegame.GameSlots[index];
        if a.name==nil then
            a.name="Slot"
        end
        SlotLabel = display.newText(a.name, 0, 0, fontName, 16 )
        SlotLabel.y=y+187;

    end
            
        
        SlotLabel.anchorY=0
        --SlotLabel:set ReferencePoint( display.TopCenterReferencePoint)
        SlotLabel.x=160;
        
    if c~=nil and l~=nil and c.index==index and c.CurrentLevel==l.CurrentLevel then
    
        SlotLabel:setTextColor(250,255,200,255)
    else
        SlotLabel:setTextColor(70,43,3,255)
    end
        
        SlotInfoGroup[index]:insert (SlotLabel)
        
    if(thegame.GameSlots[index]~=nil) then
        
        local txt="Level: "..string.format("%i", l.CurrentLevel)
        local fontName="Basic Comical NC";
        local myText = display.newText(txt, 0, 0, fontName,12 )
        --ReferencePointFixed
        myText.anchorX=0;
        --myText:set ReferencePoint( display.CenterLeftReferencePoint)
        myText.x=100
        myText.y=y+173
        myText:setTextColor(70,43,3,255)
        SlotInfoGroup[index]:insert (myText) 
    
        local CoinIconShadow = display.newImageRect("src/images/misc/coin.png",16, 16)
        --ReferencePointFixed
        --CoinIconShadow:set ReferencePoint( display.CenterCenterReferencePoint)
        CoinIconShadow:setFillColor(20,0,0, 150);
        CoinIconShadow.x=105+1
        CoinIconShadow.y=y+197+1
        CoinIconShadow.xScale=0.5
        CoinIconShadow.yScale=0.5
        SlotInfoGroup[index]:insert (CoinIconShadow) 
    
        local CoinIcon = display.newImageRect("src/images/misc/coin.png",16, 16)
        --ReferencePointFixed
        --CoinIcon:set ReferencePoint( display.CenterCenterReferencePoint)
        CoinIcon.x=105
        CoinIcon.y=y+197
        CoinIcon.xScale=0.5
        CoinIcon.yScale=0.5
        SlotInfoGroup[index]:insert (CoinIcon) 
    
    
        local txt2=nil
        if c~=nil and l~=nil and c.index==index and c.CurrentLevel==l.CurrentLevel then
            txt2=string.format("%i", c.ScoreCoins)
        else
            txt2=string.format("%i", l.ScoreCoins)
        end
    
        local myCoins = display.newText(txt2, 0, 0, fontName,12 )
        myCoins.anchorX=0;
        --myCoins:set ReferencePoint( display.CenterLeftReferencePoint)
        myCoins.x=118
        myCoins.y=y+198
        myCoins:setTextColor(70,43,3,255)
        SlotInfoGroup[index]:insert (myCoins) 
    end
        
        
end

function removeButtons()
    
    for i=1, 3 do
        SlotButtons[i]:removeEventListener( "touch", SlotTap);
        
        display.remove(SlotButtons[i]);
        SlotButtons[i]=nil;
        
        display.remove(SlotInfoGroup[i]);
        SlotInfoGroup[i]=nil;
        
    end
    SlotButtons=nil;
   
   display.remove(ButtonSettings)
   ButtonSettings=nil
        
   display.remove(ButtonInfo)
   ButtonInfo=nil
        
        
    if(showExitButton and ButtonQuit~=nil) then
        display.remove(ButtonQuit)
        ButtonQuit=nil
    end

   
end



local function Quit(event)
    if inputBox~=nil then
        return;
    end
    
    if event.phase == "ended" then
        CancelAllTransition()
        Runtime:removeEventListener( "key", onKeyEvent )
        buttons:QuitDialog();
        --os.exit();
    end

end



local function createButtons()
  
    SlotButtons={}
    SlotInfoGroup={}
    
    local x=-156;
    local y=-110-25;
    
    for i=1, 3 do
       createSlotButtons(x,y);
       y=y+54;
    end

    ButtonSettings = widget.newButton{
            id="SettingsButton",left=x,top=y+20,
            defaultFile = "src/images/buttons/sign_settings_150x54.png",
            overFile = "src/images/buttons/sign_settings_150x54.png",
            onRelease =Settings,
            width=150,
            height=54,
            label = ""
    }
    mainmenu_window:insert (ButtonSettings)
    ButtonSettings:setFillColor(190,190,190, 255);
    

    -- Standard buttons
    local yOffset=0
    
    if is3x4screen() then
        yOffset=20;
    end
    
    if showExitButton then
    
        ButtonQuit = widget.newButton{
            id="QuitButton",left=display.contentWidth*0.5-2-50,top=display.contentHeight*0.5-2-50+yOffset,
            defaultFile = "src/images/buttons/button_quit.png",
            overFile = "src/images/buttons/button_hover_quit.png",
            onRelease =Quit,
            width=50,
            height=50,
        }
        mainmenu_window:insert (ButtonQuit)
    end
   
    ButtonInfo = widget.newButton{
            id="InfoButton",left=display.contentWidth*0.5-2-50,top=-display.contentHeight*0.5+2-yOffset,
            defaultFile = "src/images/buttons/button_info.png",
            overFile = "src/images/buttons/button_hover_info.png",
            onRelease =Info,
            width=50,
            height=50,
        }
    mainmenu_window:insert (ButtonInfo)
    
end


function ShowHideButtons(self,v)
   for i=1, 3 do
       SlotButtons[i].isVisible=v;
       SlotInfoGroup[i].isVisible=v;
   end
   
   if showExitButton and ButtonQuit~=nil then 
    ButtonQuit.isVisible=v;
   end
   
   ButtonSettings.isVisible=v;
   ButtonInfo.isVisible=v;
       
end









function onKeyEvent( event )
    
    if (event.phase == "up" and event.keyName=="back" ) then


            Runtime:removeEventListener( "key", onKeyEvent )
            if ButtonPlay~=nil and ButtonPlay.x~=nil then
                -- the game was paused
                -- resume it
                --AllTransition[#AllTransition+1]=transition.to( coverDesk, { time=200, alpha=0 } )
                --timer.performWithDelay(200,DoPlay,1)
                
                
            --else
                buttons:QuitDialog();
            end
            return true;
    end
    return false;
end

local function loadAllSlots()
    local found=false;
    for i=1, 3 do
        thegame:loadGameSlot(i);
        if(thegame.GameSlots[i]~=nil) then
            found=true;
        end
    end
    
    if found==false then
        print ("All Slots are empty.");
        thegame.GameSlots={};
        thegame:resetSlot(1,"New 1");
        --print ("ResetSlot 1")
    end
end


function OpenMainMenu()
    showExitButton=true--advertising.ShowAdvertising;
    
    advertising:HideAd()
    
    buttons.isGamePlaying=false;
    
    loadAllSlots()


    advertising:HideAd();
    buttons:removeAllButtons()
    DisableGame()
    isMainMenuOpen=true
    DrawMainMenuWindow()
    createButtons()
    typeVersion()
    
    if system.getInfo( "platformName" ) == "Android" then  
        Runtime:addEventListener( "key", onKeyEvent )
    end
    
    collectgarbage();
    --print( "MemUsage: " .. collectgarbage("count") );
    --local textMem = system.getInfo( "textureMemoryUsed" ) / 1000000;
    --print( "TexMem:   " .. textMem );
end
