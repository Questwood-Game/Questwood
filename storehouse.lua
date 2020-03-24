--
-- Project: store.lua
-- Description: 
--
-- Version: 1.0
-- Managed with http://CoronaProjectManager.com
--
-- Copyright 2012 . All Rights Reserved.
-- 
module(..., package.seeall)

local SpaceAvailaleToBuy=nil;
local dialogCloud=nil;
local isDiologOpen=false;

local StoreBG=nil;
local StoreShelf=nil;
local StoreCounter=nil;
local StoreOperator=nil;

local bag_window=nil;
local bag_scroll=nil;
local CurrentBagImage=nil;
local BagCopacityLabel=nil;
--local BagUsedLabel=nil;

--local removeButtons={};
local itemImages=nil;
local ShopItemImages=nil;
local ShopItemLabels=nil;
local ShopItemTags=nil;



local AllTransition={};
local ButtonBack=nil;


local function is3x4screen()
    if(display.pixelHeight==1024 and display.pixelWidth==768) then return true; end;
    
    if(display.pixelHeight==2048 and display.pixelWidth==1536) then return true; end;
    
    return false;
        
end
local Main_yOffset=0;
if is3x4screen() then
        Main_yOffset=20;
end

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




local function BackEvent()
    Runtime:removeEventListener( "key", onKeyEvent )
    display.remove( ButtonBack)
    ButtonBack=nil
    
    
    
    --AllTransition[#AllTransition+1]=transition.to( coverDeskSettings, { time=200, alpha=0 } )

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
    

        
        if(CurrentBagImage~=nil) then
            CurrentBagImage.alpha=1;
            --ReferencePointFixed
            --CurrentBagImage:set ReferencePoint(display.CenterCenterReferencePoint);
            CurrentBagImage.x=10--display.contentWidth*0.5+80;
            CurrentBagImage.y=74;
            bag_window:insert (CurrentBagImage);
        end
    end
    
    local fontName="Grinched";
    
    if(updateIcon==false) then
        local t1=#thegame.CurrentSlot.BagContent.." / "..thegame.CurrentSlot.CurrentBagCopacity;
        --local t2="Used: "..#thegame.CurrentSlot.BagContent;
        if(BagCopacityLabel==nil) then
            BagCopacityLabel = display.newText(t1, 0, 0, fontName, 16);
            
            BagCopacityLabel.anchorX=0;
            BagCopacityLabel.anchorY=0;
            --BagCopacityLabel:set ReferencePoint(display.TopLeftReferencePoint);
            BagCopacityLabel.x=35;
            BagCopacityLabel.y=68;
            BagCopacityLabel:setTextColor(255,255,255,255);
            bag_window:insert (BagCopacityLabel);
        else
            BagCopacityLabel.text = t1 ;
        end
    end

end





local function DrawBagContentItems(SkipPosition)
    
    itemImages={};
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
            
            itemImages[i]:addEventListener( "tap", BagItemTouch);

            
        end
    end
end



local function DrawBagContent()
    --removeButtons={};
    
    --itemLabels={};

    bag_scroll = widget.newScrollView
    {
    top = 75,
    left = -display.contentWidth*0.5,
    width = 465,
    height = 90,
    scrollWidth = 465,
    scrollHeight = 90,
 hideBackground =true, 
    
    verticalScrollDisabled=true
    }
    bag_window:insert (bag_scroll);

    DrawBagContentItems(0);
end

local ShelfNormalItemInitials={x=-160,y=-80};
local ShelfLargItemInitials={x=-220,y=37};

local ShelfNormalItemCurrent={x=-160,y=-80};
local ShelfLargItemCurrent={x=-220,y=37};

local LargeItemCount=0;


local function AddShelfItem(i,t,w,customPrice,addToCounter)

    local fontName="Basic Comical NC";
    
    local yMargin=0;
    local isLargeObject=false;
       
    local index=levels:findSpriteByTitle(t);
    
        if index~=-1 then 

            local s=sprite_collection.SpriteColection[index];
            
            if (s.isLargeObject~=nil and s.isLargeObject ) or addToCounter then
                isLargeObject=true;
            else
                isLargeObject=false;
            end
        
            if s.ShopYMargin~=nil then
                yMargin=s.ShopYMargin;
            end
            if(LargeItemCount>1) then
                isLargeObject=true;
            end
        
            
            if(isLargeObject) then
                
                LargeItemCount=LargeItemCount+1;
                SpaceAvailaleToBuy=SpaceAvailaleToBuy-1;
                ShopItemImages[i] = display.newImageRect("src/images/thumbnails/"..s.image,100,80);
                ShopItemImages[i].anchorX=0;
                ShopItemImages[i].anchorY=1;
                --ShopItemImages[i]:set Reference Point(display.BottomLeftReferencePoint);
                ShopItemImages[i].x=ShelfLargItemCurrent.x;
                
                if s.thumbnailYoffset~=nil then
                    ShopItemImages[i].y=ShelfLargItemCurrent.y+s.thumbnailYoffset;
                else
                    ShopItemImages[i].y=ShelfLargItemCurrent.y;
                end
                
            else
                ShopItemImages[i] = display.newImageRect("src/images/thumbnails_cut/"..s.image,s.icon_width,s.icon_height);
                
                
                ShopItemImages[i].anchorX=0;
                ShopItemImages[i].anchorY=1;
                --ShopItemImages[i]:set Reference Point(display.BottomLeftReferencePoint);
                ShopItemImages[i].x=ShelfNormalItemCurrent.x;
                ShopItemImages[i].y=ShelfNormalItemCurrent.y+yMargin;
            end
            
            --ShopItemImages[i].InventoryItemIndex=i;
            ShopItemImages[i].index=i;
            
            
            bag_window:insert (ShopItemImages[i]);
            

            ShopItemImages[i]:addEventListener( "touch", ShelfItemTouch);    
            
            if addToCounter==false then    
                
                ShopItemTags[i]= display.newImageRect("src/images/houses/label_yellow.png",34,30);
            else
                
                ShopItemTags[i]= display.newImageRect("src/images/houses/label.png",34,30);
            end
            ShopItemTags[i].anchorY=1;
            --ShopItemTags[i]:set Reference Point(display.BottomCenterReferencePoint);
            
            if(isLargeObject) then 
                ShopItemTags[i].x=ShopItemImages[i].x+60;
                ShopItemTags[i].y=ShopItemImages[i].y-40;
            else
                ShopItemTags[i].x=ShopItemImages[i].x+ShopItemImages[i].width*0.9;
                ShopItemTags[i].y=ShopItemImages[i].y-ShopItemImages[i].height*0.5;
            end
            ShopItemTags[i].index=i;
            
            
            bag_window:insert (ShopItemTags[i]);
            ShopItemTags[i]:addEventListener( "touch", ShelfItemTouch);    
  
            local price=s.apxprice;
            if(customPrice~=-1) then
                    price=customPrice;
            end
            
            if addToCounter then
                ShopItemLabels[i] = display.newText( "New", 0, 0,100,50, fontName, 8);
                ShopItemLabels[i].anchorX=0;
                ShopItemLabels[i].anchorY=1;
                --ShopItemLabels[i]:set Reference Point(display.BottomLeftReferencePoint);
                ShopItemLabels[i].x=ShopItemTags[i].x+18;
                ShopItemLabels[i].y=ShopItemTags[i].y+29;
            else
            
                if  price > 999 then
                    ShopItemLabels[i] = display.newText( price, 0, 0,100,50, fontName, 8);
                else
                    ShopItemLabels[i] = display.newText( price..".-", 0, 0,100,50, fontName, 8);
                end
            
                ShopItemLabels[i].anchorX=0;
                ShopItemLabels[i].anchorY=1;
                --ShopItemLabels[i]:set Reference Point(display.BottomLeftReferencePoint);
            
                if  price > 99 then
                    ShopItemLabels[i].x=ShopItemTags[i].x+17;
                    ShopItemLabels[i].y=ShopItemTags[i].y+30;
                else
                    ShopItemLabels[i].x=ShopItemTags[i].x+21;
                    ShopItemLabels[i].y=ShopItemTags[i].y+27;
                end
            end
            
            
            if addToCounter==false then    
                ShopItemLabels[i]:setTextColor(20,0,0,255);
            else
                ShopItemLabels[i]:setTextColor(255,255,255,255);
            end                
            
            ShopItemLabels[i].rotation=-29;
            bag_window:insert (ShopItemLabels[i]);
  
            if(isLargeObject) then 
                ShelfLargItemCurrent.x=ShelfLargItemCurrent.x+100;
            else
                ShelfNormalItemCurrent.x=ShelfNormalItemCurrent.x+w;
                if ShelfNormalItemCurrent.y>=10 then 
                        SpaceAvailaleToBuy=0;
                end
                if ShelfNormalItemCurrent.x>10 then
                    
                    ShelfNormalItemInitials.x=ShelfNormalItemInitials.x+50;
                    ShelfNormalItemCurrent.x=ShelfNormalItemInitials.x;
                    ShelfNormalItemCurrent.y=ShelfNormalItemCurrent.y+45;
                    
                end    
            end
            
            
        end

end

local function DrawShelfContent()
    LargeItemCount=0;
    
    ShelfNormalItemInitials={x=-160,y=-80};
    ShelfLargItemInitials={x=-220,y=37};

    ShelfNormalItemCurrent={x=-160,y=-80};
    ShelfLargItemCurrent={x=-220,y=37};

    SpaceAvailaleToBuy=4;

    ShopItemImages={};
    ShopItemLabels={};
    ShopItemTags={};
    

    if(levels.ShopInventory==nil) then
        return;
    end

    local fontName="Basic Comical NC";

    
    
    for i = 1,#levels.ShopInventory do
        
        if(levels.ShopInventory[i]~=nil) then
        
            local a=levels.ShopInventory[i];
        
            local t=a[1];--title
            local w=a[2];--width

            local customPrice=a[3] -- price
        
            AddShelfItem(i,t,w,customPrice,false);
        end
    end
    
   
end





local function createButtons(self)

    ButtonBack = widget.newButton{
            id="HelpButton",left=-display.contentWidth*0.5+2,top=-display.contentHeight*0.5+2-20,
            defaultFile = "src/images/buttons/button_back.png",
            overFile = "src/images/buttons/button_hover_back.png",
            onRelease =Back,
            width=50,
            height=50
    }

            
    bag_window:insert (ButtonBack)
           
end
    


local function deleteItemsFromTheShelf()
    for i=1, #ShopItemImages do
        
        if(ShopItemImages[i]~=nil) then
            ShopItemImages[i]:removeEventListener( "touch", ShelfItemTouch);
        end
        
        if(ShopItemTags[i]~=nil) then
            ShopItemTags[i]:removeEventListener( "touch", ShelfItemTouch);
        end

        display.remove(ShopItemImages[i]);
        ShopItemImages[i]=nil;
        
        display.remove(ShopItemLabels[i]);
        ShopItemLabels[i]=nil;
        
        display.remove(ShopItemTags[i]);
        ShopItemTags[i]=nil;
        
        
    end
end

local function deleteItemsFromTheTable()
    
    for i=1, #itemImages do
        
        itemImages[i]:removeEventListener( "tap", BagItemTouch);

        --display.remove(removeButtons[i]);
        --removeButtons[i]=nil;
        
        display.remove(itemImages[i]);
        itemImages[i]=nil;
        
        --display.remove(itemLabels[i]);
        --itemLabels[i]=nil;
        
    end
    --removeButtons=nil;
    itemImages=nil;
    --itemLabels=nil;
    
    
end

local function deleteItemFromBag(index)
    deleteItemsFromTheTable();
    
    table.remove( thegame.CurrentSlot.BagContent, index );
    
    --removeButtons={};
    itemImages={};
    --itemLabels={};

    DrawBagContentItems(index);
   
    for i=index, #itemImages do
        --AllTransition[#AllTransition+1]=transition.to( removeButtons[i], { time=200, x=removeButtons[i].x-100 } )
        AllTransition[#AllTransition+1]=transition.to( itemImages[i], { time=200, x=itemImages[i].x-100 } )
        --AllTransition[#AllTransition+1]=transition.to( itemLabels[i], { time=200, x=itemLabels[i].x-100 } )

    end
        
    UpdateBagInfo(false);
end


local ItmeToBuy_index=0;
function onBuyItemDone(event)
    	if event.phase == "release" then

            local myclosure=function()
                            isDiologOpen=false;
            end
                        
            if ( event.id == "MB_Yes" ) then
                           

                ShopItemTags[ItmeToBuy_index].isVisible=false;
                
                
                ShopItemLabels[ItmeToBuy_index].isVisible=false;
                display.remove(ShopItemLabels[ItmeToBuy_index]);
                ShopItemLabels[ItmeToBuy_index]=nil;
                
                AllTransition[#AllTransition+1]=transition.to( ShopItemImages[ItmeToBuy_index], {time=300, x=250,y=130,xScale=1.5,yScale=1.5})
                           
                           
                local item=levels.ShopInventory[ItmeToBuy_index];
                local type_index=levels:findSpriteByTitle(item[1]);

                if type_index~=nil and type_index~=-1 then
                    local s=sprite_collection.SpriteColection[type_index];
                    local price=s.apxprice;
                    
                    if(item[3]~=-1) then
                        price=item[3];
                    end
                    
                    if s.subtype=="bag" then
                        --buying a bag
                        if thegame.CurrentSlot.CurrentBag==1  then
                            --if you don't have a bag then use a new one
                            mousecharacter:changeBag(s.bagindex,s.bagcopacity);
                            UpdateBagInfo(true);
                        elseif s.bagcopacity>thegame.CurrentSlot.CurrentBagCopacity then
                            --if your vurrent bag is smaller than new one then change them
                            local current_bag=""
                            if(thegame.CurrentSlot.CurrentBag==2) then
                                current_bag="SmallBackpack";
                            elseif(thegame.CurrentSlot.CurrentBag==3) then
                                current_bag="NormalBackpack";
                            elseif(thegame.CurrentSlot.CurrentBag==4) then
                                current_bag="ClosedBasket";
                            end
                            thegame.CurrentSlot.BagContent[#thegame.CurrentSlot.BagContent+1]=current_bag;
                            mousecharacter:changeBag(s.bagindex,s.bagcopacity);
                            UpdateBagInfo(true);
                        else
                            --new bag is smaller or equil than current one
                            thegame.CurrentSlot.BagContent[#thegame.CurrentSlot.BagContent+1]=s.title;    
                        end
                    else
                        -- not a bag
                        thegame.CurrentSlot.BagContent[#thegame.CurrentSlot.BagContent+1]=s.title;    
                    end
        
                    
                                
                    deleteItemsFromTheTable();
                    DrawBagContentItems(0);
                    world:addCoins(-price,thegame.InfoBox.line1[1],thegame.InfoBox.line1[2]);  
                    
                    UpdateBagInfo(false);
                    
                    bag_scroll:scrollToPosition{x = -bag_scroll.width+display.contentWidth,time = 500}
                    
                    local myclosure_accepted=function()
                        
                        
                        ShopItemImages[ItmeToBuy_index]:removeEventListener( "tap", ShelfItemTouch);
                        ShopItemImages[ItmeToBuy_index].isVisible=false;
                        
                        ShopItemTags[ItmeToBuy_index]:removeEventListener( "tap", ShelfItemTouch);
                        
                        levels.ShopInventory[ItmeToBuy_index]={};
                        display.remove(ShopItemImages[ItmeToBuy_index]);
                        ShopItemImages[ItmeToBuy_index]=nil;
                        
                        
                        display.remove(ShopItemTags[ItmeToBuy_index]);
                        ShopItemTags[ItmeToBuy_index]=nil;
                        
                        
                        --table.remove( ShopItemImages, ItmeToBuy_index);
                        --table.remove( ShopItemTags, ItmeToBuy_index);
                        --table.remove( ShopItemLabels, ItmeToBuy_index);
                    end
                    
                    Timers[#Timers+1]=timer.performWithDelay(500,myclosure_accepted,1);
                    
                end
                
            end
            Timers[#Timers+1]=timer.performWithDelay(1000,myclosure,1);
           
            dialogCloud.isVisible = false;

            display.remove(dialogCloud);
            dialogCloud=nil;
       end
end


function ShelfItemTouch (event)

    
      if isDiologOpen then
         return;
     end
     
     if ( event.phase == "began" ) then
                         
                         
                         
        cancelTimers();
        CancelAllTransition();
        thegame:deleteMessage();

        local i=event.target.index;

        local item=levels.ShopInventory[i];
        
        if item[4]~=nil and item[4] then
            thegame:ShowMessage("Not for sale.",3);
            return ;
        end

        ItmeToBuy_index=i

        local type_index=levels:findSpriteByTitle(item[1]);

        if type_index~=nil and type_index~=-1 then
            local s=sprite_collection.SpriteColection[type_index];
            --ItmeToSell_type_index=type_index;
            
            
            if thegame.CurrentSlot.CurrentBag==1 and s.subtype~="bag" then
                thegame:ShowMessage("You don't have a bag yet.",3);
                return ;
            end
            
            if #thegame.CurrentSlot.BagContent>=thegame.CurrentSlot.CurrentBagCopacity and s.subtype~="bag" then
                thegame:ShowMessage("Not enough space in the bag.",3);
                return ;
            end

        local myButtonImages =
        {
            { id="MB_Okay"},
            { id="MB_Cancel"},
            { id="MB_Yes", up= "src/images/stages/apply_button.png", down= "src/images/stages/apply_button_hover.png",	w=66, h=46 },
            { id="MB_No", up= "src/images/stages/cancel_button.png", down= "src/images/stages/cancel_button_hover.png",	w=40, h=40 },
            { id="MB_Help" }
        }
        
        local msg="";

        local f=string.sub (s.title, 1,1);

        local price=s.apxprice;
        if(item[3]~=-1) then
                   price=item[3];
        end
        
        if price>thegame.CurrentSlot.ScoreCoins then
            thegame:ShowMessage("Not enough coins.",3);
            return ;
        end
        
        
        
        
        if f=="A" or f=="E" or  f=="I" or f=="O" or f=="U" then
            msg="Do you want to buy an "..s.title.." for "..price.." coins?   ("..s.description..")";
        else
            msg="Do you want to buy a "..s.title.." for "..price.." coins?   ("..s.description..")";
        end

        
       
        dialogCloud = cMessageBox.newMessageBox{
    msgBoxType = "MB_YesNo",
    background ="src/images/stages/dialog.png",
    width = 364,
    height= 232,
    captionText = "Buy Now",
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

            isDiologOpen=true;
        end
    end
end

local ItmeToSell_index=0;

function onSellItemDone(event)
    	if event.phase == "release" then

            local myclosure_accepted=function()
                            isDiologOpen=false;
                           
            end
                        
            if ( event.id == "MB_Yes" ) then
                
                    
                    local type_index=levels:findSpriteByTitle(thegame.CurrentSlot.BagContent[ItmeToSell_index]);
                    if type_index~=0 then
                        local s=sprite_collection.SpriteColection[type_index];
                        local price=math.floor(s.apxprice-s.apxprice*0.2);
                        AddShelfItem(#ShopItemImages+1,s.title,100,0,true);
   
                        local i=#ShopItemImages;
                        local x=ShopItemImages[i].x;
                        local y=ShopItemImages[i].y;
                        ShopItemImages[i].x=itemImages[ItmeToSell_index].x+bag_scroll.x-50+bag_scroll:getContentPosition();
                        ShopItemImages[i].y=itemImages[ItmeToSell_index].y+bag_scroll.y+80;
                        
                        
                        world:addCoins(price,thegame.InfoBox.line1[1],thegame.InfoBox.line1[2]);  
                        
                        levels.ShopInventory[#levels.ShopInventory+1]={s.title,50,-1,true};
                        
                        ShopItemTags[i].alpha=0;
                        ShopItemLabels[i].alpha=0;
                        
                        deleteItemFromBag (ItmeToSell_index); 
                
                        AllTransition[#AllTransition+1]=transition.to( ShopItemTags[i], { delay=500, time=100, alpha=1})
                        AllTransition[#AllTransition+1]=transition.to( ShopItemLabels[i], { delay=500, time=100, alpha=1})

                        AllTransition[#AllTransition+1]=transition.to( ShopItemImages[i], { time=500, x=x,y=y})
                        
                        
                        
                        
                        
                        --AllTransition[#AllTransition+1]=transition.to( itemImages[ItmeToSell_index], { time=100, xScale=1.5,yScale=1.5,y=itemImages[ItmeToSell_index].y-20} )
                        --AllTransition[#AllTransition+1]=transition.to( itemImages[ItmeToSell_index], { delay=100,time=100, xScale=0.5,yScale=0.5,alpha=0.1,y=itemImages[ItmeToSell_index].y+20} )

                       
                    end
                
                
            end
            
            Timers[#Timers+1]=timer.performWithDelay(1000,myclosure_accepted,1);
           
            dialogCloud.isVisible = false;

            display.remove(dialogCloud);
            dialogCloud=nil;
        end
           
end



 function BagItemTouch (event)
     
     if isDiologOpen then
       return;
     end
     
     if SpaceAvailaleToBuy<=0 then
         thegame:ShowMessage("Not buying any more today.",3);
         return ;
     end
     
        
                         
                         
                         
        cancelTimers();
        CancelAllTransition();
        thegame:deleteMessage();

        local i=event.target.index;

        ItmeToSell_index=i
        local type_index=levels:findSpriteByTitle(thegame.CurrentSlot.BagContent[i]);

        if type_index~=nil and type_index~=-1 then
            local s=sprite_collection.SpriteColection[type_index];
            --ItmeToSell_type_index=type_index;

 local myButtonImages =
        {
            { id="MB_Okay"},
            { id="MB_Cancel"},
            { id="MB_Yes", up= "src/images/stages/apply_button.png", down= "src/images/stages/apply_button_hover.png",	w=66, h=46 },
            { id="MB_No", up= "src/images/stages/cancel_button.png", down= "src/images/stages/cancel_button_hover.png",	w=40, h=40 },
            { id="MB_Help" }
        }
        
        local msg="";

  
        local price=math.floor(s.apxprice-s.apxprice*0.2);

            msg="Would you sell "..s.title.." for "..price.." coins?   ("..s.description..")";

        
       
        dialogCloud = cMessageBox.newMessageBox{
    msgBoxType = "MB_YesNo",
    background ="src/images/stages/dialog.png",
    width = 364,
    height= 232,
    captionText = "Sell to the store",
    captionSize="18",
    buttonImages=myButtonImages,
    borderSizeX=20,
    borderSizeY=30,
    messageText = msg,
    messageJustify = display.CenterReferencePoint,
    onEvent = onSellItemDone,
    rectFillColor={0,255, 100, 255 },
    captionColor = {255,255, 255, 255 },
    messageColor = {255,255, 255, 255 }
    }

            isDiologOpen=true;
        end

    
end

--[[
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
            world:addTouchListenersToSpecialBodies(newBodyIndex);
            
            deleteItemFromBag (bi);
        end
    end
end
]]

function DoBack(self,CreateGameButtons)
    
    local ShopInventory={};

    for i = 1,#levels.ShopInventory do
        local n=levels.ShopInventory[i]
        if(#n>0) then
            local a=levels.ShopInventory[i];
            a[4]=nil;
            ShopInventory[#ShopInventory+1]=a;
            
        end
        levels.ShopInventory[i]=nil;
    end
    levels.ShopInventory=ShopInventory;
    
    display.remove(dialogCloud);
    dialogCloud=nil;
    
    
    deleteItemsFromTheTable();
    deleteItemsFromTheShelf();
    
    

    CancelAllTransition()
    
    display.remove(StoreBG);
    StoreBG=nil;
    
    display.remove(StoreShelf);
    StoreShelf=nil;
    
    display.remove(StoreCounter);
    StoreCounter=nil;
    
    display.remove(StoreOperator);
    StoreOperator=nil;
    
    
    thegame:deleteMessage();

    display.remove( ButtonBack)
    ButtonBack=nil
    
    buttons.physics_paused=false;
    physics.start()

    
    display.remove(CurrentBagImage);
    CurrentBagImage=nil;

    display.remove(BagCopacityLabel);
    BagCopacityLabel=nil;
    
    --display.remove(BagUsedLabel);
    --BagUsedLabel=nil;
    
    
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
    
    
local function DrawStoreWindow()


        

        --AllTransition[#AllTransition+1]=transition.to( StoreBG, { time=500, alpha=0.8 } )
                    
                        
	bag_window = display.newGroup();

        --bag_window.width= display.contentWidth
        --bag_window.height= display.contentHeight
        bag_window.width= 600
        bag_window.height=320--384--768/2 --320
        
	bag_window.x =display.contentWidth*0.5--display.contentWidth*0.5-display.contentWidth*0.5
	bag_window.y =160+20-Main_yOffset   --display.contentHeight*0.5-display.contentHeight*0.5;
        bag_window.alpha=0.0
        
        
        
        local is3x4=""; 
        local h=320
        if(display.pixelHeight==1024 and display.pixelWidth==768) then            is3x4="_3x4"; h=384; end;
        if(display.pixelHeight==2048 and display.pixelWidth==1536) then            is3x4="_3x4";h=384;  end;
        
       
        local store_image="store_bg"..is3x4..".png"
        
        StoreBG = display.newImageRect( "src/images/store/"..store_image,600, h)
        --StoreBG = display.newRect(0, 0,display.contentWidth*2,display.contentHeight*2)
	
        
        StoreBG.x=0
        StoreBG.y=0-20+Main_yOffset   
        bag_window:insert (StoreBG);
        
        
        StoreShelf= display.newImageRect( "src/images/store/shelf.png",376,148)
        --ReferencePointFixed
        --StoreShelf:set ReferencePoint( display.CenterCenterReferencePoint)
        StoreShelf.x=-0
        StoreShelf.y=-53
        bag_window:insert (StoreShelf);
        
        StoreCounter= display.newImageRect( "src/images/store/counter.png",454,132)
        --ReferencePointFixed
        --StoreCounter:set ReferencePoint( display.CenterCenterReferencePoint)
        StoreCounter.x=-0
        StoreCounter.y=85
        bag_window:insert (StoreCounter);
        
        if levels.StoreOperatorImage~="" then
            StoreOperator= display.newImageRect( "src/images/store/"..levels.StoreOperatorImage,168,168)
            --StoreOperator:set ReferencePoint( display.CenterCenterReferencePoint)
            StoreOperator.x=125
            StoreOperator.y=-42
            bag_window:insert (StoreOperator);
        end

        
        
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
        


        local myText = display.newText( "My Bag:", 0, 0, fontName_1, 20)
        myText.anchorY=0;
        --myText:set ReferencePoint(display.TopCenterReferencePoint);
        myText.x=-40;
        myText.y=65--260;
        myText:setTextColor(250,250,250,255);
        
        bag_window:insert (myText);
        
        
        

        
        UpdateBagInfo(true);
        UpdateBagInfo(false);
        
        
        DrawBagContent();
        DrawShelfContent();

        AllTransition[#AllTransition+1]=transition.to( bag_window, { time=300, alpha=1.0 } )
        AllTransition[#AllTransition+1]=transition.to( myText, {delay=300, time=300, alpha=1.0 } )

        
        world:moveInfoBoxGroup(true);
     
        --local myclosure= function()
--             board:addEventListener( "touch", touchBoard)
  --      end
    --    Timers[#Timers+1]=timer.performWithDelay(100,myclosure,1)
                
        
            
end


function ShowStoreWindow(self)
    advertising:HideAd()
    
    thegame:removeSkyDropListener();
    
    buttons.physics_paused=true;
    physics.pause();
    buttons:removeAllButtons();
    buttons.isGamePlaying=true;
        
    DrawStoreWindow();
    
end

