--
-- Project: sprite_selection.lua
-- Description: 
--
-- Version: 1.0
-- Managed with http://CoronaProjectManager.com
--
-- Copyright 2012 . All Rights Reserved.
-- 
module(..., package.seeall)


EditType=0
-- 0 Nothing
-- 1 Place
-- 2 Drag
-- 3 Delete

CurrentSprite=-1

-- ------------------------------------------------------------------ Editor Buttons
function CreateGalleryButton(self)
	if GalleryButton== nil then
            GalleryButton = widget.newButton{
                left=NewButton.x-75-10,top=y,
                defaultFile = "src/images/buttons/button_50.png",
                overFile = "src/images/buttons/buttonOver_50.png",
                onRelease =DrawSpriteGallery,
                label = "Sprites",
                labelColor = { default = { 255 } },
                width=50,height=50,
                emboss = true
            }
	end
end

function createEditorButtons(self)
	thegame:removeSkyDropListener()
	
	local sprite_selection = require( "sprite_selection" )
	bottom_board = display.newRect(0, display.contentHeight-40, display.contentWidth,40)
	bottom_board:setFillColor(0, 0,0, 50)
	

        GameButton = widget.newButton{
            left=display.contentWidth-50-2,top=2,
            defaultFile = "src/images/buttons/button_50.png",
            overFile = "src/images/buttons/buttonOver_50.png",
            onRelease =Switch2Game,
            label = "Game",
            labelColor = { default = { 255 } },
            width=50,height=50,
            emboss = true
        }

    LoadButton = widget.newButton{
        left=GameButton.x-75-10,top=2,
	defaultFile = "src/images/buttons/button_50.png",
	overFile = "src/images/buttons/buttonOver_50.png",
	onRelease =LoadGame,
	label = "Load",
	labelColor = { default = { 255 } },
        width=50,height=50,
	emboss = true
    }
    
SaveButton = widget.newButton{
        left=LoadButton.x-75-10,top=2,
	defaultFile = "src/images/buttons/button_50.png",
	overFile = "src/images/buttons/buttonOver_50.png",
	onRelease =SaveGame,
	label = "Save",
	labelColor = { default = { 255 } },
        width=50,height=50,
	emboss = true
}

NewButton = widget.newButton{
        left=SaveButton.x-75-10,top=2,
	defaultFile = "src/images/buttons/button_50.png",
	overFile = "src/images/buttons/buttonOver_50.png",
	onRelease =NewGame,
	label = "New",
	labelColor = { default = { 255 } },
        width=50,height=50,
	emboss = true
}

CreateGalleryButton(self)


moveScreenLeftButton = widget.newButton{
        left=2,top=display.contentHeight-50-2,
	defaultFile = "src/images/buttons/button_50.png",
	overFile = "src/images/buttons/buttonOver_50.png",
	onRelease = MoveScreenLeft,
	label = "Left",
	labelColor = { default = { 255 } },
        width=50,height=50,
	emboss = true
}

	
moveScreenRightButton = widget.newButton{
        left=2+50+10,top=display.contentHeight-50-2	,
	defaultFile = "src/images/buttons/button_50.png",
	overFile = "src/images/buttons/buttonOver_50.png",
	onRelease = MoveScreenRight,
	label = "Right",
	labelColor = { default = { 255 } },
        width=50,height=50,
	emboss = true
}


	EditModeSelector = display.newRect(0, 0, 60,42)
        EditModeSelector.anchorX=0;
        EditModeSelector.anchorY=0;
	--EditModeSelector:set ReferencePoint( display.TopLeftReferencePoint )
	EditModeSelector:setFillColor(0, 255,0, 0)

DeleteBodyButton = widget.newButton{
        left=display.contentWidth-50-10,top=display.contentHeight-50-2,
	defaultFile = "src/images/buttons/button_50.png",
	overFile = "src/images/buttons/buttonOver_50.png",
	onRelease = DeleteBody,
	label = "Delete",
	labelColor = { default = { 255 } },
        width=50,height=50,
	emboss = true
}



