--
-- Project: Sounds
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

PlaySound=true
PlayMusic=true


local winSounds={}
--loseSounds={}
local tryagainSounds={}

--taskSounds={}
local bodyFlySounds={}
local mousePainSounds={}
local mouseEatSounds={}
local ZipSounds={}
local mouseJumpSounds={}
local WaterSplashSounds={}
local CoinSounds={}
local userDropSounds={}


local bodyHitSounds_Wood={}
local bodyHitSounds_Metal={}
local bodyHitSounds_Soft={}
local bodyHitSounds_Coin={}
local bodyHitSounds_Ball={}

BackGroundMusicChannel=-1
musicThemes={}

local function doPlaySoundByIndex(SoundList,volume,index)
    if(PlaySound and #SoundList>0) then      
                            
        local availableChannel = audio.findFreeChannel()
        if availableChannel>0 then
            audio.setVolume( volume, { channel=availableChannel } )
            audio.play( SoundList[index], { channel=availableChannel } )
        end
    end
end

local function doPlaySound(SoundList,volume)
    if(PlaySound and #SoundList>0) then      
                            
        local availableChannel = audio.findFreeChannel()
        if availableChannel>0 then
            local index=math.random( #SoundList)
            audio.setVolume( volume, { channel=availableChannel } )
            audio.play( SoundList[index], { channel=availableChannel } )
        end
    end
end

function PlayZipSound(self, index)
    doPlaySoundByIndex(ZipSounds,0.6,index);
end

function PlayEatingSound(self)
    doPlaySound(mouseEatSounds,0.6);
end

function PlayPainSound(self)
    doPlaySound(mousePainSounds,0.6);
end

function PlayWaterSplashSound(self,index)
    doPlaySoundByIndex(WaterSplashSounds,0.6,index);
end

function PlayWinSoundsSound(self)
    doPlaySound(winSounds,0.6);
end

function PlayCoinSound(self)
    doPlaySound(CoinSounds,0.6);
end

function PlayUserDropSound(self)
    doPlaySound(userDropSounds,0.1);
end

function PlayMouseJumpSound(self,volume)
    doPlaySound(mouseJumpSounds,volume);
end

function PlayTryAgainSound(self,index)
    doPlaySoundByIndex(tryagainSounds,0.5,index);
end

function PlayBodyFlySound(self)
    doPlaySound(bodyFlySounds,1);
end


function PlayBodyHitSound(self,s,volume)
    local subtype=s.subtype;
    if(subtype=="food")then
        doPlaySound(bodyHitSounds_Soft,volume);
    elseif(subtype=="coin")then
        doPlaySound(bodyHitSounds_Coin,volume);
    elseif(subtype=="box")then
        if s.hitsound==1 then
            doPlaySound(bodyHitSounds_Wood,volume);
        elseif s.hitsound==2 then
            doPlaySound(bodyHitSounds_Metal,volume);
        elseif s.hitsound==3 then
            --rock
            doPlaySound(bodyHitSounds_Soft,volume);
        end
        
    elseif(subtype=="longbar")then
        if s.hitsound==1 then
            doPlaySound(bodyHitSounds_Wood,volume);
        elseif s.hitsound==2 then
            doPlaySound(bodyHitSounds_Metal,volume);
        elseif s.hitsound==3 then
            --rock
            doPlaySound(bodyHitSounds_Soft,volume);
        end

    elseif(subtype=="rock")then
        doPlaySound(bodyHitSounds_Soft,volume);
    elseif(subtype=="bag")then
        doPlaySound(bodyHitSounds_Soft,volume);
    elseif(subtype=="flag")then
        doPlaySound(bodyHitSounds_Soft,volume);
    elseif(subtype=="shoes")then
        doPlaySound(bodyHitSounds_Soft,volume);
    elseif(subtype=="ball")then
        doPlaySound(bodyHitSounds_Ball,volume);
    elseif(subtype=="gems")then
        doPlaySound(bodyHitSounds_Coin,volume*0.2);
    end
end



function loadSounds(self)
    local fileFormat=".wav";


    musicThemes[1]="src/music/012424306-swaggering-pirate-30-sec"..fileFormat
    
    winSounds[1]= audio.loadSound("src/sounds/fanfare"..fileFormat)
    
    WaterSplashSounds[1]= audio.loadSound("src/sounds/water-splash"..fileFormat)
    WaterSplashSounds[2]= audio.loadSound("src/sounds/goop-sound"..fileFormat)
    
    CoinSounds[1]= audio.loadSound("src/sounds/coin"..fileFormat)
    --loseSounds[1]= audio.loadSound("src/sounds/lost"..fileFormat)
    

    tryagainSounds[1]= audio.loadSound("src/sounds/overeat"..fileFormat)
    tryagainSounds[2]= audio.loadSound("src/sounds/drown"..fileFormat)


    

    bodyFlySounds[1]= audio.loadSound("src/sounds/sounds_fly_by_1"..fileFormat)
    bodyFlySounds[2]= audio.loadSound("src/sounds/sounds_fly_by_2"..fileFormat)
    bodyFlySounds[3]= audio.loadSound("src/sounds/sounds_fly_by_3"..fileFormat)
    bodyFlySounds[4]= audio.loadSound("src/sounds/sounds_fly_by_4"..fileFormat)
    bodyFlySounds[5]= audio.loadSound("src/sounds/sounds_fly_by_5"..fileFormat)
    bodyFlySounds[6]= audio.loadSound("src/sounds/sounds_fly_by_6"..fileFormat)
    

    bodyHitSounds_Wood[1]=audio.loadSound("src/sounds/wood1"..fileFormat)
    bodyHitSounds_Wood[2]=audio.loadSound("src/sounds/wood2"..fileFormat)
    bodyHitSounds_Wood[3]=audio.loadSound("src/sounds/wood3"..fileFormat)
    bodyHitSounds_Wood[4]=audio.loadSound("src/sounds/wood4"..fileFormat)
    bodyHitSounds_Wood[5]=audio.loadSound("src/sounds/wood5"..fileFormat)
    bodyHitSounds_Wood[6]=audio.loadSound("src/sounds/wood6"..fileFormat)
    bodyHitSounds_Wood[7]=audio.loadSound("src/sounds/wood7"..fileFormat)
    bodyHitSounds_Wood[8]=audio.loadSound("src/sounds/sounds_wood_hit_1"..fileFormat)
    
    bodyHitSounds_Metal[1]=audio.loadSound("src/sounds/metal1"..fileFormat)
    bodyHitSounds_Metal[1]=audio.loadSound("src/sounds/metal2"..fileFormat)
    bodyHitSounds_Metal[1]=audio.loadSound("src/sounds/metal3"..fileFormat)
    bodyHitSounds_Metal[1]=audio.loadSound("src/sounds/metal4"..fileFormat)
    
    bodyHitSounds_Soft[1]=audio.loadSound("src/sounds/box_hit_1"..fileFormat)
    bodyHitSounds_Soft[2]=audio.loadSound("src/sounds/box_hit_2"..fileFormat)
    
    bodyHitSounds_Coin[1]=audio.loadSound("src/sounds/coin"..fileFormat)
    
    bodyHitSounds_Ball[1]=audio.loadSound("src/sounds/sounds_ball_hit_1"..fileFormat)
    bodyHitSounds_Ball[2]=audio.loadSound("src/sounds/sounds_ball_hit_2"..fileFormat)
    
    
    mousePainSounds[1]= audio.loadSound("src/sounds/sounds_mouse_pain_1"..fileFormat )
    mousePainSounds[2]= audio.loadSound("src/sounds/sounds_mouse_pain_2"..fileFormat )
    
    mousePainSounds[3]= audio.loadSound("src/sounds/sounds_mouse_pain_4"..fileFormat )
    
    mouseEatSounds[1]= audio.loadSound("src/sounds/sounds_mouse_eating_1"..fileFormat )
    mouseEatSounds[2]= audio.loadSound("src/sounds/sounds_mouse_eating_2"..fileFormat )
    mouseEatSounds[3]= audio.loadSound("src/sounds/sounds_mouse_eating_3"..fileFormat )
    
    mouseJumpSounds[1]= audio.loadSound("src/sounds/sounds_mouse_jump"..fileFormat )
    
    userDropSounds[1]= audio.loadSound("src/sounds/sounds_user_drop_1"..fileFormat )
    userDropSounds[2]= audio.loadSound("src/sounds/sounds_user_drop_4"..fileFormat )
    
    ZipSounds[1]= audio.loadSound("src/sounds/zipper"..fileFormat )
    ZipSounds[2]= audio.loadSound("src/sounds/joy"..fileFormat )


end
