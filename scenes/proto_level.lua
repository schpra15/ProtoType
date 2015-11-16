-----------------------------------------------------------------------------------------
--
-- testGameplay.lua
--
-- Contains just a quick prototype.
-----------------------------------------------------------------------------------------
-- Requires
---------------------------------------------------------------------------------
local composer = require( "composer" )

local scene = composer.newScene()
scene.allTurets = {}

function scene:create( event )
	local sceneGroup = self.view

	physics.start()

	--Display Background
	local background = display.newImage("images/background.png")
	background.x = 100
	background.y = 100
	sceneGroup:insert( background )

	--Display and making floor bodies
	local floor1 = display.newImage("images/floor.png")
	floor1.name = "floor"
	floor1.x = 100
	floor1.y = 150
	physics.addBody(floor1, "static", { density=0.0, friction=.1, bounce=0.0 })
	sceneGroup:insert( floor1 )

	local floor2 = display.newImage("images/floor.png")
	floor2.name = "floor"
	floor2.x = 100
	floor2.y = 315
	physics.addBody(floor2, "static", { density=0.0, friction=.1, bounce=0.0 })
	sceneGroup:insert( floor2 )

	local floor3 = display.newImage("images/floor.png")
	floor3.name = "floor"
	floor3.x = 100
	floor3.y = 5
	physics.addBody(floor3, "static", { density=0.0, friction=.1, bounce=0.0 })
	sceneGroup:insert( floor3 )

	-- local frnd = Turet:newMageTuret(scene, "friend", 300, 200, -1)
	-- frnd:applyForce(-80, 0, frnd.x, frnd.y)

	local enemy = Turet:newMageTuret(scene, "enemy", 20, 200, 1, { HPMax=100 })
	local enemy2 = Turet:newMageTuret(scene, "enemy", 20, 50, 1, { HPMax=200 })

	-- enemy:applyForce(60,0,enemy.x,enemy.y)

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
	end

	Runtime:addEventListener("enterFrame", enterFrame)

	local gui = GuiControls:newGuiTuretMenu(scene)
	sceneGroup:insert( gui )

	function scene:newEnemy(event)
		local y = math.random(50, 200)
		local e = Turet:newMageTuret(scene, "enemy", 20, y, 1)
		print "enemy created"
		gui:toFront()
	end

	-- timer.performWithDelay(5000, newEnemy, -1)
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

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-----------------------------------------------------------------------------------------

return scene
