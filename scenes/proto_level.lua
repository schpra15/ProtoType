-----------------------------------------------------------------------------------------
--
-- testGameplay.lua
--
-- Contains just a quick prototype.
-----------------------------------------------------------------------------------------
-- Requires
---------------------------------------------------------------------------------
local composer = require( "composer" )

local allTurets = {}

local scene = composer.newScene()

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
	floor1.x = 100
	floor1.y = 150
	physics.addBody(floor1, "static", { density=0.0, friction=.1, bounce=0.0 })
	sceneGroup:insert( floor1 )

	local floor2 = display.newImage("images/floor.png")
	floor2.x = 100
	floor2.y = 315
	physics.addBody(floor2, "static", { density=0.0, friction=.1, bounce=0.0 })
	sceneGroup:insert( floor2 )

	local floor3 = display.newImage("images/floor.png")
	floor3.x = 100
	floor3.y = 5
	physics.addBody(floor3, "static", { density=0.0, friction=.1, bounce=0.0 })
	sceneGroup:insert( floor3 )

	local frnd = Turet:newTuret("friend", 500, 200)
	frnd:applyForce(-80, 0, frnd.x, frnd.y)
	sceneGroup:insert( frnd )
	table.insert(allTurets, frnd)

	local enemy = Turet:newTuret("enemy", 20, 200)
	enemy:applyForce(60,0,enemy.x,enemy.y)
	sceneGroup:insert( enemy )
	table.insert(allTurets, enemy)

	-- local enemy1 = Turet:newTuret("enemy", -30, 200)
	-- enemy1:applyForce(1,0,enemy1.x,enemy1.y)
	-- sceneGroup:insert( enemy1 )

	function enterFrame(event)
		for i=1, #allTurets do
			local turetA = allTurets[i]
			print(turetA.type)
			for j=1, #allTurets do
				if (i ~= j) then
					local turetB = allTurets[j]
					print(turetB.type)
					if (math.abs(turetA.x - turetB.x) < 100) then
						--stop the Turets
						turetA:setLinearVelocity(0,0)
						turetB:setLinearVelocity(0,0)
						break
					end
				end
			end
		end
	end

	Runtime:addEventListener("enterFrame", enterFrame)

	local gui = GuiControls:newGuiTuretMenu()
	sceneGroup:insert( gui )

	function bulletAppear()
		local bullet = display.newRect(0, 0, 16, 8)
		bullet.x= (enemy.x+10)
		bullet.y= (enemy.y-20)
		bullet.type = "enemy"
		bullet.collision = bulletCollision
		bullet:addEventListener("collision", bullet)
		physics.addBody(bullet, "dynamic", { density=1.0, friction=1, bounce=0.0 })
		bullet:applyForce(50,-15,bullet.x,bullet.y)
	end

	function bulletCollision(self, event)
		if event.phase=="began" then
			if event.target.type=="enemy" and event.other.type=="friend" then
				display.remove(self)
				event.other.HP = event.other.HP - 20
				print(event.other.HP)
				event.other:updateDamageBar()
				if (event.other.checkDead()) then
					display.remove(event.other)
				end
			end
		end
	end

	timer.performWithDelay(1000, bulletAppear, -1)

	-- all objects must be added to group (e.g. self.view)
	-- sceneGroup:insert( bg )
	-- sceneGroup:insert( title )
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
