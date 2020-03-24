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

local aboutTextChannel;

local help_window=nil;
local help_scroll=nil;
local coverDeskHelp=nil;
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
    
    ButtonBack = widget.newButton{
            id="HelpButton",left=-238,top=2-yOffset,
            defaultFile = "src/images/buttons/button_back.png",
            overFile = "src/images/buttons/button_hover_back.png",
            onRelease =Back,
            width=50,
            height=50
    }

    help_window:insert (ButtonBack)
           
end
    
local function DrawHelpWindow(self)


        coverDeskHelp = display.newRect(0, 0,display.contentWidth*2,display.contentHeight*2)
	coverDeskHelp:setFillColor(0,0,0, 250)
        
        --coverDeskHelp:set ReferencePoint( display.CenterCenterReferencePoint)
        coverDeskHelp.x=display.contentWidth*0.5
        coverDeskHelp.y=display.contentHeight*0.5
        coverDeskHelp.alpha=0
        
	help_window = display.newGroup();
        --help_window.anchorX=0;
        help_window.width= 400
        help_window.height= 300

	help_window.x =display.contentWidth*0.5---help_window.width*0.5
	help_window.y =0
        help_window.alpha=1
        
        createButtons()
        
        local fontName = "Basic Comical NC";

        --local fontSize = 30
        --local space=6
        

        local gameDescription={};

        gameDescription[1]="About Questwood game"
        gameDescription[2]="Questwood is a fun and tricky adventure game."


        
        gameDescription[3]="The game is about a smart mouse that explores the forest solving physics puzzles. Run jump and move whatever you can to get to the flag.";
        gameDescription[4]="Instructions"
        gameDescription[5]="1. Use Left, Right and Jump buttons to control the mouse;"
        gameDescription[6]=" a. Run and press Jump button and hold both of them to jump longer distances;"
        gameDescription[7]=" b. Tap multiple times on a Jump button to jump onto something."
        gameDescription[8]="2. Eat food to get some energy. More energy you have faster you can run and may jump higher;"
        gameDescription[9]="3. Don't eat too much... There is an alarm that will alert you when to stop eating;"
        gameDescription[10]="4. Collect coins so you may buy valuable items further in the game;"
        gameDescription[11]="5. Move boxes to jump onto something if necessary;"
        gameDescription[12]="6. Find or buy (game coins) the Bag to collect the items;"
        gameDescription[13]="7. Collect valuable items by tapping on them with the finger. This works only when you have the Bag;"
        gameDescription[14]="8. Use balls to hit some distant objects: for example, the box that maybe in help. Mouse may hold one ball at the time in the hands, when you throw the ball it will look for the same type of ball in the Bag."
    
        
        gameDescription[15]="Author:";
        gameDescription[16]="Ivan Komlev";
        
        gameDescription[17]="Motivation:";
        gameDescription[18]="Darya & Vika";
        
        gameDescription[19]="Website:";
        gameDescription[20]="www.QuestwoodGame.com";
        
        gameDescription[21]="Graphics:";
        gameDescription[22]="www.cartoonsolutions.com & www.depositphotos.com";
        
        gameDescription[23]="Sounds:";
        gameDescription[24]="www.pond5.com";
        
        

        local DescHeight=   {60,60,105,50,50,    50,70,90,70,70,     70,70,90,130,30,        50,30,50,30,50,     30,60,30,50,100};
        local Colors=       {1,0,0,1,0,         0,0,0,0,0,          0,0,0,0,1,              0,1,0,1,0,          1,0,1,0,1,0};
        local FontSize=     {30,20,20,30,20,    20,20,20,20,20,     20,20,20,20,20,         20,20,20,20,20,     20,20,20,20,20};
        
        
        help_scroll = widget.newScrollView
{
    top = 0,
    left = 60,
    width = 400,
    height = 320,
    scrollWidth = 465,
    scrollHeight = 670,
    hideBackground =true
    
}
        --help_scroll.anchorX=0
        local y=30;
     
        
        
        for i = 1,#gameDescription, 1 do

            
            local myText = display.newText( gameDescription[i] , 0, 0,400,DescHeight[i], fontName, FontSize[i]);
            
            myText.anchorX=0;
            myText.anchorY=0;
            --myText:set ReferencePoint( display.TopCenterReferencePoint );  

            myText.y=y;
            if(Colors[i]==1) then
                myText:setTextColor(255,200,0);
            else
                myText:setTextColor(255,255,255);
            end
            

            
            help_scroll:insert (myText);
                
            y=y+DescHeight[i];
        end

        
        
        
        
        
        AllTransition[#AllTransition+1]=transition.to( coverDeskHelp, { time=500, alpha=0.85 } )
                    
        



end

function DoBack(self)
    audio.stop(aboutTextChannel) ;
    
    CancelAllTransition()
    
    display.remove(coverDeskHelp)
    coverDeskHelp=nil
    

    display.remove( ButtonBack)
    ButtonBack=nil

    display.remove(help_window)
    help_window=nil
    
    display.remove(help_scroll)
    help_scroll=nil
    

    mainmenu:ShowHideButtons(true);

end

local function BackEvent()
    Runtime:removeEventListener( "key", onKeyEvent )
    display.remove( ButtonBack)
    ButtonBack=nil
    
    
    
    AllTransition[#AllTransition+1]=transition.to( coverDeskSettings, { time=200, alpha=0 } )
    timer.performWithDelay(200,DoBack,1)
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

local function PlayAbout()
     local aboutText= audio.loadSound("src/sounds/about_questwood_game.wav")
     
     local myclosure= function()
     
            aboutTextChannel = audio.findFreeChannel()
            audio.setVolume( 0.5, { channel=aboutTextChannel} )
            audio.play( aboutText, { channel=aboutTextChannel,loops=0 } )

    end
    timer.performWithDelay(1000,myclosure,1)
end


function OpenHelpForm(self)

    buttons:removeAllButtons()

    DrawHelpWindow()
    
    
    --add the runtime event listener
    if system.getInfo( "platformName" ) == "Android" then  
        Runtime:addEventListener( "key", onKeyEvent )
    end
    
    PlayAbout();
end
