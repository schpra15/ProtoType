-----------------------------------------------------------------------------------------
--
-- main_menu.lua
--
-- Contains just a quick prototype of the
-----------------------------------------------------------------------------------------
-- Requires
---------------------------------------------------------------------------------
local composer = require( "composer" )

local scene = composer.newScene()

-- Defines the menus of the screen
-- local menus = {
-- 	{
-- 		title="Single Player",
-- 		action=function(event)
-- 			print "Single Player"
-- 			composer.gotoScene("scenes.proto_level")
-- 		end
-- 	},
-- 	{
-- 		title="Turet Factory",
-- 		action=function(event)
-- 			print "Turet Factory"
-- 		end
-- 	},
-- }

function scene:create( event )
	local sceneGroup = self.view
	-- Called when the scene's view does not exist.

	-- Create the background
	local background = display.newRect(-100, 0, display.contentWidth+200, display.contentHeight)
	background.anchorX = 0
	background.anchorY = 0
	background:setFillColor( 0.8, 0.8, 0.8 )
	sceneGroup:insert( background )

	-- Create the title text
	local title = display.newEmbossedText( "Turet Factory", display.screenOriginX + 8 + display.contentWidth/2, display.screenOriginY + 8, native.systemFontBold, 32 )
	title.anchorX = 0.5
	title.anchorY = 0
	title:setFillColor( 0.5, 0.1, 0 )
	local color =
	{
	    highlight = { r=1, g=1, b=1 },
	    shadow = { r=0.3, g=0.3, b=0.3 }
	}
	title:setEmbossColor( color )
	sceneGroup:insert(title)

	local description = display.newEmbossedText( "Create your own arsenal of turets to take to the battlefield!\nUpgrade existing turets with new parts!", display.screenOriginX + display.contentWidth/2 + 8, display.screenOriginY + 42, native.systemFont, 12 )
	description.anchorX = 0.5
	description.anchorY = 0
	description:setFillColor( 0.5, 0.5, 0.5 )
	description:setEmbossColor( color )
	sceneGroup:insert(description)


	local moneyText = display.newEmbossedText("$"..Game.money, display.screenOriginX, 0, native.systemFontBold, 20)
	moneyText.anchorX = 0
	moneyText.anchorY = 0
	moneyText:setFillColor(0, 0.7, 0, 1)
	moneyText:setEmbossColor(GuiControls.styles.success.embrossColor)
	sceneGroup:insert(moneyText)

	-- Create the back button
	local backButton = GuiControls:newButton(display.contentWidth - display.screenOriginX-32, 12, 64, 24, "Exit", GuiControls.styles.danger, function(event)
				transition.to(sceneGroup, {
						time = 1000,
						x = display.contentWidth*2,
						transition = easing.inOutExpo,
						onComplete = function()
							composer.gotoScene("scenes.main_menu")
						end
					}
				)
		end
	)
	sceneGroup:insert(backButton)

	-- Create a group that shows the money, Create New and Edit buttons
	-- Create the back button
	local createNewButton = GuiControls:newButton(display.contentWidth - display.screenOriginX-64, 120, 100, 24, "New Turet", GuiControls.styles.success, function(event)
			print "Create new Turet"
		end
	)
	sceneGroup:insert(createNewButton)

	-- Create the back button
	local editButton = GuiControls:newButton(display.contentWidth - display.screenOriginX-64, 150, 100, 24, "Edit Turet", GuiControls.styles.primary, function(event)
			print "Edit turet"
		end
	)
	sceneGroup:insert(editButton)

	-- Show the My Turets window
	local myTuretsGroup = display.newGroup()
	local myTuretsBase = display.newRoundedRect(myTuretsGroup, 0, 0, display.contentWidth-display.screenOriginX-130, display.contentHeight-80, 2)
	myTuretsBase.x = display.screenOriginX
	myTuretsBase.y = display.contentHeight-display.screenOriginY
	myTuretsBase.anchorX = 0
	myTuretsBase.anchorY = 1
	myTuretsBase.strokeWidth = 1
	myTuretsBase:setStrokeColor(0.6, 0.6, 0.6, 1)
	myTuretsBase:setFillColor(0.85, 0.85, 0.85, 1)

	myTuretsBase.fill.effect = "generator.linearGradient"

	myTuretsBase.fill.effect.color1 = { 1, 1, 1, 1 }
	myTuretsBase.fill.effect.position1  = { 0, 0 }
	myTuretsBase.fill.effect.color2 = { 0.8, 0.8, 0.8, 1 }
	myTuretsBase.fill.effect.position2  = { 1, 1 }
	myTuretsBase.alpha = 0.8

	print(Game.myTurets)

	-- Assuming the turets take up an 80x80 square
	local page = 0
	local padding = 32
	local xSlots = (myTuretsBase.width-padding*2)/(36+padding)
	local ySlots = (myTuretsBase.height-padding*2)/(36+padding)

	for i=0, math.floor(ySlots) do
		for j=0, math.floor(xSlots) do
			local turetIcon = display.newRect(myTuretsGroup,0,0,36,36)
			turetIcon:setFillColor(1,0,0)
			turetIcon.x = padding + j*(36+padding)/xSlots*math.floor(xSlots) + display.screenOriginX - 8
			turetIcon.y = display.contentHeight + display.screenOriginY - myTuretsBase.height + i*(36+padding)/ySlots*math.floor(ySlots) + padding
			turetIcon.anchorX = 0
			turetIcon.anchorY = 0
		end
	end

	sceneGroup:insert(myTuretsGroup)

end

function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase

	if phase == "will" then
		-- Called when the scene is still off screen and is about to move on screen
	elseif phase == "did" then
		-- Called when the scene is now on screen
		--
		-- INSERT code here to make the scene come alive
		-- e.g. start timers, begin animation, play audio, etc.
		-- Animate the initial transition
		transition.from(sceneGroup, {
				time = 1000,
				x = display.contentWidth*2,
				transition = easing.inOutExpo,
				onComplete = function()
				end
			}
		)
	end
end

function scene:hide( event )
	local sceneGroup = self.view
	local phase = event.phase

	if event.phase == "will" then
		-- Called when the scene is on screen and is about to move off screen
		--
		-- INSERT code here to pause the scene
		-- e.g. stop timers, stop animation, unload sounds, etc.)
	elseif phase == "did" then
		-- Called when the scene is now off screen
	end
end

function scene:destroy( event )
	local sceneGroup = self.view

	-- Called prior to the removal of scene's "view" (sceneGroup)
	--
	-- INSERT code here to cleanup the scene
	-- e.g. remove display objects, remove touch listeners, save state, etc.
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-----------------------------------------------------------------------------------------

return scene
