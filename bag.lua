--
-- Project: bag.lua
-- Description: 
--
-- Version: 1.0
-- Managed with http://CoronaProjectManager.com
--
-- Copyright 2012 . All Rights Reserved.
-- 
module(..., package.seeall)

local coverDesk=nil;
local bag_window=nil;
local bag_scroll=nil;
local CurrentBagImage=nil;
local BagCopacityLabel=nil;
local BagUsedLabel=nil;

local removeButtons={};
local itemImages={};
local itemLabels={};



local AllTransition={};
local ButtonBack=nil;

local function CancelAllTransition()
    for i=1, #AllTransition  do

        transition.cancel(AllTransition[i])
        AllTransition[i]=nil

    end
    i=nil
    AllTransition={}
end

local Timers={}
local function cancelTimers()
    for i=1, #Timers do
            timer.cancel( Timers[i] ) 
            Timers[i]=nil
    end
    Timers={}
end


local function is3x4screen()
    if(display.pixelHeight==1024 and display.pixelWidth==768) then return true; end;
    
    if(display.pixelHeight==2048 and display.pixelWidth==1536) then return true; end;
    
    return false;
        
end



local function BackEvent()
    Runtime:removeEventListener( "key", onKeyEvent )
    display.remove( ButtonBack)
    ButtonBack=nil
    
    
    
    AllTransition[#AllTransition+1]=transition.to( coverDeskSettings, { time=200, alpha=0 } )

    local myclosure=function()
          DoBack(nil,true);
    end
    timer.performWithDelay(200,myclosure,1);
end

function Back(event)
   if event.phase == "ended" then
        
        BackEvent()
   end
        
end


function onKeyEvent( event )

    if (event.phase == "up" and event.keyName=="back" ) then
        Runtime:removeEventListener( "key", onKeyEvent )
        BackEvent()
        return true;
    end
    return false;
end


local function UpdateBagInfo(updateIcon)
            
    if(updateIcon) then
        if(CurrentBagImage~=nil) then
            display.remove(CurrentBagImage);
            CurrentBagImage=nil;
        end
        
        
        local image="";
        if(thegame.CurrentSlot.CurrentBag==2) then
            image="backpack_small.png";
            CurrentBagImage = display.newImageRect("src/images/sprites/"..image,24,24);
        elseif(thegame.CurrentSlot.CurrentBag==3) then
            image="backpack_normal.png";
            CurrentBagImage = display.newImageRect("src/images/sprites/"..image,30,34);
        elseif(thegame.CurrentSlot.CurrentBag==4) then
            image="basket_closed.png";
            CurrentBagImage = display.newImageRect("src/images/sprites/"..image,32,34);
        end
    

        
        
        CurrentBagImage.Alpha=255;
        CurrentBagImage.anchorY=0;
        --CurrentBagImage:set ReferencePoint(display.TopCenterReferencePoint);
        CurrentBagImage.x=display.contentWidth*0.5+80;
        CurrentBagImage.y=62;
        bag_window:insert (CurrentBagImage);
    end
    
    local fontName="Grinched";
    
    local t1="Bag Copacity: "..thegame.CurrentSlot.CurrentBagCopacity;
    local t2="Used: "..#thegame.CurrentSlot.BagContent;
    if(BagCopacityLabel==nil) then
        BagCopacityLabel = display.newText(t1, 0, 0, fontName, 15);
        BagCopacityLabel.anchorX=0;
        BagCopacityLabel.anchorY=0;
        --BagCopacityLabel:set ReferencePoint(display.TopLeftReferencePoint);
        BagCopacityLabel.x=350;
        BagCopacityLabel.y=63;
        BagCopacityLabel:setTextColor(200,200,200,255);
        bag_window:insert (BagCopacityLabel);
    else
        BagCopacityLabel.text = t1 ;
    end
    
    if(updateIcon==false) then
        if(BagUsedLabel==nil) then
            BagUsedLabel = display.newText(t2, 0, 0, fontName, 15);
            
            BagUsedLabel.anchorX=0;
            BagUsedLabel.anchorY=0;
            --BagUsedLabel:set ReferencePoint(display.TopLeftReferencePoint);
            BagUsedLabel.x=350;
            BagUsedLabel.y=81;
            BagUsedLabel:setTextColor(200,200,200,255);
            bag_window:insert (BagUsedLabel);
        else
            BagUsedLabel.text = t2;
        end
    end
end





local function DrawBagContentItems(SkipPosition)
    
--hideBackground =true, 
--    backgroundColor={255,0,0,100},    

    local fontName="Basic Comical NC";

    local w=110;
    
    local x=60-w;
    
    for i = 1,#thegame.CurrentSlot.BagContent, 1 do
        
        local index=levels:findSpriteByTitle(thegame.CurrentSlot.BagContent[i]);
    
        if index~=-1 then 

            local s=sprite_collection.SpriteColection[index];

            

            itemImages[i] = display.newImageRect("src/images/thumbnails/"..s.image,100,80);
            
            x=x+w;
            if(i==SkipPosition) then
                x=x+w;
            end
            
            
            --[[itemImages[i] = widget.newButton{
                id="RemoveButton",left=x-50,top=y,
                defaultFile = "src/images/thumbnails/"..s.image,
                overFile = "src/images/thumbnails/"..s.image,
                onRelease = RemoveItem,
                width=100,
                height=80
            }
            ]]
            itemImages[i].anchorY=0;
            --itemImages[i]:set ReferencePoint(display.TopCenterReferencePoint);
            itemImages[i].x=x;
            itemImages[i].y=0;
            itemImages[i].index=i;
            bag_scroll:insert (itemImages[i]);
            
            itemImages[i]:addEventListener( "tap", ItemTouch);

            
            itemLabels[i] = display.newText( s.description, 0, 0,100,50, fontName, 12);
            itemLabels[i].anchorY=0;
            --itemLabels[i]:set ReferencePoint(display.TopCenterReferencePoint);
            itemLabels[i].x=x;
            itemLabels[i].y=80;
            itemLabels[i]:setTextColor(250,250,250,255);
            bag_scroll:insert (itemLabels[i]);
            
            
            removeButtons[i] = widget.newButton{
                id="RemoveButton",left=x-13,top=140,
                defaultFile = "src/images/buttons/remove.png",
                overFile = "src/images/buttons/remove.png",
                onRelease = RemoveItem,
                width=26,
                height=26
            }

            bag_scroll:insert (removeButtons[i]);
            removeButtons[#removeButtons].index=i;
            
        end
    end
end

local function DrawBagContent()
    removeButtons={};
    itemImages={};
    itemLabels={};

    bag_scroll = widget.newScrollView
    {
    top = 110,
    left = 50,
    width = 365,
    height = 130,
    scrollWidth = 365,
    scrollHeight = 130,
 
    hideBackground =true, 
    verticalScrollDisabled=true
    }

    DrawBagContentItems(0);
end







local function createButtons(self)

local yOffset=0;
if is3x4screen() then
        yOffset=20;
end


    ButtonBack = widget.newButton{
            id="HelpButton",left=2,top=2-yOffset,
            defaultFile = "src/images/buttons/button_back.png",
            overFile = "src/images/buttons/button_hover_back.png",
            onRelease =Back,
            width=50,
            height=50
    }

    bag_window:insert (ButtonBack)
           
end
    


local function deleteItemsFromTheTable()
    
    for i=1, #removeButtons do
        
        itemImages[i]:removeEventListener( "tap", ItemTouch);

        display.remove(removeButtons[i]);
        removeButtons[i]=nil;
        
        display.remove(itemImages[i]);
        itemImages[i]=nil;
        
        display.remove(itemLabels[i]);
        itemLabels[i]=nil;
        
    end
    removeButtons=nil;
    itemImages=nil;
    itemLabels=nil;
    
    
end

local function deleteItemFromBag(index)
    deleteItemsFromTheTable();
    
    table.remove( thegame.CurrentSlot.BagContent, index );
    
    removeButtons={};
    itemImages={};
    itemLabels={};

    DrawBagContentItems(index);
   
    for i=index, #removeButtons do
        AllTransition[#AllTransition+1]=transition.to( removeButtons[i], { time=200, x=removeButtons[i].x-100 } )
        AllTransition[#AllTransition+1]=transition.to( itemImages[i], { time=200, x=itemImages[i].x-100 } )
        AllTransition[#AllTransition+1]=transition.to( itemLabels[i], { time=200, x=itemLabels[i].x-100 } )

    end
    
    UpdateBagInfo(false);
end


 function ItemTouch (event)
        cancelTimers();
        CancelAllTransition();
        thegame:deleteMessage();

        local i=event.target.index;

        local type_index=levels:findSpriteByTitle(thegame.CurrentSlot.BagContent[i]);

        if type_index~=nil and type_index~=-1 then
            local accept=true;
            local s=sprite_collection.SpriteColection[type_index];

            local myclosure_accepted=function()
                
            
                deleteItemFromBag (i); 
            end
            
            
            --local myclosure=function()
                
                
                if(s.subtype=="food") then
                    loadsounds:PlayEatingSound();

                    thegame.CurrentSlot.Energy=thegame.CurrentSlot.Energy+s.energyvalue;
                    mousecharacter:changeFace(0,100,{2,3,4,10,11,8,11,10,8,1,4,3})
                
                    if thegame.CurrentSlot.Energy >1500 and thegame.CurrentSlot.Energy<=1700 then
                        thegame:ShowMessage("Don't overeat!",2);
                    elseif thegame.CurrentSlot.Energy >1700 and thegame.CurrentSlot.Energy<=1900 then
                        thegame:ShowMessage("Don't overeat!!",2);
                    elseif thegame.CurrentSlot.Energy >1900 then
                        thegame:ShowMessage("Don't overeat!!!",2);
                    end
                    
                    if(thegame.CurrentSlot.Energy>=2000) then
                        print ("You lost.");
                        accept=false;
                        DoBack(nil,false);
                    end
                elseif(s.subtype=="shoes") then
                        local current_shoes=""
                        if(thegame.CurrentSlot.CurrentShoes==2) then
                            current_shoes="Shoes";
                        elseif(thegame.CurrentSlot.CurrentShoes==3) then
                            current_shoes="Boots";
                        elseif(thegame.CurrentSlot.CurrentShoes==4) then
                            current_shoes="Trainers";
                        end
                        if thegame.CurrentSlot.CurrentShoes>1 then
                            --place current shoes into the bag
                            thegame.CurrentSlot.BagContent[#thegame.CurrentSlot.BagContent+1]=current_shoes;
                        end
                        mousecharacter:changeShoes(s.shoesindex);
                elseif(s.subtype=="ball") then
                        local current_ball=thegame.CurrentSlot.CurrentBall;
                        if(current_ball~=nil and current_ball~="") then
                            thegame.CurrentSlot.BagContent[#thegame.CurrentSlot.BagContent+1]=current_ball;    
                        end
                        mousecharacter:PlaceBallIntoArms(s.title);
                elseif(s.subtype=="bag") then
                        local current_bag=""
                        if(thegame.CurrentSlot.CurrentBag==2) then
                            current_bag="SmallBackpack";
                        elseif(thegame.CurrentSlot.CurrentBag==3) then
                            current_bag="NormalBackpack";
                        elseif(thegame.CurrentSlot.CurrentBag==4) then
                            current_bag="ClosedBasket";
                        end
                        
                    if s.bagindex>thegame.CurrentSlot.CurrentBag then
                        -- new one is bigger
                        -- change bag and place old bag into new one
                        
                        thegame.CurrentSlot.BagContent[#thegame.CurrentSlot.BagContent+1]=current_bag;
                        mousecharacter:changeBag(s.bagindex,s.bagcopacity);
                        UpdateBagInfo(true);
                   else 
                        -- new bag is the same or smaller
                        -- put new bag into existing bag
                        local space=thegame.CurrentSlot.CurrentBagCopacity-#thegame.CurrentSlot.BagContent;
                        if(#thegame.CurrentSlot.BagContent>s.bagcopacity) then
                            thegame:ShowMessage("This bag is too small.",1);
                            accept=false;
                        else
                            thegame.CurrentSlot.BagContent[#thegame.CurrentSlot.BagContent+1]=current_bag;
                            mousecharacter:changeBag(s.bagindex,s.bagcopacity);   
                            UpdateBagInfo(true);
                        end
                    end
                else
                    accept=false;
                end
                
                if(accept)then
                    AllTransition[#AllTransition+1]=transition.to( itemImages[i], { time=100, xScale=1.5,yScale=1.5,y=itemImages[i].y-20} )
                    AllTransition[#AllTransition+1]=transition.to( itemImages[i], { delay=100,time=100, xScale=0.5,yScale=0.5,alpha=0.1,y=itemImages[i].y+20} )

                    Timers[#Timers+1]=timer.performWithDelay(300,myclosure_accepted,1);
                end
            --end
            --Timers[#Timers+1]=timer.performWithDelay(300,myclosure,1);
            
            
        end
    --end
    
end


function RemoveItem(event)
   if event.phase == "ended" then
        cancelTimers();
        CancelAllTransition();
        
    
        local bi=event.target.index;
        
        local type_index=levels:findSpriteByTitle(thegame.CurrentSlot.BagContent[bi]);
        
        if type_index~=nil and type_index~=-1 then
            local s=sprite_collection.SpriteColection[type_index];
            local w=mousecharacter.wheel;
            
            local d=mousecharacter.torso.xScale;
            local newBodyIndex=levels:AddBody(s.title,w.x+15*-d,w.y-30,0,s.subtype);
            --world.WorldSprites[newBodyIndex]:addEventListener("postCollision", onBodyCollision);
            thegame:add_postCollisionListener(newBodyIndex);
            world:addTouchListenersToSpecialBodies(newBodyIndex);
            
            deleteItemFromBag (bi);
        end
    end
end


function DoBack(self,CreateGameButtons)
    
    local BagContent={};
    for i = 1,#thegame.CurrentSlot.BagContent do
        
        if(thegame.CurrentSlot.BagContent[i]~=nil) then
            BagContent[#BagContent+1]=thegame.CurrentSlot.BagContent[i];
        end
        thegame.CurrentSlot.BagContent[i]=nil;
    end
    thegame.CurrentSlot.BagContent=BagContent;
    
    
    deleteItemsFromTheTable()
    
    

    CancelAllTransition()
    
    display.remove(coverDesk);
    coverDesk=nil;
    
    thegame:deleteMessage();

    display.remove( ButtonBack)
    ButtonBack=nil
    
    buttons.physics_paused=false;
    physics.start()

    
    display.remove(CurrentBagImage);
    CurrentBagImage=nil;

    display.remove(BagCopacityLabel);
    BagCopacityLabel=nil;
    
    display.remove(BagUsedLabel);
    BagUsedLabel=nil;
    
    
    display.remove(bag_scroll)
    bag_scroll=nil
    
    if CreateGameButtons then
        local myclosure= function()
             thegame:setSkyDropListener()
             --gameplay:setBubbleListener()
             buttons:createGameButtons()
             cancelTimers()
        end
        Timers[#Timers+1]=timer.performWithDelay(500,myclosure,1)
    end
    
    display.remove(bag_window)
    bag_window=nil
    
    world:moveInfoBoxGroup(false);
    
    advertising:ShowAd();

end
    
    
local function DrawBagWindow()


        coverDesk = display.newRect(0, 0,display.contentWidth*2,display.contentHeight*2)
	coverDesk:setFillColor(0,0,0, 220)
        --ReferencePointFixed
        --coverDesk:set ReferencePoint( display.CenterCenterReferencePoint)
        coverDesk.x=display.contentWidth*0.5
        coverDesk.y=display.contentHeight*0.5
        thegame.background_front:insert (coverDesk);
        

        AllTransition[#AllTransition+1]=transition.to( coverDesk, { time=500, alpha=0.8 } )
                    
                        
	bag_window = display.newGroup();
        --thegame.background_front:insert (bag_window );

        bag_window.width= display.contentWidth
        bag_window.height= display.contentHeight
        
	bag_window.x =0--display.contentWidth*0.5-display.contentWidth*0.5
	bag_window.y =0--display.contentHeight*0.5-display.contentHeight*0.5;
        bag_window.alpha=1
        
        local y=260;

        createButtons();
        
        local fontName_1;
        local fontName_2;
        --if system.getInfo( "platformName" ) == "iPhone OS" then
            --fontName_1=native.systemFont;
          --  fontName_2=native.systemFont;
        --else
            fontName_1="Grinched";
--            fontName_2="Colophon DBZ"
        --end
        


        local myText = display.newText( "My Bag", 0, 0, fontName_1, 26)
        myText.anchorY=0;
        --myText:set ReferencePoint(display.TopCenterReferencePoint);
        myText.x=display.contentWidth*0.5;
        myText.y=70--260;
        myText:setTextColor(250,250,250,255);
        
        bag_window:insert (myText);
        
        local myText2 = display.newText( "Click on an item to use or eat it.", 0, 0, fontName_1, 12)
        myText2.anchorY=0;
        --myText2:set ReferencePoint(display.TopCenterReferencePoint);
        myText2.x=display.contentWidth*0.5;
        myText2.y=300;
        myText2:setTextColor(200,200,200,255);
        
        bag_window:insert (myText2);
        
        

        
        UpdateBagInfo(true);
        UpdateBagInfo(false);
        
        
        DrawBagContent();

        AllTransition[#AllTransition+1]=transition.to( board, { time=300, alpha=1.0 } )
        AllTransition[#AllTransition+1]=transition.to( myText, {delay=300, time=300, alpha=1.0 } )

        
     
        --local myclosure= function()
--             board:addEventListener( "touch", touchBoard)
  --      end
    --    Timers[#Timers+1]=timer.performWithDelay(100,myclosure,1)
         world:moveInfoBoxGroup(true);
            
end


function ShowBagWindow(self)
    advertising:HideAd()
    
    thegame:removeSkyDropListener();
    
    buttons.physics_paused=true;
    physics.pause();
    buttons:removeAllButtons();
    buttons.isGamePlaying=true;
        
    DrawBagWindow();
    
end

