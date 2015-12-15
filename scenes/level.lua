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
scene.objects = {}
scene.turets = {}
scene.towers = {}
scene.isDone = false

local moneyText = nil

local levelData = Game.levels[Game.currentLevel]
local enemyMoney = levelData.startEnemyMoney
local floorHeight = display.contentHeight/2
local levelHeight = floorHeight * #levelData.floors

local music = audio.loadStream("audio/bgm_game.wav")
local musicStream
local gameOverSound = audio.loadSound("audio/Game Over.wav")

function scene:create( event )
	local sceneGroup = self.view

	-- Create the level
	Game.levelMoney = levelData.startMoney

	musicStream = audio.play(music, {loops = -1})

	self.gameView = display.newGroup()
	physics.start()

	-- Make the floors
	local floorHeight = display.contentHeight/2
	local levelHeight = floorHeight * #levelData.floors

	for i=1, #levelData.floors do
		local background = display.newImageRect("images/background1.png", display.contentWidth-display.screenOriginX*2, floorHeight)
		background.anchorX = 0
		background.anchorY = 0
		background.y = floorHeight * (i-1)
		self.gameView:insert(background)

		local floor = display.newImage("images/floor.png")
		floor.name = "floor"
		floor.x = 150
		floor.y = floorHeight * i
		physics.addBody(floor, "static", { density=0.0, friction=.1, bounce=0.0 })
		self.gameView:insert(floor)

		if (levelData.floors[i].tower == 0) then
			-- Initialize the towers
			Tower:newTower(scene, "friend", 32, floorHeight * i - 4)
		else
			Tower:newTower(scene, "enemy", display.contentWidth-display.screenOriginX*2 - 32, floorHeight * i - 4)
		end

	end

	-- draw the ceiling
	local ceiling = display.newImage("images/floor.png")
	ceiling.name = "floor"
	ceiling.x = 150
	ceiling.y = 0
	physics.addBody(ceiling, "static", { density=0.0, friction=0.1, bounce=0.0 })
	self.gameView:insert(ceiling)

	sceneGroup.gui = display.newGroup()
	local gearsImg = display.newImageRect("images/gear.png", 32, 32)
	gearsImg.x = display.screenOriginX
	gearsImg.y = 16
	gearsImg.anchorX = 0
	sceneGroup.gui:insert(gearsImg)
	moneyText = Classes:newUpdateText("x", display.screenOriginX+28, 12, GuiControls.styles.default, Game.levelMoney)
	sceneGroup.gui:insert(moneyText)

	local conditionText = display.newEmbossedText("Level "..Game.currentLevel..": "..levelData.descText, display.contentWidth-display.screenOriginX, 0, native.systemFontBold, 10)
		conditionText.anchorX = 1
		conditionText.anchorY = 0
		conditionText:setFillColor(1, 1, 1, 1)
		conditionText:setEmbossColor(GuiControls.styles.success.embrossColor)
	sceneGroup.gui:insert(conditionText)
	local turetMenu = GuiControls:newGuiTuretMenu(scene)
	sceneGroup.gui:insert(turetMenu)

	-- initialize the enemies
	for k,v in pairs(levelData.floors) do
		scene:newEnemy(400, floorHeight * k-70)
	end

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

	Runtime:addEventListener("enterFrame", scene)

	-- Set the scroll height to be the total height of the game field
	scene.scrollView:setScrollHeight(levelHeight)

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
	end
end

function scene:destroy( event )
	local sceneGroup = self.view

	Runtime:removeEventListener("enterFrame", scene)

	while #scene.turets > 0 do
		scene.turets[1]:delete()
	end

	while #scene.towers > 0 do
		scene.towers[1]:die()
	end

	while #scene.objects > 0 do
		scene.objects[1]:die()
	end



	display.remove(scene.scrollView)
	display.remove(scene.gameView)
	display.remove(sceneGroup.gui)
end


-- Enter frame function
function scene:enterFrame(event)
	for i=1, #scene.turets do
		local turetA = scene.turets[i]
		for j=1, #scene.turets do
			if (i ~= j) then
				local turetB = scene.turets[j]
				turetA:handleBehavior(turetB)
				turetB:handleBehavior(turetA)
			end
		end
	end
	-- run the AI loops

	moneyText:setValue(Game.levelMoney)