DragBodyButton = widget.newButton{
        left=DeleteBodyButton.x-75-10,top=display.contentHeight-50-2,
	defaultFile = "src/images/buttons/button_50.png",
	overFile = "src/images/buttons/buttonOver_50.png",
	onRelease = DragBody,
	label = "Drag",
	labelColor = { default = { 255 } },
        width=50,height=50,
	emboss = true
}


CreateBodyButton = widget.newButton{
        left=DragBodyButton.x-75-10,top=display.contentHeight-50-2,
	defaultFile = "src/images/buttons/button_50.png",
	overFile = "src/images/buttons/buttonOver_50.png",
	onRelease = CreateBody,
	label = "Place",
	labelColor = { default = { 255 } },
        width=50,height=50,
	emboss = true
}


local gameUI = require("gameUI")

DragBody()
--createEditListener()
end

function SaveGame(event)
    if event.phase == "ended" then
	DisableTools()
	local  saveload = require( "saveload" )
	 saveload:saveLevel( 'test.dat')
         end
end

function LoadGame(event)
    if event.phase == "ended" then
	DisableTools()
	physics.pause()

	world:clearWorld()
	local  saveload = require( "saveload" )
	
	saveload:loadLevel( 'test.dat',false)
	
	physics.start()
        end
end

function NewGame(event)
    if event.phase == "ended" then
	DisableTools()
	world:clearWorld()
        end
end

function Switch2Game(event)
    if event.phase == "ended" then

	DisableTools()

	
	
        display.remove(NewButton)
	NewButton=nil
	display.remove(SaveButton)
	SaveButton=nil
	display.remove(LoadButton)
	LoadButton=nil

	display.remove(GameButton)
	GameButton=nil
	display.remove(moveScreenLeftButton)
	moveScreenLeftButton=nil
	display.remove(moveScreenRightButton)
	moveScreenRightButton=nil
	
	display.remove(DeleteBodyButton)
	DeleteBodyButton=nil
	
	display.remove(DragBodyButton)
	DragBodyButton=nil
	
	display.remove(CreateBodyButton)
	CreateBodyButton=nil
	
	display.remove(EditModeSelector)
	EditModeSelector=nil
	
	display.remove(bottom_board)
	bottom_board=nil
	
	if GalleryButton~=nil then
		display.remove(GalleryButton)
		GalleryButton=nil
	end

	if sprite_selection~=nil then
 		--sprite_selection:removeListener()
	 	if sprite_selection.SelectedSpriteObject~=nil then
		 	display.remove(sprite_selection.SelectedSpriteObject)
 			sprite_selection.SelectedSpriteObject=nil
	 	end
	 	
		if CurrentSprite~=-1 then
			display.remove(sprite_selection.CurrentSpriteImage)
			sprite_selection.CurrentSpriteImage=nil
		end

		if sprite_selection.sprite_gallery~=nil then
			sprite_selection:removeGallery(self)
		end
	end
	
	--removeEditListener()
	removeBodyListeners()
	background.sky:removeEventListener( "touch", touchSky)
		
	buttons:createGameButtons()
	
	
	thegame:setSkyDropListener()
	
	EditType=0
	CurrentSprite=-1
	buttons.GameMode=1
	
	end
end

function MoveScreenLeft(event)
    if event.phase == "ended" then

	game.x = game.x+100
        end
end

function MoveScreenRight(event)
    if event.phase == "ended" then
	game.x = game.x-100
        end
end



function addBodyListeners(self)
	for i,line in ipairs(world.WorldSprites) do
		if world.WorldSprites[i].x~=nil then
			world.WorldSprites[i]:addEventListener ( "touch", touchBody)
		end
	end
--	if world.TrapTop~=nil then
		
end

function removeBodyListeners(self)
	if sprite_selection.sprite_gallery~=nil then
			sprite_selection:removeGallery(self)
			CreateGalleryButton(self)
	end
	
	for i,line in ipairs(world.WorldSprites) do
		if world.WorldSprites[i].x==nil then

		else

			world.WorldSprites[i]:removeEventListener ( "touch", touchBody)

		end
	end
end

