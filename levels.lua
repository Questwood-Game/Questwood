--
-- Project: Levels
-- Description: 
--
-- Version: 1.0
-- Managed with http://CoronaProjectManager.com
--
-- Copyright 2012 . All Rights Reserved.
-- 

------------------------------------------------------------------------
-- Construct castle (body type defaults to "dynamic" when not specified)

module(..., package.seeall)

GameScreenWidth=0;
GameScreenHeight=0;



--ShowAds=false
local opacity=0
local TileSets=nil;
local MapBGBackLayerIndex=0;
local WaterTileIndexes={};
local min_index=1;
ShopInventory=nil;

NumberOfLevels=7
MusicTheme=1
StoreOperatorImage=""

local isHd = false
function determineHd()
        if display.contentScaleX <= 0.5 then isHd = true end
end


local CurrentMapData=nil;
local CurrentMapFront=nil;
local CurrentMapBack=nil;
local CurrentMapWalls=nil;

function nulLevel()
    --ShowAds=nil
    local TileSets=nil;
--FallInterval=nil
--PossibleBody=nil
--DropObjectX=nil
--DropObjectY=nil


ShopInventory=nil;
--MaxNumber=nil
--MinNumber=nil
--MaxResult=nil
--MinResult=nil
--direction=nil
--NumberOfTasks=nil
--PipeLowerY=nil
CurrentMapData=nil;

display.remove(CurrentMapFront);
CurrentMapFront=nil;

display.remove(CurrentMapBack);
CurrentMapBack=nil;

CurrentMapWalls=nil;

WaterTileIndexes=nil;
end


--[[
local function GetTennisBalls(xBin,yBin,count)
    local s=""
    
    for i=1,count do
        local x=xBin+(i-count*0.5)
        local y=yBin---i*10
        s=s.."body,TennisBall,"..x..","..y..",0;"
    end
    return s
end
]]

