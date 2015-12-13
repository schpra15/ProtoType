-----------------------------------------------------------------------------------------
--
-- level_select.lua
--
-- Used for choosing a level
-----------------------------------------------------------------------------------------
-- Requires
---------------------------------------------------------------------------------
local composer = require( "composer" )
local widget = require( "widget" )

local scene = composer.newScene()

-- Scene components
local background
local title
local backButton
local scrollView


function scene:create( event )
	local sceneGroup = self.view
	-- Called when the scene's view does not exist.

	background = display.newImage("images/background.png")
	background.x = 100
	background.y = 100
	sceneGroup:insert( background )

  -- Create the title text
	title = display.newEmbossedText( "Level Select", display.contentWidth/2, display.screenOriginY + 8, native.systemFontBold, 28 )
	title.anchorX = 0.5
	title.anchorY = 0
	title:setFillColor( 1, 1, 1 )
  sceneGroup:insert(title)

  -- Draw the scroll view with the level buttons
  self:drawScrollView()

  -- Create the back button
  backButton = GuiControls:newButton(display.contentWidth-display.screenOriginX-33, 13, 64, 24, "< Back", GuiControls.styles.danger, function(event)
      composer.gotoScene("scenes.main_menu")
    end
  )
  sceneGroup:insert(backButton)

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

    display.remove(scrollView)
    self:drawScrollView()
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
-- Other functions
function scene:drawScrollView()
  local sceneGroup = self.view

  scrollView = widget.newScrollView
  {
      top = 50,
      left = display.screenOriginX,
      width = 300,
      height = display.contentHeight,
      scrollWidth = 0,
      scrollHeight = 100,
      horizontalScrollDisabled = true,
      listener = nil,
      hideBackground = true
  }

	-- Create the level buttons
	for k,v in pairs(Game.levels) do
    local btn
    local btnStyle
    local txtStatus = ""

    if (not v.isUnlocked) then
      btnStyle = GuiControls.styles.default_disabled
      txtStatus = "LOCKED"
      btn = GuiControls:newButton(66, 26 + 56*(k-1), 128, 48, "Level "..k, btnStyle, function(e)
        return true
      end)
      btn:setEnabled(false)
    elseif (v.isCleared) then
      btnStyle = GuiControls.styles.success
      txtStatus = "COMPLETE"
      btn = GuiControls:newButton(66, 26 + 56*(k-1), 128, 48, "Level "..k, btnStyle, function(e)
        Game.gamplayMode = 0
        Game.currentLevel = k
        composer.gotoScene("scenes.level")
        return true
      end)
    else
      txtStatus = "NOT ATTEMPTED"
      btnStyle = GuiControls.styles.default
      btn = GuiControls:newButton(66, 26 + 56*(k-1), 128, 48, "Level "..k, btnStyle, function(e)
        Game.gamplayMode = 0
        Game.currentLevel = k
        composer.gotoScene("scenes.level")
        return true
      end)
    end

    local txt = display.newEmbossedText( txtStatus, 150, 26 + 56*(k-1), native.systemFontBold, 16 )
    txt.anchorX = 0
    txt.anchorY = 0.5
    txt:setFillColor( 1, 1, 1 )
    scrollView:insert(txt)

		scrollView:insert(btn)
	end

  -- Set the scroll height to be the total height of the game field
  scrollView:setScrollHeight(#Game.levels*50)
  sceneGroup:insert(scrollView)
end


---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-----------------------------------------------------------------------------------------

return scene
