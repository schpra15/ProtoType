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
local currentView = nil
local currentTuret = {}

local color =
{
		highlight = { r=1, g=1, b=1 },
		shadow = { r=0.3, g=0.3, b=0.3 }
}

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

	currentView = createTuretListView()

	sceneGroup:remove(view)
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

-- Shows the main view with the player's turets listed
function createTuretListView()

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
		myTuretsBase.fill.effect.color2 = { 0.9, 0.9, 0.9, 1 }
		myTuretsBase.fill.effect.position2  = { 1, 1 }
		myTuretsBase.alpha = 0.8

		-- Assuming the turets take up an 36x36 square
		local page = 0
		local padding = 32
		local xSlots = 5--math.floor((myTuretsBase.width-padding*2)/36)
		local xSpacing = (myTuretsBase.width-padding*2)/(xSlots)
		local ySlots = 3--(myTuretsBase.height-padding*2)/(36+padding)

		local turetIndex = 0

		if (#Game.myTurets == 0) then
			local turetName = display.newText(myTuretsGroup, "YOU HAVE NO TURETS", 10, 100, native.systemFont, 20)
			turetName.anchorY = 0
			turetName.anchorX = 0
			turetName:setFillColor(0)
			turetIndex = turetIndex + 1
		else
			for i=0, ySlots-1 do
				for j=0, xSlots-1 do
					if (turetIndex < #Game.myTurets) then
						local turetIcon = display.newRect(myTuretsGroup,0,0,36,36)
						turetIcon:setFillColor(1,0,0)
						turetIcon.x = padding + j*(xSpacing) + display.screenOriginX
						turetIcon.y = display.contentHeight + display.screenOriginY - myTuretsBase.height + i*(36+padding) + padding
						turetIcon.anchorX = 0
						turetIcon.anchorY = 0

						local turetName = display.newText(myTuretsGroup, "turet name", turetIcon.x, turetIcon.y+36, native.systemFont, 10)
						turetName.anchorY = 0
						turetName.anchorX = 0
						turetName:setFillColor(0)
						turetIndex = turetIndex + 1
					end
				end
			end
		end

		-- Create a group that shows the money, Create New and Edit buttons
		-- Create the back button
		local createNewButton = GuiControls:newButton(display.contentWidth - display.screenOriginX-64, 120, 100, 24, "New Turet", GuiControls.styles.success, function(event)
				currentTuret = {}
				transitionView(createNewTuretView())
			end
		)
		myTuretsGroup:insert(createNewButton)

		-- Create the back button
		local editButton = GuiControls:newButton(display.contentWidth - display.screenOriginX-64, 150, 100, 24, "Edit Turet", GuiControls.styles.primary, function(event)
				print "Edit turet"
			end
		)
		myTuretsGroup:insert(editButton)


	scene.view:insert(myTuretsGroup)
	return myTuretsGroup

end

-- Creates the view that will be used for creating a new turet (wizard)
function createNewTuretView()
	local viewGroup = display.newGroup()
	viewGroup.x = 10
	local title = display.newEmbossedText(viewGroup, "What class of turet do you want to create?", display.screenOriginX, 80, native.systemFontBold, 14 )
	title.anchorX = 0
	title.anchorY = 0

	-- Create the class buttons
	local fighterButton = GuiControls:newButton(display.screenOriginX+50, 120, 100, 24, "Fighter", GuiControls.styles.danger, function(event)
			currentTuret.class = "Fighter"
			transitionView(createNewTuretView2())
		end
	)
	viewGroup:insert(fighterButton)

	local description = display.newEmbossedText( "These turets focus on dealing damage.  However, they are quite frail and reckless.", display.screenOriginX+120, 120, native.systemFont, 10 )
	description.anchorX = 0
	description.anchorY = 0.5
	description:setFillColor( 1, 1, 1 )
	description:setEmbossColor( color )
	viewGroup:insert(description)

	local tankButton = GuiControls:newButton(display.screenOriginX+50, 150, 100, 24, "Tank", GuiControls.styles.warning, function(event)
			print "Tank"
		end
	)
	viewGroup:insert(tankButton)

	description = display.newEmbossedText( "These turets focus on protecting towers and other turets, but their mobility is limited.", display.screenOriginX+120, 150, native.systemFont, 10 )
	description.anchorX = 0
	description.anchorY = 0.5
	description:setFillColor( 1, 1, 1 )
	description:setEmbossColor( color )
	viewGroup:insert(description)

	local supportButton = GuiControls:newButton(display.screenOriginX+50, 180, 100, 24, "Support", GuiControls.styles.primary, function(event)
			print "Support"
		end
	)
	viewGroup:insert(supportButton)

	description = display.newEmbossedText( "These turets can help other friendly turets out, but do not attack.", display.screenOriginX+120, 180, native.systemFont, 10 )
	description.anchorX = 0
	description.anchorY = 0.5
	description:setFillColor( 1, 1, 1 )
	description:setEmbossColor( color )
	viewGroup:insert(description)

	local mageButton = GuiControls:newButton(display.screenOriginX+50, 210, 100, 24, "Mage", GuiControls.styles.success, function(event)
			print "Mage"
		end
	)
	viewGroup:insert(mageButton)

	description = display.newEmbossedText( "These turets can attack with special spells that can cause status ailments.", display.screenOriginX+120, 210, native.systemFont, 10 )
	description.anchorX = 0
	description.anchorY = 0.5
	description:setFillColor( 1, 1, 1 )
	description:setEmbossColor( color )
	viewGroup:insert(description)


	-- Create the cancel button
	local cancelButton = GuiControls:newButton(display.screenOriginX+50, 250, 100, 24, "Cancel", GuiControls.styles.default, function(event)
		transitionView(createTuretListView())
		end
	)
	viewGroup:insert(cancelButton)

	-- local defaultField = native.newTextField( 150, 150, 180, 12 )
	-- viewGroup:insert(defaultField)

	return viewGroup
end

-- Creates the view that allows you to add equipment to the turet
function createNewTuretView2()

	local viewGroup = display.newGroup()

	



	-- Display a Done button
	local doneButton = GuiControls:newButton(-display.screenOriginX+display.contentWidth-51, display.contentHeight-13, 100, 24, "Done", GuiControls.styles.default, function(event)
		table.insert(Game.myTurets, currentTuret)
		transitionView(createTuretListView())
		end
	)
	viewGroup:insert(doneButton)

	return viewGroup
end

-- Used to switch between views
function transitionView(newView)
	scene.view:remove(currentView)
	scene.view:insert(newView)
	currentView = newView
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-----------------------------------------------------------------------------------------

return scene