local function setBackground(bgImage,Layer,dx)
    local f=string.find(bgImage,".jpg");
    if(f~=nil) then
        bgImage=string.sub (bgImage,1 ,f-1);
    end
    --print ("bgImage="..bgImage);
    
    
    
    local is3x4=""; 
    local h=320;hm=0;
    if(display.pixelHeight==1024 and display.pixelWidth==768) then             is3x4="_3x4";h=384;hm=32; end;
    if(display.pixelHeight==2048 and display.pixelWidth==1536) then            is3x4="_3x4";h=384;hm=32;  end;
    
    
    --local x= 0--display.contentWidth*0.5
    --world.BGSprites[#world.BGSprites+1]={image=bgImage..is3x4..".jpg"}
    --world.BGSprites[#world.BGSprites].xScale = 1;
    --world.BGSprites[#world.BGSprites].yScale = 1
    --world.BGSprites[#world.BGSprites].ReferencePoint= display.BottomLeftReferencePoint 
    --world.BGSprites[#world.BGSprites].x =x;
    --world.BGSprites[#world.BGSprites].y = display.contentHeight+hm;
    --world.BGSprites[#world.BGSprites].width=600;
    --world.BGSprites[#world.BGSprites].height=h;
    --world.BGSprites[#world.BGSprites].dx = dx--.1
    --world.BGSprites[#world.BGSprites].layer=Layer
    
    
    local bgCount=#background.bg+1;
    background.bg[bgCount] = display.newImageRect(bgImage..is3x4..".jpg",600, h);
    --background.bg[bgCount].currentFrame = vReal;
    background.bg[bgCount].anchorX=0;
    background.bg[bgCount].anchorY=1;
    --background.bg[bgCount]:set Reference Point( display.BottomLeftReferencePoint)
    
    background.bg[bgCount].x = 0;
    background.bg[bgCount].y = display.contentHeight+hm;
                                            
    background.bg[bgCount].dx = dx
    background.bg[bgCount].originalX=0;
    background.bg[bgCount].originalY=display.contentHeight+hm;
    background.bg[bgCount].layer=Layer;
            
    if(Layer==0) then
        thegame.background_back:insert( background.bg[bgCount])
    else
        thegame.background_front:insert( background.bg[bgCount])
    end
    
end


--local function CreateLevel_1()
    
    --local level1a = require("level1c")
    --CurrentMapData= level1a:Level1Data();


    
    --DropObjectX=0;    DropObjectY=70
    --TaskType=1;NumberOfTasks=1
    --PipeLowerY=120  
    --MinNumber=1;MaxNumber=2;    MinResult=0;MaxResult=5
    --FallInterval=2000
    --PossibleBody={"Watermelon"}
    --setBackground("src/images/levels/level_1_bg0",0)
    
--end


local function isVisible(obj)
        
        local screen = display.getCurrentStage().contentBounds
        local bounds = obj.contentBounds
    
        local bxMin=bounds.xMin---game.x;
        local bxMax=bounds.xMax---game.x;
        local byMin=bounds.yMin---game.y;
        local byMax=bounds.yMax---game.y;
        
        local sxMin=screen.xMin-50;
        local sxMax=screen.xMax+50;
        local syMin=screen.yMin-50;
        local syMax=screen.yMax+50;
        
        local left = bxMin <= sxMin and bxMax > sxMin
        local right = bxMin >= sxMin and bxMin <= sxMax
        local up = byMin <= syMin and byMax >= syMin
        local down = byMin >= syMin and byMin <= syMax
        
        
        
        
        return (left or right) and (up or down)
end

function UpdateMap(self)
        
        
            
                for i = 1, CurrentMapFront.numChildren do
                        if isVisible(CurrentMapFront[i]) then
                                CurrentMapFront[i].isVisible = true
                        else
                                CurrentMapFront[i].isVisible = false
                        end
                end
                
                for i = 1, CurrentMapBack.numChildren do
                        if isVisible(CurrentMapBack[i]) then
                                CurrentMapBack[i].isVisible = true
                        else
                                CurrentMapBack[i].isVisible = false
                        end
                end
                
                

end


local function getTileSetByIndex(index)
    local TileSetData=nil;
    --local found=false;
    local idx=-1;
    for i=1, #TileSets do
        TileSetData=TileSets[i];
        --print ("i="..i..",   index="..index..",   TileSetData.minindex="..TileSetData.minindex..",  TileSetData.maxindex="..TileSetData.maxindex); 
        if(index>=TileSetData.minindex and index<=TileSetData.maxindex) then
            --found=true;
            idx=i;
            break;
        end
    end
    
    --if found then
        --print ("Found");
        
        return idx;
    --else
        --return -1;    
    --end
    
end

local function isWater(index)
    local found=false;
    for i=1, #WaterTileIndexes do
        if(WaterTileIndexes[i]==index) then
            found=true;
            break;
        end
    end
    
    return found;
end


local function CreateLevelLayer(LayerIndex,layer)
 
        local xOffset=16--100*32;
        local yOffset=16--20*32;
        
        local q_w_side=5
        local q_h_side=5
        local map_width=(CurrentMapData.width/q_w_side)--/2; -- 100/5=20     20/2=10
        local map_height=(CurrentMapData.height/q_h_side)--/2; -- 20/10=2     2/2=1
        local l=CurrentMapData.layers[LayerIndex];
        local d=l.data;
        local x,y;
        --print ("map_width: "..map_width);
        --print ("map_height: "..map_height);
        for i1 = 0, map_width-1 do
            for j1 = 0, map_height-1 do
                local quad = display.newGroup();
                quad.x = i1 * CurrentMapData.tilewidth*q_w_side+xOffset;
                quad.y = j1 * CurrentMapData.tileheight*q_h_side+yOffset;
                
                if(layer==1) then
                    CurrentMapFront:insert(quad);
                else
                    CurrentMapBack:insert(quad);
                end
                
                --tiles in quadrant
                for i2 = 0, q_w_side-1 do
                        for j2 = 0, q_h_side-1 do
                                
                                local tileIndex_x=i1*q_w_side             +i2;
                                local tileIndex_y=j1*q_h_side             +j2;
                                local tileindex=tileIndex_x+tileIndex_y*CurrentMapData.width+1;
                                
                                local v=d[tileindex];
                                if(v~=0)then
                                    --print ("tileindex="..tileindex.."   v="..v); 
                                    local TileSetIndex=getTileSetByIndex(v);
                                    
                                    --print (TileSetIndex); 
                                    
                                    if(TileSetIndex~=-1)then
                                        
                                        --print ("TileSetIndex="..TileSetIndex); 
                                        local TileSetData=TileSets[TileSetIndex];
                                        --print (TileSetData);    
                                        --print ("tileSetData.name="..TileSetData.name); 
                                        local vReal=v-TileSetData.minindex+1;
                                        
                                        local tileSet=TileSetData.tileSet;
                                        local tile = display.newImage( tileSet, vReal );
                                        --local tile = tileSet;--sprite.newSprite(tileSet);
                                        
                                        if isHd then --scale the highres spritesheet if you're on a retina device.
                                            tile.xScale = .5;
                                            tile.yScale = .5
                                        end
                                        
                                        
                                        --print ("vReal="..vReal..", TileSetIndex="..TileSetIndex); 
                                        local xOffset=0;
                                        local yOffset=0;
                                        local tsdn=TileSetData.name;
                                        
                                        if(tsdn=="trees_4x5") then
                                            xOffset=128*0.5-16;
                                            yOffset=-160*0.5+16;
                                        elseif(tsdn=="trees_3x4") then
                                            xOffset=96*0.5-16;
                                            yOffset=-128*0.5+16;

                                        elseif(tsdn=="store") then
                                            xOffset=160*0.5+16;
                                            yOffset=-160*0.5+16;
                                        elseif(tsdn=="walls") then
                                            xOffset=256*0.5-16;
                                            yOffset=-192*0.5+16;
                                        elseif(tsdn=="grass") then
                                            xOffset=64*0.5-16;
                                            yOffset=-64*0.5+16;
                                        elseif(tsdn=="Signs" or tsdn=="signs") then
                                            xOffset=28--64*0.5-16;
                                            yOffset=-30---64*0.5+16;
                                        elseif(tsdn=="water") then

                                            if(isWater(v)==false) then
                                                --print ("Water Index "..v.." added.");
                                                WaterTileIndexes[#WaterTileIndexes+1]=v;
                                            end

                                        end
                                        
                                        --tile.currentFrame = vReal;
                                        tile.x = i2 * CurrentMapData.tilewidth+xOffset;
                                        tile.y = j2 * CurrentMapData.tileheight+yOffset;
                                        quad:insert(tile);
                                        
                                        
                                    else
                                        print ("Tile Set Not Found!");
                                        return nil;
                                    end
                                     
                                end
                        end --for
                end --for
                
            end --for
            
        end --for
         
end

local function loadSpriteSheet(filename, unitWidth, unitHeight,imagewidth,imageheight)
        local newSpriteSheet;
        
        
        
        if not isHd then
                local w=imagewidth;
                local h=imageheight;
                local tw=unitWidth;
                local th=unitHeight;
                local number_of_tiles=w*h/tw/th;
                
                local sheetData2 = { width=unitWidth, height=unitHeight, numFrames=number_of_tiles, sheetContentWidth=w, sheetContentHeight=h }
                newSpriteSheet = graphics.newImageSheet(filename, sheetData2 )
                --newSpriteSheet.count=number_of_tiles;
                --newSpriteSheet = sprite.newSpriteSheet(filename, unitWidth, unitHeight)
        else
                local w=imagewidth*2;
                local h=imageheight*2;
                local tw=unitWidth*2;
                local th=unitHeight*2;
                local number_of_tiles=w*h/tw/th;
                --print ("f: "..filename);
                filename = string.sub(filename, 1, string.find(filename, "%.")-1).."-x2.png"
                --print ("filename="..filename);
                local sheetData2 = { width=tw, height=th, numFrames=number_of_tiles, sheetContentWidth=w, sheetContentHeight=h }
                --print ("loading imege: "..filename);
                newSpriteSheet = graphics.newImageSheet(filename, sheetData2 )
                --newSpriteSheet.count=number_of_tiles;
                --newSpriteSheet = sprite.newSpriteSheet(filename, unitWidth*2, unitHeight*2)
        end
        return newSpriteSheet
end

local function LoadTileSets()
    TileSets={};
    --isHd=false;
    
    for i=1, #CurrentMapData.tilesets do
        
        local tileset_info=CurrentMapData.tilesets[i];
        

            thegame.Loading.text = "Loading.9.2."..tileset_info.image
    
            --local number_of_tiles=tileset_info.imagewidth*tileset_info.imageheight/tileset_info.tilewidth/tileset_info.tileheight;
            local w=tileset_info.imagewidth;
            local h=tileset_info.imageheight;
            local tw=tileset_info.tilewidth;
            local th=tileset_info.tileheight;
            local number_of_tiles=math.floor((w/tw)*(h/th));
            --if isHd then
            --    number_of_tiles=math.floor((w/(tw*2))*(h/(th*2)));
            --end
            

            
            local tn= tileset_info.name;
            if tn=="user" or tn=="food" or tn=="coins" or tn=="boxes" or tn=="large_boxes" or tn=="door" or tn=="enemy"
                or tn=="bags" or tn=="balls" or tn=="flag" or tn=="shoes" or tn=="crystals" or tn=="gems" or tn=="long_bars" then
            
                TileSets[i]={minindex=min_index,maxindex=(min_index+number_of_tiles-1),name=tn};
        
            elseif tn=="bg0" then
               TileSets[i]={minindex=min_index,maxindex=(min_index+number_of_tiles-1),name=tn,image=tileset_info.image};
            else
                local tw=tileset_info.tilewidth
                local th=tileset_info.tileheight
                local w=tileset_info.imagewidth
                local h=tileset_info.imageheight
                local mySheet = loadSpriteSheet(tileset_info.image, tw,th ,w,h);
                
                --time=100,
                --[[]
                local sequenceData =
                {
                    name=tileset_info.name,
                    start=1,
                    count=number_of_tiles,
                    
                    loopCount = 0   -- Optional ; default is 0 (loop indefinitely)
                    --loopDirection = "bounce"    -- Optional ; values include "forward" or "bounce"
                }
]]
                --local tileSetSprites = display.newSprite(mySheet, sequenceData );
                --local tileSetSprites = sprite.newSpriteSet( mySheet, 1, number_of_tiles)
                
                
                --mySheet
                TileSets[i]={minindex=min_index,maxindex=(min_index+number_of_tiles-1),tileSet=mySheet,name=tileset_info.name};
                --TileSets[i]={minindex=min_index,maxindex=(min_index+number_of_tiles-1),tileSet=tileSetSprites,name=tileset_info.name};
            end
            
        
            min_index=min_index+number_of_tiles;

       
       
    end
end

local function drawLines(LayerIndex)
    local l=CurrentMapData.layers[LayerIndex];
    local o=l.objects;
    local d=1
    
    local dn=2
    local e=0.1
    local f=0.4

    local CollisionFilter = { categoryBits = 1, maskBits = 3 } 
    local CollisionFilterClose = { categoryBits = 4, maskBits = 3 } 

    for i=1, #o do
        if i==i then
        local p=o[i].polyline;
        local shape={}
        local xOffset=0--o[i].x*d
        local yOffset=0--o[i].y*d
        --local star = display.newLine( o[i].x*d+xOffset,o[i].y*d+yOffset,p[1].x*d+xOffset,p[1].y*d+yOffset);
        local star = display.newLine( p[1].x*d+xOffset,p[1].y*d+yOffset,p[2].x*d+xOffset,p[2].y*d+yOffset);
        
        
        if(#p>2) then
            for j=3, #p do
                star:append( p[j].x*d+xOffset,p[j].y*d+yOffset);
            end
        end
        local c=1
        --print ("#p="..#p)
        for j=1, #p-1 do
                shape[c]=p[j].x*d+xOffset
                shape[c+1]=p[j].y*d+yOffset
                c=c+2
                --print ("p[j].x="..p[j].x..",  p[j].y="..p[j].y)
        end
        
        star.myName="Wall";
        
        star:setStrokeColor( 255, 102, 102, 0 )
        --star.width = 3 
        CurrentMapWalls:insert(star);
        star.x=o[i].x*d
        star.y=o[i].y*d
        physics.addBody (star, "static" ,{bounce = e, density=dn, friction = f, shape=shape, filter=CollisionFilter })
        
        end
    end
  
  
end

--local function LoadSprites(LayerIndex)
  --  world.WorldSprites={}
--end


function findSpriteByTitle(self,title)
			for i,line in ipairs(sprite_collection.SpriteColection) do
                            local s=sprite_collection.SpriteColection[i]
                            if s.title==title then
				return i
			end
		end
		return -1
end


function AddDoor(x,y)
    
    --world.NumberOfItems=world.NumberOfItems+1;
    local i=#world.WorldSprites+1;
    world.WorldSprites[i]=display.newRect(x,y, 32,64) ;
    world.WorldSprites[i]:setFillColor(0,0,0, 0.1);
    
    --ReferencePointFixed
    --world.WorldSprites[i]:set ReferencePoint( display.CenterCenterReferencePoint)
    game:insert(world.WorldSprites[i])
    world.WorldSprites[i].x=x;
    world.WorldSprites[i].y=y;
    world.WorldSprites[i].bodyIndex=i;
    world.WorldSprites[i].typeIndex=-1;
    world.WorldSprites[i].myName="door";
    
    --local CollisionFilter = { categoryBits = 1, maskBits = 3 } 
    --local CollisionFilterClose = { categoryBits = 4, maskBits = 3 } 
 
    --physics.addBody (world.WorldSprites[i], "kinematic", {filter=CollisionFilterClose});
    
end


local function AddEnemy(x,y)
    local rotation=0;
    local r=11
    local f=1
    local s=1
    local b=0.1
    local SpriteIndex=#world.WorldEnemies+1;
    
    
    
    
    
    
    --world.WorldEnemies[SpriteIndex]=display.newImage( newSpriteSheet, 1);
    world.WorldEnemies[SpriteIndex]=display.newCircle( x, y, r);
    world.WorldEnemies[SpriteIndex]:setFillColor( 1,0,0,0,0 )
    --world.WorldEnemies[SpriteIndex].strokeWidth = 5
    --world.WorldEnemies[SpriteIndex]:setStrokeColor( 1, 0, 0 )
    --world.WorldSprites[SpriteIndex]=display.newImageRect( "src/images/sprites/"..s.image,s.width,s.height  )    
        
    CurrentMapBack:insert(world.WorldEnemies[SpriteIndex])
    world.WorldEnemies[SpriteIndex].x=x;
    world.WorldEnemies[SpriteIndex].y=y;
    world.WorldEnemies[SpriteIndex].rotation=rotation--math.random(3)-2;
    world.WorldEnemies[SpriteIndex].radius=r
    world.WorldEnemies[SpriteIndex].bodyIndex=SpriteIndex
    --world.WorldEnemies[SpriteIndex].typeIndex=index
    --world.WorldEnemies[SpriteIndex].typeIndex=-10000; -- enemy
    world.WorldEnemies[SpriteIndex].myName="enemy";
        
    physics.addBody (world.WorldEnemies[SpriteIndex], {bounce = b, density=s, friction = f, radius=r})
    
    
    
    
    local sp=enemy.Sprites[1];
    local myAnimation = display.newSprite(sp.imageSheet, sp.sequenceData)
    myAnimation.x = x;
    myAnimation.y = y-5;
    CurrentMapBack:insert(myAnimation);
    
    world.WorldEnemies[SpriteIndex].animation=myAnimation;
    world.WorldEnemies[SpriteIndex].state=-1;
    --world.WorldEnemies[SpriteIndex].oldState=-1;
    
    
    --world.WorldEnemies[SpriteIndex].animation:play();
    
    
    
end

function AddBody(self, BodyTitle,x,y,rotation,body_name)
    local index=findSpriteByTitle(nil,BodyTitle);
    
    if index~=-1 then 

        local s=sprite_collection.SpriteColection[index];

    
        local SpriteIndex=#world.WorldSprites+1;
        world.WorldSprites[SpriteIndex]=display.newImageRect( "src/images/sprites/"..s.image,s.width,s.height  )    

    
        --ReferencePointFixed
        --world.WorldSprites[SpriteIndex]:set ReferencePoint( display.CenterCenterReferencePoint)
        CurrentMapBack:insert(world.WorldSprites[SpriteIndex])
        world.WorldSprites[SpriteIndex].x=x;
        world.WorldSprites[SpriteIndex].y=y;
        world.WorldSprites[SpriteIndex].rotation=rotation--math.random(3)-2;
        world.WorldSprites[SpriteIndex].radius=s.radius
        world.WorldSprites[SpriteIndex].bodyIndex=SpriteIndex
        world.WorldSprites[SpriteIndex].typeIndex=index
        world.WorldSprites[SpriteIndex].myName=body_name;
        
        --world.WorldSprites[SpriteIndex].used=false
    
    
        if(s.fillcolor~=nil and #s.fillcolor==4) then
            local f=s.fillcolor;
            world.WorldSprites[SpriteIndex]:setFillColor(f[1],f[2],f[3],f[4]);
        end
    
    
        if(s.radius>0) then
            world.WorldSprites[SpriteIndex].weight=math.pi*s.radius*2*s.density;
            physics.addBody (world.WorldSprites[SpriteIndex], {bounce = s.bounce, density=s.density, friction = s.friction, radius=s.radius})
        else
            world.WorldSprites[SpriteIndex].weight=x*y*s.density;
            if s.shape~=nil then
            --,filter=CollisionFilter
            physics.addBody (world.WorldSprites[SpriteIndex], {shape=s.shape, bounce = s.bounce, density=s.density, friction = s.friction})
            
            
            elseif s.advancedShape~=nil then
                    local p={}
                    print ("s.friction="..s.friction)
                    for i=1,#s.advancedShape do
                        --,filter=CollisionFilter
                        p[i]={shape=s.advancedShape[i], bounce = s.bounce, density=s.density, friction = s.friction};
                    end
                    if(#p==2) then 
                        physics.addBody (world.WorldSprites[SpriteIndex],"dynamic", p[1],p[2]);
                    elseif(#p==3) then 
                        physics.addBody (world.WorldSprites[SpriteIndex],"dynamic", p[1],p[2],p[3]);
                    elseif(#p==4) then 
                        physics.addBody (world.WorldSprites[SpriteIndex],"dynamic", p[1],p[2],p[3],p[4]);
                    end

            else
                        --, filter=CollisionFilter
                    if(body_name=="flag") then
                        physics.addBody (world.WorldSprites[SpriteIndex], "static", {bounce = s.bounce, density=s.density, friction = s.friction})        
                    else
                        physics.addBody (world.WorldSprites[SpriteIndex], {bounce = s.bounce, density=s.density, friction = s.friction})        
                    end
            
            end
        end --if(s.radius>0) then		                                    

    
        return SpriteIndex;
    else
        return -1;
    end

    
end







local function SetBodyPositions(LayerIndex)
    
        local l=CurrentMapData.layers[LayerIndex];
        local d=l.data;
        local x,y;
        for j = 0, CurrentMapData.height-1 do
                        for i = 0, CurrentMapData.width-1 do

                                local tileindex=i+j*CurrentMapData.width+1;
                                
                                local v=d[tileindex];
                                if(v~=0)then

                                    local TileSetIndex=getTileSetByIndex(v);
                                    
                                    if(TileSetIndex~=-1)then
                                        
                                        
                                        local TileSetData=TileSets[TileSetIndex];
                                        
                                        x = i * CurrentMapData.tilewidth+15;
                                        y = j * CurrentMapData.tileheight+25;
                                        
                                        local vReal=v-TileSetData.minindex+1;
                                        if(TileSetData.name=="food") then
                                            
                                        
                                            if(vReal==1) then
                                                AddBody(nil, "Apple",x,y-4,0,"food");
                                            elseif(vReal==2) then
                                                AddBody(nil, "Cheese",x,y-4,0,"food");
                                            elseif(vReal==3) then
                                                AddBody(nil, "Peach",x,y-8,0,"food");
                                            elseif(vReal==4) then
                                                AddBody(nil, "Pinapple",x,y-4,0,"food");
                                            elseif(vReal==5) then
                                                AddBody(nil, "Strawberry",x,y-4,0,"food");
                                            elseif(vReal==6) then
                                                AddBody(nil, "Tomato",x,y-8,0,"food");
                                            elseif(vReal==7) then
                                                AddBody(nil, "Watermelon",x,y-11,0,"food");
                                            end
                                            

                                        elseif(TileSetData.name=="coins") then
                                            
                                        
                                            if(vReal==1) then
                                                AddBody(nil, "CoinGold",x,y-7,0,"coin");
                                            elseif(vReal==2) then
                                                AddBody(nil, "CoinSilver",x,y-7,0,"coin");
                                            elseif(vReal==3) then
                                                AddBody(nil, "CoinBronze",x,y-7,0,"coin");
                                            end
                                            
                                            

                                            
                                        elseif(TileSetData.name=="balls") then
                                       
                                            if(vReal==1) then
                                                AddBody(nil, "Bascketball",x,y,0,"ball");
                                            elseif(vReal==2) then
                                                AddBody(nil, "Football",x,y,0,"ball");
                                            elseif(vReal==3) then
                                                AddBody(nil, "TennisBall",x,y,0,"ball");
                                            elseif(vReal==4) then
                                                AddBody(nil, "Toyball",x,y,0,"ball");
                                            end
                                        
                                        elseif(TileSetData.name=="boxes") then
                                            
                                        
                                            if(vReal==1) then
                                                AddBody(nil, "WoodenBox",x,y-8,0,"box");
                                            elseif(vReal==2) then
                                                AddBody(nil, "TNTBox",x,y-8,0,"box");
                                            elseif(vReal==3) then
                                                AddBody(nil, "SteelBox",x,y-8,0,"box");
                                            elseif(vReal==4) then
                                                AddBody(nil, "ClayBox",x,y-8,0,"box");
                                            elseif(vReal==5) then
                                                AddBody(nil, "StoneBox",x,y-8,0,"box");
                                            elseif(vReal==6) then
                                                AddBody(nil, "GlassBox",x,y-8,0,"box");
                                            elseif(vReal==7) then
                                                AddBody(nil, "MetalBox",x,y-8,0,"box");
                                            end
                                        elseif(TileSetData.name=="long_bars") then
                                            if(vReal==1) then
                                                AddBody(nil, "WoodenBar_1x5",x,y-42-32,0,"longbar");
                                            elseif(vReal==2) then
                                                AddBody(nil, "WoodenBar_1x5",x+64,y-10,90,"longbar");-- horizontal
                                            elseif(vReal==4) then
                                                AddBody(nil, "WoodenBar_1x4",x,y-58,0,"longbar");
                                            elseif(vReal==5) then
                                                AddBody(nil, "WoodenBar_1x4",x+48,y-10,90,"longbar");-- horizontal
                                            elseif(vReal==7) then
                                                AddBody(nil, "WoodenBar_1x3",x,y-42,0,"longbar");
                                            elseif(vReal==8) then
                                                AddBody(nil, "WoodenBar_1x3",x+32,y-10,90,"longbar"); -- horizontal
                                            elseif(vReal==9) then
                                                AddBody(nil, "WoodenBar_05x4",x,y-26-32,0,"longbar");
                                            elseif(vReal==10) then
                                                AddBody(nil, "WoodenBar_05x4",x+48,y-10,90,"longbar");-- horizontal
                                            elseif(vReal==11) then
                                                AddBody(nil, "MetalBar_4x1",x,y-58,-90,"longbar"); -- vertical
                                            elseif(vReal==12) then
                                                AddBody(nil, "MetalBar_4x1",x+16+32,y-10,0,"longbar");
                                            elseif(vReal==13) then
                                                AddBody(nil, "MetalBar_3x1",x,y-42,-90,"longbar");
                                            elseif(vReal==14) then
                                                AddBody(nil, "MetalBar_3x1",x+32,y-10,0,"longbar");
                                            elseif(vReal==16) then
                                                AddBody(nil, "MetalBar_2x1",x,y-26,-90,"longbar");
                                            elseif(vReal==17) then
                                                AddBody(nil, "MetalBar_2x1",x-16+32,y-10,0,"longbar");
                                            elseif(vReal==18) then
                                                AddBody(nil, "Log_4x1",x,y-57,-90,"longbar"); -- vertical
                                            elseif(vReal==19) then
                                                AddBody(nil, "Log_4x1",x+57-10,y-10,0,"longbar");
                                                
                                                
                                            elseif(vReal==15) then
                                                AddBody(nil, "LargeRoundRock",x+16,y-26,0,"longbar");
                                            elseif(vReal==20) then
                                                AddBody(nil, "HugeRoundRock",x+47,y-57,0,"longbar");
                                            end    
                                                
                                        elseif(TileSetData.name=="large_boxes") then
                                            
                                        
                                            if(vReal==1) then
                                                AddBody(nil, "LargeBox",x+16,y-16-8,0,"box");
                                            end
                                        
                                        elseif(TileSetData.name=="bags") then
                                            if(vReal==1) then
                                                AddBody(nil, "SmallBackpack",x+12,y-12,0,"bag");
                                            elseif(vReal==2) then
                                                AddBody(nil, "NormalBackpack",x+16,y-17,0,"bag");
                                            elseif(vReal==3) then
                                                AddBody(nil, "ClosedBasket",x+15,y-17,0,"bag");
                                                
                                                
                                            end    
                                        
                                        elseif(TileSetData.name=="shoes") then
                                            if(vReal==1) then
                                                AddBody(nil, "Shoes",x,y-6,0,"shoes");
                                            elseif(vReal==2) then
                                                AddBody(nil, "Boots",x,y-6,0,"shoes");
                                            elseif(vReal==3) then
                                                AddBody(nil, "Trainers",x,y-6,0,"shoes");
                                                
                                                
                                            end   
                                        
                                        elseif(TileSetData.name=="crystals" or TileSetData.name=="gems") then
                                            if(vReal==1) then
                                                AddBody(nil, "Ruby",x,y-6,0,"gem");
                                            elseif(vReal==2) then
                                                AddBody(nil, "Emerald",x,y-6,0,"gem");
                                            elseif(vReal==3) then
                                                AddBody(nil, "Topaz",x,y-6,0,"gem");
                                            elseif(vReal==4) then
                                                AddBody(nil, "Sapphire",x,y-6,0,"gem");
                                            
                                            end   
                                            
                                        elseif(TileSetData.name=="door") then
                                            AddDoor(x,y-28);
                                            
                                        elseif( TileSetData.name=="flag") then
                                            if(vReal==1) then
                                                local fy=y-26;
                                                AddBody(nil, "Flag",x+12,fy,0,"flag");
                                                thegame.FlagImage=display.newImageRect( "src/images/sprites/flag.png",32,32);
                                                thegame.FlagImage.anchorY=0;
                                                --thegame.FlagImage:set ReferencePoint( display.TopCenterReferencePoint);
                                                game:insert(thegame.FlagImage);
                                                thegame.FlagImage.x=x+12;
                                                thegame.FlagImage.y=fy-33;
                                                
  
                                            end    
                                            
                                        end

                                    end
                                                        
                                end
                            
                            
                        end
        end
    
end


local function SetBackgroundImage(LayerIndex,Layer,dx)
    local l=CurrentMapData.layers[LayerIndex];
        local d=l.data;
        local x,y;
        for j = 0, CurrentMapData.height-1 do
                        for i = 0, CurrentMapData.width-1 do

                                local tileindex=i+j*CurrentMapData.width+1;
                                
                                local v=d[tileindex];
                                if(v~=0)then
                                    --print ("tileindex="..tileindex.."   v="..v); 
                                    local TileSetIndex=getTileSetByIndex(v);
                                    
                                    --print ("mouse tile="..TileSetIndex); 
                                    
                                    if(TileSetIndex~=-1)then
                                        local TileSetData=TileSets[TileSetIndex];
                                        x = i * CurrentMapData.tilewidth--+15;
                                        y = j * CurrentMapData.tileheight--+36;
                                        local vReal=v-TileSetData.minindex+1;
                                        
                                        if dx==0 then
                                            setBackground(TileSetData.image,Layer,dx);
                                        else
                                            
                                            local tileSet=TileSetData.tileSet;
                                            
                                            local bgCount=#background.bg+1;
                                            
                                            
                                            background.bg[bgCount] = display.newImage( tileSet, vReal );
                                            
                                            --background.bg[bgCount].currentFrame = vReal;
                                            background.bg[bgCount].anchorX=0;
                                            background.bg[bgCount].anchorY=background.bg[bgCount].height;
                                            --background.bg[bgCount]:set ReferencePoint( display.BottomLeftReferencePoint)
                                                                                                                                        
                                                                                                                                        
                                            local xOffset=0;
                                            local yOffset=0;
                                                                                            
                                            if Layer==0 then
                                                
                                                
                                                --local n=TileSetData.name;
                                                if(TileSetData.name=="cliff") then
                                                    xOffset=-48;
                                                    --yOffset=16;
                                                end
                                                
                                                --[[
                                                if(dx==0.4) then
                                                        background.bg[bgCount]:setFillColor(0,0,50, 170);
                                                elseif(dx==0.5) then
                                                    background.bg[bgCount]:setFillColor(0,0,50, 140);
                                                elseif(dx==0.6) then
                                                    background.bg[bgCount]:setFillColor(0,0,50, 110);
                                                elseif(dx==0.7) then
                                                    background.bg[bgCount]:setFillColor(0,0,50, 90);
                                                elseif(dx==0.8) then
                                                    background.bg[bgCount]:setFillColor(0,0,50, 60);
                                                elseif(dx==0.9) then
                                                    background.bg[bgCount]:setFillColor(0,0,250, 10);
                                                end
                                                --]]
                                                
                                                
                                                if isHd then --scale the highres spritesheet if you're on a retina device.
                                            
                                                    background.bg[bgCount].xScale = 0.5;
                                                    background.bg[bgCount].yScale = 0.5;
                                                
                                                    background.bg[bgCount].x = x+background.bg[bgCount].width*0.25+xOffset;
                                                else
                                                    background.bg[bgCount].xScale = 1;
                                                    background.bg[bgCount].yScale = 1;
                                                
                                                    background.bg[bgCount].x = x+background.bg[bgCount].width*0.5+xOffset;
                                                end
                                           
                                                background.bg[bgCount].y = y+36+yOffset---background.bg[bgCount].height*0.25;
                                            else
                                                

                                                if isHd then --scale the highres spritesheet if you're on a retina device.
                                            
                                                    background.bg[bgCount].xScale = 0.5;
                                                    background.bg[bgCount].yScale = 0.5;
                                                
                                                    background.bg[bgCount].x = x+background.bg[bgCount].width*0.25+30+xOffset;
                                                else
                                                    background.bg[bgCount].xScale = 1;
                                                    background.bg[bgCount].yScale = 1;
                                                
                                                    background.bg[bgCount].x = x+background.bg[bgCount].width*0.5+30+xOffset;
                                                end
                                           
                                                background.bg[bgCount].y = y+32---background.bg[bgCount].height*0.25;
                                            end
                                            
                                            
                                            
                                            background.bg[bgCount].dx = dx;
                                            background.bg[bgCount].originalX=background.bg[bgCount].x;
                                            background.bg[bgCount].originalY=background.bg[bgCount].y;
                                            background.bg[bgCount].layer=Layer
            
                                            if(Layer==0) then
                                                thegame.background_back:insert( background.bg[bgCount])
                                            else
                                                thegame.background_front:insert( background.bg[bgCount])
                                            end
                                            -- -----------------------
                                            
                                            
                                            
                                            
                                            
                                        end --if dx==0 then
                                        
                                    end -- if(TileSetIndex~=-1)then
                                                        
                                end --if(v~=0)then
                            
                            
                        end -- for i = 0, CurrentMapData.width-1 do
        end --for j = 0, CurrentMapData.height-1 do
end

local function SetUserPosition(LayerIndex)
        
        local l=CurrentMapData.layers[LayerIndex];
        local d=l.data;
        local x,y;
        for j = 0, CurrentMapData.height-1 do
                        for i = 0, CurrentMapData.width-1 do

                                local tileindex=i+j*CurrentMapData.width+1;
                                
                                local v=d[tileindex];
                                if(v~=0)then
                                    --print ("tileindex="..tileindex.."   v="..v); 
                                    local TileSetIndex=getTileSetByIndex(v);
                                    
                                    --print ("mouse tile="..TileSetIndex); 
                                    
                                    if(TileSetIndex~=-1)then
                                        
                                        local TileSetData=TileSets[TileSetIndex];
                                        local tn=TileSetData.name;
                                        
                                        x = i * CurrentMapData.tilewidth+15;
                                        y = j * CurrentMapData.tileheight+25;
                                        
                                        if tn=="user" then
                                            local theMouse=mousecharacter:CreateMouse(x,y, "manny")
                                            game:insert(theMouse)
                                        
                                            mousecharacter:TurnCharacter(-1,true)
                                        elseif tn=="enemy" then
                                            -- Add enemy unit
                                            AddEnemy(x,y);
                                        end
                                    
                                    end
                                                        
                                end
                            
                            
                        end
        end
        




end


function CheckIfInWater(self,x,y)
    local floor=math.floor;
    local tileIndex_x=floor((x)/32);
    
    local tileIndex_y=floor((y)/32)-1;
    
    
    
    if tileIndex_x<=CurrentMapData.width and tileIndex_x>0 and tileIndex_y<CurrentMapData.height and tileIndex_y>0 then
        --print("tileIndex_y="..tileIndex_y..", CurrentMapData.height="..CurrentMapData.height);
    
        local tileindex=tileIndex_x+tileIndex_y*CurrentMapData.width+1;
    
        local l=CurrentMapData.layers[MapBGBackLayerIndex];
        local d=l.data;
        
        local v=d[tileindex];
        if v~=0 then
            return isWater(v);
            --if(isWater(v)) then
              --  print ("Mouse in water");
            --end
            --print("tileindex="..tileindex..", v="..v);    
        end
        
    
    end
                                
end
    
    --StoreOperatorImage="operator_bear.png";
            --StoreOperatorImage="operator_lion.png";
            --StoreOperatorImage="operator_squirrel_girl.png";
            --StoreOperatorImage="operator_squirrel_scotty.png";
            
local function LoadLevelData(levelIndex)
    min_index=1;
    ShopInventory={}
    local levelData =nil;
    if levelIndex==1 then
            levelData = require("level1")
            
            
        elseif levelIndex==2 then
            levelData = require("level2")
        elseif levelIndex==3 then
            levelData = require("level3")
        

        elseif levelIndex==4 then
            levelData = require("level4")
                        ShopInventory={
                {"Strawberry",50,-1},
                {"Apple",60,-1},
                {"SmallBackpack",100,-1},
                
              
                {"Pinapple",68,-1},
                {"Pinapple",50,-1},
                {"Watermelon",50,-1},
                
                {"Cheese",50,-1}
                
                
                };
            StoreOperatorImage="operator_squirrel_scotty.png";

        elseif levelIndex==5 then
            levelData = require("level5")
            ShopInventory={
                {"TennisBall",50,-1},
                {"TennisBall",60,-1},
                {"SmallBackpack",100,-1},
                
              
                {"TennisBall",68,-1},
                {"TennisBall",50,-1},
                {"Watermelon",50,-1},
                
                {"Cheese",50,-1}
                
                
            };
            StoreOperatorImage="operator_squirrel_wild.png";
            
        elseif levelIndex==6 then
            levelData = require("level6")
            StoreOperatorImage="operator_squirrel_girl.png";
            ShopInventory={
                {"Shoes",50,-1},
                {"Football",60,-1},
                {"Football",100,-1},
                
              
                {"Football",68,-1},
                {"Cheese",50,-1},
                {"Cheese",50,-1},
                
                {"NormalBackpack",50,-1}
                
                
                };
        elseif levelIndex==7 then
            levelData = require("level7")
            StoreOperatorImage="operator_bear.png";
            ShopInventory={
            {"Cheese",50,-1},
                {"Cheese",50,-1},
                {"Shoes",40,-1},
                {"Boots",80,-1},
                {"ClosedBasket",100,-1},
                {"NormalBackpack",50,-1},
                {"NormalBackpack",50,-1}
                
                };
        end
        
        CurrentMapData= levelData:LevelData();
end



function CreateLevel(self, levelIndex)
        --levelIndex=6
        WaterTileIndexes={};
        determineHd();
    
        thegame.Loading.text = "Loading.9.1"
        direction=1
	--world.BGSprites={}
        world.WorldWalls={}
        PossibleBody={}
        MusicTheme=1
        
        
        enemy:loadEnemySprites();
        
        LoadLevelData(levelIndex);
        
        GameScreenWidth=CurrentMapData.width*CurrentMapData.tilewidth;
        game.width=GameScreenWidth;
        
        GameScreenHeight=CurrentMapData.height*CurrentMapData.tileheight;
        game.height=GameScreenHeight;
    
        thegame.Loading.text = "Loading.9.2"
        LoadTileSets();
        CurrentMapFront = display.newGroup()
        CurrentMapBack = display.newGroup()
        CurrentMapWalls = display.newGroup()
        
        for i=1, #CurrentMapData.layers do
            local l=CurrentMapData.layers[i];
            local t=l.type;
            if(t == "tilelayer") then
                if(l.name == "bg_back_0") then
                    SetBackgroundImage(i,0,0);
                elseif(l.name == "bg_back_1") then
                    SetBackgroundImage(i,0,0.4);
                elseif(l.name == "bg_back_2") then
                    SetBackgroundImage(i,0,0.5);
                elseif(l.name == "bg_back_3") then
                    SetBackgroundImage(i,0,0.6);
                elseif(l.name == "bg_back_3") then
                    SetBackgroundImage(i,0,0.7);
                elseif(l.name == "bg_back_4") then
                    SetBackgroundImage(i,0,0.8);
                elseif(l.name == "bg_back_5") then
                    SetBackgroundImage(i,0,0.9);
                end
            end
        end
        
        --world:SetBackground(0);
        
        
        
        
        
        thegame.Loading.text = "Loading.9.3"
        
        world.WorldEnemies={}
        world.WorldSprites={}
        
        
        thegame.Loading.text = "Loading.9.4"
        
        local map_layer=0;

        
        
        for i=1, #CurrentMapData.layers do
            --i=#CurrentMapData.layers-i_+1;
            local l=CurrentMapData.layers[i];
            local t=l.type;
            --print ("l.name="..l.name);
            if(t == "tilelayer") then
                local n=l.name
                
                if(n == "Mouse") then
                    -- look for user coordinates
                    SetUserPosition(i);
                    
                elseif(n == "Bodies") then
                    SetBodyPositions(i);
                elseif(n~="bg_back_0" and n~="bg_back_1" and n~="bg_back_2" and n~="bg_back_3" and n~="bg_back_4" and n~="bg_back_5" and n~="bg_front_1" and n~="bg_front_2" and n~="bg_front_3" and n~="bg_front_4" and n~="bg_front_5"
                    ) then
                    -- draw layer
                    if(l.name=="bg_back_z") then
                        MapBGBackLayerIndex=i;
                    end
                    if(l.name~="bg_back_z" and l.name~="bg_back_z2") then
                        map_layer=1;
                    end
                    
                    CreateLevelLayer(i,map_layer);
                    
                    if(map_layer==1) then
                        CurrentMapFront.x=0
                        CurrentMapFront.y=0
                        game:insert(CurrentMapFront);
                    else
                        CurrentMapBack.x=0
                        CurrentMapBack.y=0
                        game:insert(CurrentMapBack);
                    end
                    
                end
                
            elseif(t== "objectgroup") then
                --physics
                drawLines(i);
            end
        end
        
        world:addTouchListenersToSpecialBodies(nil);
        --world:addTouchListenersToEnemy(nil);
        enemy:addSensors();
        
        

        
        
        
        
        --thegame.Loading.text = "Loading.9.5"
        --game.width=CurrentMapData.tilewidth*CurrentMapData.width;
        --game.height=CurrentMapData.tileheight*CurrentMapData.height;
        
        --thegame.Loading.text = "Loading.9.6"
        
        CurrentMapWalls.x=0--100
        CurrentMapWalls.y=0---(CurrentMapData.tileheight*CurrentMapData.height)+635
        game:insert(CurrentMapWalls);
        thegame.Loading.text = "Loading.9.7"
        
        UpdateMap();
        thegame.Loading.text = "Loading.9.8"
        
        
        background_back.xScale=1;
        background_back.yScale=1;
        --background_front.xScale=1;
        --background_front.yScale=1;
        
        thegame:AddSoundListeners()
end


function AddFronBackground(self)
           
        for i=1, #CurrentMapData.layers do
            local l=CurrentMapData.layers[i];
            local t=l.type;
            if(t == "tilelayer") then
                if(l.name == "bg_front_1") then
                    SetBackgroundImage(i,1,1.02);
                elseif(l.name == "bg_front_2") then
                    SetBackgroundImage(i,1,1.04);
                elseif(l.name == "bg_front_3") then
                    SetBackgroundImage(i,1,1.06);
                elseif(l.name == "bg_front_3") then
                    SetBackgroundImage(i,1,1.08);
                elseif(l.name == "bg_front_4") then
                    SetBackgroundImage(i,1,1.1);
                elseif(l.name == "bg_front_5") then
                    SetBackgroundImage(i,1,1.12);
                end
            end
        end 
end
