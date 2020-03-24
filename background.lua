--
-- Project: main.lua
-- Description: 
--
-- Version: 1.0
-- Managed with http://CoronaProjectManager.com
--
-- Copyright 2012 . All Rights Reserved.
-- 
module(..., package.seeall)
-- a bunch of foliage
sky=nil
bg={}
--[[
function fCreateBg(self)

	for i = 1, #bg, 1 do
	

		if bg[i].type==0 then
			bg[i].originalX=bg[i].x
		elseif bg[i].type==1 then
			game:insert( bg[i] )
			physics.addBody( bg[i], "static", { friction=bg[i].physics.friction, bg[i].physics.bounce} )
		end
	
	
	end

return bg
	
end
--]]

function CreateSky(self)
	-- The sky as background


	--sky = display.newImageRect( "src/images/background/sky.png", 580,420)
        sky = display.newRect(0,0,600,420)
        sky:setFillColor(30,30,30,255)
        --ReferencePointFixed
	--sky:set ReferencePoint(display.CenterCenterReferencePoint);
	sky.x=display.contentWidth*0.5
	sky.y=display.contentHeight*0.5
        sky:toBack()
        background.sky.isVisible=false



                        
end



function MoveBackGround(self,gamex,gamey)


	local i
        local floor=math.floor;
	for i = 1, #bg, 1 do
            if(bg[i].dx~=0) then
                
            
                --local x=floor(bg[i].originalX+bg[i].dx*gamex);
                local x=bg[i].originalX+bg[i].dx*gamex;
                local y=floor(bg[i].originalY+gamey);
            
                --if(bg[i].x~=x) then
                    bg[i].x=x;
                --end
            
                if(bg[i].y~=y) then
                    bg[i].y=y;
                end
            end	
	end

end