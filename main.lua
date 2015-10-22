-----------------------------------------------------------------------------------------
--
-- main.lua
--
-- Defines the starting point of the application
-----------------------------------------------------------------------------------------
local physics = require( "physics" )
local native = require( "native" )
local game = require "classes.game"
local libTuret = require ("classes.turet")

physics.start()

--Display Background
local background = display.newImage("background.png")
background.x = 100
background.y = 100

--Display and making floor bodies
local floor1 = display.newImage("floor.png")
floor1.x = 100
floor1.y = 150
physics.addBody(floor1, "static", { density=0.0, friction=.1, bounce=0.0 })

local floor2 = display.newImage("floor.png")
floor2.x = 100
floor2.y = 315
physics.addBody(floor2, "static", { density=0.0, friction=.1, bounce=0.0 })

local floor3 = display.newImage("floor.png")
floor3.x = 100
floor3.y = 5
physics.addBody(floor3, "static", { density=0.0, friction=.1, bounce=0.0 })

local function bulletCollision(self, event)
	if event.phase == "began" then
		if event.target.type == "enemy" and event.other.type == "friend" then
			display.remove(self)
			print("wow")
		end
	end
end

local frnd = Turet:newTuret("friend", 500, 200)
frnd:applyForce(-80, 0, frnd.x, frnd.y)

local enemy = Turet:newTuret("enemy", -80, 200)
enemy:applyForce(60,0,enemy.x,enemy.y)

local enemy1 = Turet:newTuret("enemy", -30, 200)
enemy1:applyForce(1,0,enemy1.x,enemy1.y)

-- GUI button
-- I will move this code somewhere else later
local turetListing = display.newGroup()
local turetListingBase = display.newRect(turetListing, -32, 16, 256, 128)
turetListing.anchorX = 0
turetListing.anchorY = 0
turetListingBase.alpha = .7
turetListing.x = 0
turetListing.y = display.contentHeight-16
turetListingBase.anchorX = 0
turetListingBase.anchorY = 1

for k, v in pairs(Turet.classes) do
	print(v)
	local box = display.newImage(turetListing, "friends.png", 48*(k-2) + 32, -48)
	box.anchorX = 0
	box.anchorY = 1
	local text = display.newText(turetListing, v, 48*(k-2) + 32, -48, native.systemFont, 12)
	text:setFillColor(0)
	text.anchorX = 0
	function box:touch(event)
		if event.phase == "began" then
			local t = Turet:newTuret("friend", event.x, event.y)
			print "steak"
		end
		return true
	end

	box:addEventListener("touch", box )
end

turetListing.isVisible = false

local guiButton = display.newGroup()
local guiButtonBase = display.newRect(guiButton, -32, 16, 64, 32)
local guiButtonText = display.newText(guiButton, "+ Turet", 0, 0, native.systemFont, 12)
guiButtonText:setFillColor(0)
guiButton.anchorX = 0
guiButton.anchorY = 0
guiButton.alpha = .7
guiButton.x = 0
guiButton.y = display.contentHeight-16
guiButtonBase.anchorX = 0
guiButtonBase.anchorY = 1

function buttonTouch(event)
		if event.phase == "began" and not guiButton.isActive then
			turetListing.isVisible = true
			turetListing.xScale = 0.1
			turetListing.yScale = 0.1
			guiButtonBase.isVisible = false
			transition.to(turetListing, {time=300, xScale=1, yScale=1})
			guiButtonText.text = "X"
			guiButton.isActive = true
		end
		return true
end

function xTouch(event)
	if event.phase == "began" and not guiButton.isActive then
		turetListing.isVisible = true
		turetListing.xScale = 0.1
		turetListing.yScale = 0.1
		guiButtonBase.isVisible = false
		transition.to(turetListing, {time=300, xScale=1, yScale=1})
		guiButtonText.text = "X"
		guiButton.isActive = true
elseif event.phase == "began" and guiButton.isActive then
		turetListing.isVisible = false
		guiButtonBase.isVisible = true
		transition.to(guiButtonBase, {time=300, xScale=1, yScale=1})
		guiButtonText.text = "+ Turet"
		guiButton.isActive = false
	end
	return true
end

guiButtonBase:addEventListener("touch", buttonTouch)
guiButtonText:addEventListener("touch", xTouch)

--Displaying and making friendly Bodies
-- local frnd = display.newImage("friends.png")
-- frnd.x = 500
-- frnd.y = 200
-- frnd.type = "friend"
-- physics.addBody(frnd, "dynamic", { density=1.0, friction=0, bounce=0.0 })
-- frnd:applyForce(-80,0,frnd.x,frnd.y)


-- local enemy = display.newImage("enemies.png")
-- enemy.x = -80
-- enemy.y = 200
-- enemy.type = "enemy"
-- physics.addBody(enemy, "dynamic", { density=1.0, friction=0, bounce=0.0 })
-- enemy:applyForce(60,0,enemy.x,enemy.y)

-- local enemy1 = display.newImage("enemies.png")
-- enemy1.x = -30
-- enemy1.y = 200
-- enemy1.type = "enemy"
-- enemy1.collision = bulletCollision
-- enemy1:addEventListener("collision", enemy1)
-- physics.addBody(enemy1, "dynamic", { density=0.0, friction=0, bounce=0.0 })
-- enemy1:applyForce(1,0,enemy1.x,enemy1.y)


--drag and drop function
-- function frnd:touch(event)
-- 	if event.phase == "began" then
-- 		frnd.markX = frnd.x
-- 		frnd.markY = frnd.y
-- 		--self:scale(2,2)
--
--
-- 	else if event.phase == "moved" then
-- 		 local x = (event.x - event.xStart) + frnd.markX
-- 		 local y = (event.y - event.yStart) + frnd.markY
-- 		frnd.x, frnd.y = x, y
-- 		--self:scale(.5,.5)
-- 		end
-- 		return true
-- 	end
-- end
--
-- function enemy:touch(event)
-- 	if event.phase == "began" then
-- 		d = enemy.x
-- 		e = enemy.y
-- 		--self:scale(2,2)
--
--
-- 	else if event.phase == "moved" then
-- 		 local a = (event.x - event.xStart) + d
-- 		 local b = (event.y - event.yStart) + e
-- 		enemy.x, enemy.y = a, b
-- 		--self:scale(.5,.5)
-- 		end
-- 		return true
-- 	end
-- end
--
--
--
-- frnd:addEventListener("touch", frnd)
-- enemy:addEventListener("touch", enemy)
--
--






--Problem #1 The dragging mech is way too glichy
