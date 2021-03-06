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
local music = audio.loadStream("audio/bgm_main_theme.ogg")
local musicStream

function scene:create( event )
	local sceneGroup = self.view
	-- Called when the scene's view does not exist.
	
	musicStream = audio.play(music, {loops = -1})

	-- Defines the menus of the screen
	local menus = {
		{
			title="Campaign",
			action=function(event)
				Game.gamplayMode = 0
				composer.gotoScene("scenes.level_select")
			end
		},
		-- {
		-- 	title="Survival",
		-- 	action=function(event)
		-- 		Game.gamplayMode = 1
		-- 		composer.gotoScene("scenes.level")
		-- 	end
		-- },
		{
			title="Turet Factory",
			action=function(event)
				transition.to(sceneGroup, {
						time = 500,
						x = display.contentWidth*2,
						transition = easing.inOutExpo,
						onComplete = function()
							composer.gotoScene("scenes.turet_factory")
						end
					}
				)
			end
		},
	}

	local background = display.newImage("images/background.png")
	background.x = 100
	background.y = 100
	sceneGroup:insert( background )

	-- Create the title text
	local title = display.newImage("images/logo.png", display.contentWidth/2, display.contentHeight/2-100)
	title.anchorX = .5
	title.anchorY = .5
	sceneGroup:insert(title)

	-- Create the menu buttons
	for k,v in pairs(menus) do
		local btn = GuiControls:newButton(display.contentWidth/2, display.contentHeight/2 + 44*(k-1), 256, 32, v.title, GuiControls.styles.default, v.action)
		sceneGroup:insert(btn)
	end

	-- all objects must be added to group (e.g. self.view)
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
				time = 500,
				alpha = 0,
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
		audio.stop(musicStream)
		--audio.dispose(music)
		--music = nil
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
