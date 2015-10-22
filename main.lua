local physics = require( "physics" )
local native = require( "native" )
local game = require "classes.game"
local turet = require "classes.turet"

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

--Displaying and making friendly Bodies
local frnd = display.newImage("friends.png")
frnd.x = 500
frnd.y = 200
frnd.type = "friend"
physics.addBody(frnd, "dynamic", { density=1.0, friction=0, bounce=0.0 })
frnd:applyForce(-80,0,frnd.x,frnd.y)


local enemy = display.newImage("enemies.png")
enemy.x = -80
enemy.y = 200
enemy.type = "enemy"
physics.addBody(enemy, "dynamic", { density=1.0, friction=0, bounce=0.0 })
enemy:applyForce(60,0,enemy.x,enemy.y)

local enemy1 = display.newImage("enemies.png")
enemy1.x = -30
enemy1.y = 200
enemy1.type = "enemy"
enemy1.collision = bulletCollision
enemy1:addEventListener("collision", enemy1)
physics.addBody(enemy1, "dynamic", { density=0.0, friction=0, bounce=0.0 })
enemy1:applyForce(1,0,enemy1.x,enemy1.y)


--drag and drop function
function frnd:touch(event)
	if event.phase == "began" then
		frnd.markX = frnd.x
		frnd.markY = frnd.y
		--self:scale(2,2)


	else if event.phase == "moved" then
		 local x = (event.x - event.xStart) + frnd.markX
		 local y = (event.y - event.yStart) + frnd.markY
	frnd.x, frnd.y = x, y
	--self:scale(.5,.5)
	end
	return true
end
end

function enemy:touch(event)
	if event.phase == "began" then
		d = enemy.x
		e = enemy.y
		--self:scale(2,2)


	else if event.phase == "moved" then
		 local a = (event.x - event.xStart) + d
		 local b = (event.y - event.yStart) + e
	enemy.x, enemy.y = a, b
	--self:scale(.5,.5)
	end
	return true
end
end



frnd:addEventListener("touch", frnd)
enemy:addEventListener("touch", enemy)








--Problem #1 The dragging mech is way too glichy
