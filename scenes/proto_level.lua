-----------------------------------------------------------------------------------------
--
-- testGameplay.lua
--
-- Contains just a quick prototype.
-----------------------------------------------------------------------------------------
-- Requires
---------------------------------------------------------------------------------
local composer = require( "composer" )
local widget = require( "widget" )

local scene = composer.newScene()
scene.allTurets = {}
scene.towers = {}

function scene:create( event )
	local sceneGroup = self.view
	
	-- Create the level
	local levelData = Game.levels[Game.currentLevel]
	Game.levelMoney = levelData.startMoney	

	local music = audio.loadStream("audio/bgm_game.wav")
	audio.play(music, {loops = -1})

	self.gameView = display.newGroup()

	physics.start()

	--Display Background
	local background = display.newRect(0,0,2000,2000) --display.newImage("images/background.png")
	background:setFillColor(0,0.9,1)
	background.x = 150
	background.y = 100
	--sceneGroup:insert( background )
	self.gameView:insert(background)
	
	-- draw the ceiling
	local ceiling = display.newImage("images/floor.png")
	ceiling.name = "floor"
	ceiling.x = 150
	ceiling.y = 5
	physics.addBody(ceiling, "static", { density=0.0, friction=.1, bounce=0.0 })
	self.gameView:insert(ceiling)
	
	-- Make the floors
	local floorHeight = 150
	local levelHeight = floorHeight * #levelData.floors
	
	for i=1, #levelData.floors do
		local floor = display.newImage("images/floor.png")
		floor.name = "floor"
		floor.x = 150
		floor.y = floorHeight * i
		physics.addBody(floor, "static", { density=0.0, friction=.1, bounce=0.0 })
		self.gameView:insert(floor)
		
		if (levelData.floors[i].tower == 0) then
			-- Initialize the towers
			Tower:newTower(scene, "friend", 32, floorHeight * i)	
		else
			Tower:newTower(scene, "enemy", display.contentWidth-display.screenOriginX*2 - 32, floorHeight * i)
		end
	end

	local bottomFloor = display.newImage("images/floor.png")
	bottomFloor.name = "floor"
	bottomFloor.x = 150
	bottomFloor.y = #levelData.floors * 150
	physics.addBody(bottomFloor, "static", { density=0.0, friction=.1, bounce=0.0 })
	self.gameView:insert(bottomFloor)

	-- Initialize some enemies
	Turet:newMageTuret(scene, "enemy", display.contentWidth-display.screenOriginX*2 - 100, 150, -1, { HPMax=100 })

	sceneGroup.gui = display.newGroup()
	-- local moneyText = display.newEmbossedText("$"..Game.money, display.screenOriginX, 0, native.systemFontBold, 20)
	-- 	moneyText.anchorX = 0
	-- 	moneyText.anchorY = 0
	-- 	moneyText:setFillColor(0, 0.7, 0, 1)
	-- 	moneyText:setEmbossColor(GuiControls.styles.success.embrossColor)
	local moneyText = Classes:newUpdateText("$", display.screenOriginX, 0, Game.levelMoney)
	sceneGroup.gui:insert(moneyText)

	local conditionText = display.newEmbossedText("Condition: Defeat Enemy Towers!", display.contentWidth-display.screenOriginX, 0, native.systemFontBold, 10)
		conditionText.anchorX = 1
		conditionText.anchorY = 0
		conditionText:setFillColor(1, 1, 1, 1)
		conditionText:setEmbossColor(GuiControls.styles.success.embrossColor)
	sceneGroup.gui:insert(conditionText)
	local turetMenu = GuiControls:newGuiTuretMenu(scene)
	sceneGroup.gui:insert(turetMenu)

	scene.scrollView = widget.newScrollView
	{
	    top = 0,
	    left = display.screenOriginX,
	    width = display.contentWidth-display.screenOriginX*2,
	    height = display.contentHeight,
	    scrollWidth = 0,
	    scrollHeight = 100,
			horizontalScrollDisabled = true,
	    listener = nil
	}

	-- Set the scroll height to be the total height of the game field
	scene.scrollView:setScrollHeight(levelHeight)

	function enterFrame(event)
		for i=1, #scene.allTurets do
			local turetA = scene.allTurets[i]
			for j=1, #scene.allTurets do
				if (i ~= j) then
					local turetB = scene.allTurets[j]
					turetA:handleBehavior(turetB)
					turetB:handleBehavior(turetA)
				end
			end
		end

		for k,v in pairs(scene.towers) do
			if (v == nil) then
				print (dsfafd)
			end
		end

		moneyText:setValue(Game.levelMoney)
	end
	Runtime:addEventListener("enterFrame", enterFrame)

	scene.scrollView:insert(self.gameView)
	sceneGroup:insert(scene.scrollView)
	sceneGroup:insert(sceneGroup.gui)

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


function scene:newEnemy(event)
	local y = math.random(50, 200)
	local e = Turet:newMageTuret(scene, "enemy", 400, y, -1)
	print "enemy created"
	self.view.gui:toFront()
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-----------------------------------------------------------------------------------------

return scene