function DeleteBody(self)

	removeBodyListeners()
	background.sky:removeEventListener( "touch", touchSky) -- to do not create new body
	
	EditModeSelector.x=DeleteBodyButton.x-5
	EditModeSelector.y=DeleteBodyButton.y-5
	EditModeSelector:setFillColor(255, 0,0, 90)
	EditType=3
	
	background.sky:removeEventListener( "touch", touchSky) -- to do not create new body
	addBodyListeners()
end

function DragBody(self)

	removeBodyListeners()
	background.sky:removeEventListener( "touch", touchSky) -- to do not create new body
	
	EditModeSelector.x=DragBodyButton.x-5
	EditModeSelector.y=DragBodyButton.y-5
	EditModeSelector:setFillColor(255, 0,0, 90)
	EditType=2
		
	addBodyListeners()
end

function CreateBody(self)
	if CurrentSprite~=-1 then
		
		removeBodyListeners()
		background.sky:removeEventListener( "touch", touchSky) -- to do not create new body
		
		EditModeSelector.x=CreateBodyButton.x-5
		EditModeSelector.y=CreateBodyButton.y-5
		EditModeSelector:setFillColor(255, 0,0, 90)
		EditType=1
		
		
		background.sky:addEventListener( "touch", touchSky)
	end
	
end

function DisableTools(self)

	removeBodyListeners()
	EditModeSelector.x=0
	EditModeSelector.y=0
	EditModeSelector:setFillColor(255, 0,0, 0)
	EditType=0
	
	background.sky:removeEventListener( "touch", touchSky)
	removeBodyListeners()
		
end





local function dropObject(event)
   local Folder="src/images/sprites/"

	if EditType==1 and CurrentSprite~=-1 and event.y-game.y<display.contentHeight-40 and  event.phase== "began"  then

		
			local s=sprite_collection.SpriteColection[editor.CurrentSprite]

			if s.type=="trap" then
				world:dropTrap(s,editor.CurrentSprite,event.x-game.x,event.y-game.y,0)
				
			elseif s.type=="body" then

				if(s.radius>0) then
						world.WorldSprites[#world.WorldSprites+1]=display.newImage( Folder..s.image)
				else
						world.WorldSprites[#world.WorldSprites+1]=display.newImageRect( Folder..s.image ,s.width,s.height)
				end
			
                        
                                --ReferencePointFixed
				--world.WorldSprites[#world.WorldSprites]:set ReferencePoint( display.CenterCenterReferencePoint )
				game:insert(world.WorldSprites[#world.WorldSprites])
				world.WorldSprites[#world.WorldSprites].x=event.x-game.x
				world.WorldSprites[#world.WorldSprites].y=event.y-game.y
				world.WorldSprites[#world.WorldSprites].bodyIndex=#world.WorldSprites
				world.WorldSprites[#world.WorldSprites].typeIndex=CurrentSprite
				world.WorldSprites[#world.WorldSprites].myName="body"

				if(s.radius>0) then
					physics.addBody (world.WorldSprites[#world.WorldSprites], {bounce = s.bounce, density=s.density, friction = s.friction, radius=s.radius})
                                else
                                    if s.shape==nil then
                                        physics.addBody (world.WorldSprites[#world.WorldSprites], {bounce = s.bounce, density=s.density, friction = s.friction})        
                                    else
                                        physics.addBody (world.WorldSprites[#world.WorldSprites], {shape=s.shape, bounce = s.bounce, density=s.density, friction = s.friction})
                                    end
                                    --physics.addBody (world.WorldSprites[#world.WorldSprites], {bounce = s.bounce, density=s.density, friction = s.friction})
				end
			end

	end
  
end




function touchSky( event )



		if editor.EditType==1 then

                        dropObject( event)
		end


end

function touchBody( event )


		if editor.EditType==2 then

			gameUI.dragBody( event )
		end
		
		if editor.EditType==3 then
			local phase = event.phase
			body=event.target
			if "began" == phase and world.WorldSprites[body.bodyIndex]~=nil then
				

				display.remove(world.WorldSprites[body.bodyIndex])
                                world.WorldSprites[body.bodyIndex]=nil

			end
		end

end

function DrawSpriteGallery(event)
    if event.phase == "ended" then

	DisableTools()
	
	
	sprite_selection:drawSpriteGallery()
        
        display.remove(GalleryButton)
        GalleryButton=nil
	end
end



