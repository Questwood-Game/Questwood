
-- CAN BE COPIED TO MAD MOUSE GAME 2013/04/04
--
-- Project: buttons.lua
-- Description: 
--
-- Version: 1.0
-- Managed with http://CoronaProjectManager.com
--
-- Copyright 2012 . All Rights Reserved.
-- 
module(..., package.seeall)

local function createEditorButtons(self)
moveGalleryLeftButton = widget.newButton{
	default = "src/images/buttons/button_100.png",
	over = "src/images/buttons/buttonOver_100.png",
	onPress = MoveGalleryLeft,
	label = "<<",
	labelColor = { default = { 255 } },
	emboss = true
}

moveGalleryLeftButton.anchorX=0;
moveGalleryLeftButton.anchorY=0;
--moveGalleryLeftButton:set ReferencePoint( display.TopLeftReferencePoint )
moveGalleryLeftButton.x =20
moveGalleryLeftButton.y =150
	
moveGalleryRightButton = widget.newButton{
	default = "src/images/buttons/button_100.png",
	over = "src/images/buttons/buttonOver_100.png",
	onPress = MoveGalleryRight,
	label = ">>",
	labelColor = { default = { 255 } },
	emboss = true
}
moveGalleryRightButton.anchorX=0;
moveGalleryRightButton.anchorY=0;
--moveGalleryRightButton:set ReferencePoint( display.TopLeftReferencePoint )
moveGalleryRightButton.x =moveGalleryLeftButton.x+moveGalleryLeftButton.width+10
moveGalleryRightButton.y =150

end

 function removeGallery(self)

	display.remove(moveGalleryRightButton)
	moveGalleryRightButton=nil
	display.remove(moveGalleryLeftButton)
	moveGalleryLeftButton=nil
	display.remove(sprite_gallery)
	sprite_gallery=nil
 end
 
 
function MoveGalleryLeft(event)
	if sprite_gallery.x<0 then
		sprite_gallery.x = sprite_gallery.x+100
	end
end

function MoveGalleryRight(event)

		sprite_gallery.x = sprite_gallery.x-100

end

local function getSpriteIndexByX(x)
		for i,line in ipairs(sprite_collection.SpriteColection) do
			local s=sprite_collection.SpriteColection[i]
			if s.x==x then
				return i
			end
		end
		return -1
end
--function  removeListener(self)
		--background.sky:removeEventListener( "touch", dropObject)
		--if SelectedSpriteObject~=nil then
			--SelectedSpriteObject:removeEventListener ( "touch", SelectSprite)
--		end
--end

function  SelectSprite( event )
	
		if "ended" ~= event.phase then
			return false
		end
		
		--Sprite Selected
		local body = event.target
		body.isFocus = true
		
		local i=getSpriteIndexByX(body.x)
		
		
                local Folder="src/images/sprites/"
		
		if i~=-1 then
			
			--SelectedSpriteObject:removeEventListener ( "touch", SelectSprite)
			
			if editor.CurrentSprite~=-1 then
				display.remove(CurrentSpriteImage)
				CurrentSpriteImage=nil
			end
			
			editor.EditType=1
			editor.CurrentSprite=i
			local s=sprite_collection.SpriteColection[i]
			CurrentSpriteImage=display.newImage( Folder..s.image )
                        
                        CurrentSpriteImage.anchorX=0;
                        CurrentSpriteImage.anchorY=0;
			--CurrentSpriteImage:set ReferencePoint( display.TopLeftReferencePoint )
			CurrentSpriteImage.x=10
			CurrentSpriteImage.y=10
			editor:CreateGalleryButton()

			
			removeGallery()
			
			editor:CreateBody()

		end

end




function drawSpriteGallery(self)

	--Draw Sprite Gallery
	
	buttons.EditType=0
			
	sprite_gallery = display.newGroup();
	sprite_gallery.x = 0
	sprite_gallery.y = 0
	
	local s_max_height=80
	
	board = display.newRoundedRect(20, 40, 1000,100 ,10)
	board:setFillColor(50, 100,255, 50)
	sprite_gallery:insert (board)
        local Folder="src/images/sprites/"
	local x=60
	for i,line in ipairs(sprite_collection.SpriteColection) do
		
		local s=sprite_collection.SpriteColection[i]

		local SelectedSpriteObject

		SelectedSpriteObject=display.newImageRect( Folder..s.image ,s.width,s.height)



		if SelectedSpriteObject.height>s_max_height then
			SelectedSpriteObject.width=math.floor(SelectedSpriteObject.width/(SelectedSpriteObject.height/s_max_height))
			SelectedSpriteObject.height=s_max_height
		end
                
                SelectedSpriteObject.anchorX=0;
                SelectedSpriteObject.anchorY=0;
		--SelectedSpriteObject:set ReferencePoint( display.TopLeftReferencePoint )
		sprite_gallery:insert(SelectedSpriteObject); SelectedSpriteObject.x = x; SelectedSpriteObject.y = 50
		s.x=x
		x=x+SelectedSpriteObject.width+30

		SelectedSpriteObject:addEventListener ( "touch", SelectSprite)
		
	end
	
	createEditorButtons(self)
end