end

function scene:newEnemy(x, y)

	-- for k,v in levelData.enemies do
	--
	-- end
	-- choose a random turet
	local t = levelData.enemies[#levelData.enemies]

	if (enemyMoney - t.deployCost >= 0) then
		local e = Turet:newTuretByClass(scene, t.class, "enemy", x, y, -1, t)
		self.view.gui:toFront()
		enemyMoney = enemyMoney - t.deployCost
	end

end

function scene:removeObject(obj)
	for i=1, #scene.objects do
	  if (scene.objects[i] == obj) then
		  table.remove(scene.objects, i)
			break
	  end
	end
end

function scene:notifyTowerDead(tower)
	for i=1, #scene.towers do
	  if (scene.towers[i] == tower) then
		  display.remove(tower)
		  table.remove(scene.towers, i)
		  if (tower.type == "friend") then
				scene:endGame(false)
				break
			else
				local allEnemyTowersDead = true
				for j=1, #scene.towers do
					if (scene.towers[j].type == "enemy") then
						allEnemyTowersDead = false
						break
					end
				end
				if (allEnemyTowersDead) then
					scene:endGame(true)
					break
				end
		  end
	  end
	end
end

function scene:notifyEnemyDead(turet)
	-- Replenish the enemy
	Game.levelMoney = Game.levelMoney + turet.deathReward

	-- calculate which floor the enemy is on
	local currentFloor = math.floor(turet.y/floorHeight) + 1

	-- put another enemy on that floor
	scene:newEnemy(400, currentFloor * floorHeight - 40)

end

function scene:endGame(isWon)
	if (not scene.isDone) then
		audio.stop(musicStream)
		audio.dispose(music)
		music = nil
		if (isWon) then
			Game.levels[Game.currentLevel].isCleared = true
			Game.money = Game.money + Game.levelMoney
			if (Game.currentLevel+1 <= #Game.levels) then
				Game.levels[Game.currentLevel+1].isUnlocked = true
			end
			-- show a you win modal
			local rektRect = display.newRect(-100,-100, 2000, 2000)
			rektRect:setFillColor( 0, 0 , 0, 0.5 )
			rektRect:addEventListener("touch", function(e)
				return true
			end)
			self.view.gui:insert(rektRect)

			local gameOverText = display.newEmbossedText("You have won!", (display.contentWidth-display.screenOriginX) / 2, display.contentHeight/2, native.systemFontBold, 32)
			gameOverText.anchorX = 0.5
			gameOverText.anchorY = 0.5
			gameOverText:setFillColor(1, 1, 1, 1)
			gameOverText:setEmbossColor(GuiControls.styles.success.embrossColor)

			self.view.gui:insert(gameOverText)
			local btn = GuiControls:newButton((display.contentWidth-display.screenOriginX)/2, (display.contentHeight-display.screenOriginY)/2 + 48, 256, 48, "Level Select", GuiControls.styles.default, function(e)
				composer.removeScene("scenes.level")
				composer.gotoScene("scenes.level_select")
			end)

			self.view:insert(btn)
		else
			audio.play(gameOverSound)
			-- show a game over modal
			local rektRect = display.newRect(-100,-100, 2000, 2000)
			rektRect:setFillColor( 0, 0 , 0, 0.5 )
			rektRect:addEventListener("touch", function(e)
				return true
			end)
			self.view.gui:insert(rektRect)

			local gameOverText = display.newEmbossedText("You have lost!", (display.contentWidth-display.screenOriginX) / 2, display.contentHeight/2, native.systemFontBold, 32)
			gameOverText.anchorX = 0.5
			gameOverText.anchorY = 0.5
			gameOverText:setFillColor(1, 1, 1, 1)
			gameOverText:setEmbossColor(GuiControls.styles.success.embrossColor)

			self.view.gui:insert(gameOverText)
			local btn = GuiControls:newButton((display.contentWidth-display.screenOriginX)/2, (display.contentHeight-display.screenOriginY)/2 + 48, 256, 48, "Try Again", GuiControls.styles.default, function(e)
				composer.removeScene("scenes.level")
				composer.gotoScene("scenes.level")
			end)

			self.view:insert(btn)
		end

		scene.isDone = true

	end
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-----------------------------------------------------------------------------------------

return scene
