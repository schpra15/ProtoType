-----------------------------------------------------------------------------------------
--
-- turet.lua
--
-- Defines the turet "class" to be used
-----------------------------------------------------------------------------------------
print "turet.lua initialized"

Turet = {} -- Define the turet utility object
Turet.classes = {"Fighter", "Ranger", "Tank", "Support"}

function Turet:newTuretByClass(scene, class, type, x, y, direction, stats)
  if (class == "Ranger") then
    return Turet:newRangerTuret(scene, type, x, y, direction, stats)
  elseif (class == "Tank") then
    return Turet:newTankTuret(scene, type, x, y, direction, stats)
  elseif (class == "Support") then
    return Turet:newSupportTuret(scene, type, x, y, direction, stats)
  end

  return Turet:newTuret(scene, type, x, y, direction, stats)
end

function Turet:newTuret(scene, type, x, y, direction, stats)

  local turet = display.newGroup()
  turet.name = "turet"
  turet.x = x
  turet.y = y
  if (type == "friend") then
    turet.body = display.newImage(turet, "images/turet.png", 0, 0)
    turet.body.xScale = -direction
    turet.filter = { groupIndex = -2 }
    turet.bulletFilter = { groupIndex = -2 }
  else
    turet.body = display.newImage(turet, "images/turet.png", 0, 0)
    turet.body.xScale = -direction
    turet.filter = { groupIndex = -3 }
    turet.bulletFilter = { groupIndex = -3 }
  end

  --- Initializes the turet.
  function turet:construct()
    -- Define the turet's stats
    turet.turetName = "Bob" -- Not to be confused with turet.name.  turet.name is a displayObject property used to identify the object
    turet.type = type
    turet.class = "Fighter"

    stats = (stats == nil and {
      HPMax=100,
      damage=50,
      armor=0,
      stamina=100,
      deploycost=100,
      deathReward=10
    } or stats)

    turet.HPMax = (stats.HPMax ~= nil and stats.HPMax or 100)
    turet.HP = turet.HPMax
    turet.damage = (stats.damage ~= nil and stats.damage or 10)
    turet.armor = (stats.armor ~= nil and stats.armor or 0)
    turet.stamina = (stats.stamina ~= nil and stats.stamina or 100)
    turet.deployCost = (stats.deployCost ~= nil and stats.deployCost or 100)
    turet.deathReward = (stats.deathReward ~= nil and stats.deathReward or 10)
    turet.ability = nil

    turet.isDragging = false
    turet.isDead = false
    turet.direction = direction
    -- Add this as a physics body
    physics.addBody( turet, "dynamic", { density=50.0, friction=2, bounce=0.0, filter=turet.filter })

    -- Add the event listeners
    if (turet.type == "friend") then
      turet:addEventListener( "touch", turet )
    end

    turet.healthBar = Classes:newHealthBar(turet, 0, 0)

  end

  --- Represents the turet's behavior, which varies based
  -- on the class of turet.
  -- ------------------------------------------------
  function turet:handleBehavior(otherTuret)
    if (math.abs(turet.x - otherTuret.x) < 70) then
      --stop the Turets
      if (turet.setLinearVelocity~=nil) then
        local vx, vy = turet:getLinearVelocity()
        turet:setLinearVelocity(0, vy)
      end
    else
      if (turet.setLinearVelocity~=nil) then
        local vx, vy = turet:getLinearVelocity()
        turet:setLinearVelocity(20, vy)
      end
    end
  end

  --- Computes the damage done to a turet
  -- ------------------------------------------------
  function turet:takeDamage(damage)
    local totalDamage = math.max(damage - turet.armor, 1)
    turet.HP = turet.HP - totalDamage
    turet.healthBar:updateDamageBar()

    local txt = Classes:newFloatText(totalDamage, turet.x, turet.y-32, 1000)
    scene.gameView:insert(txt)

    if (not turet.isDead and turet.HP <= 0) then
      turet:die()
    end
  end

  --- Prints out the turet's stats to the command line
  -- for developer's reference.
  -- ------------------------------------------------
  function turet:printStats()
    print("Name: "..turet.turetName)
    print("Class: "..turet.class)
    print("HP: "..turet.HP)
    print("Damage: "..turet.damage)
    print("Armor: "..turet.armor)
    print("Stamina: "..turet.stamina)
    print("Deploy $: "..turet.deployCost)
    print("Death Reward $: "..turet.deathReward)
  end

  --- Removes the turet from the game, using a
  -- transition.
  -- ------------------------------------------------
  function turet:die()
    turet.isDead = true
    if (turet.t ~= nil) then timer.cancel(turet.t) end
    transition.to(turet, { time=200, alpha=0, onComplete=function()
		turet:delete()
        if (turet.type == "enemy") then
          scene:notifyEnemyDead(turet)
        end
      end
    })
  end

  --- Removes the turet immediately from the game.
  -- ------------------------------------------------
  function turet:delete()
  	turet.healthBar:die()
  	display.remove(turet)
  	-- Remove the turet
  	for i=1, #scene.turets do
  	  if (scene.turets[i] == turet) then
  		  table.remove(scene.turets, i)
  		break
  	  end
  	end
  end

  -- ------------------------------------------------
  -- Event listeners
  -- ------------------------------------------------
  --- Handles when a turet is touched.
  function turet:touch( event )
    if ( event.phase == "began" ) then
      --code executed when the button is touched
      display.getCurrentStage():setFocus( turet, event.id )
      turet.isDragging = true
      turet.markX = turet.x
      turet.markY = turet.y
      physics.removeBody(turet)
      transition.to( turet, { time=200, xScale = 2, yScale = 2 })
    elseif ( event.phase == "moved" ) then
      -- handle the case where the event starts as "moved" (when dragging a new turet)
      if (turet.markX == nil) then
          display.getCurrentStage():setFocus( turet, event.id )
          turet.markX = turet.x
          turet.markY = turet.y
          turet.isDragging = true
          physics.removeBody(turet)
          transition.to( turet, { time=200, xScale = 2, yScale = 2 })
      end
      if (turet.isDragging) then
        --code executed when the touch is moved over the object
        turet.x = (event.x - event.xStart) + turet.markX
        turet.y = (event.y - event.yStart) + turet.markY
      end
    elseif ( event.phase == "ended" ) then
      --code executed when the touch lifts off the object
      display.getCurrentStage():setFocus( nil, event.id )
      turet.isDragging = false
      physics.addBody( turet, "dynamic", { density=100.0, friction=1, bounce=0.0, filter=turet.filter })
      transition.to( turet, { time=200, xScale = 1, yScale = 1 })

      if (turet.x > display.contentWidth/2) then
        transition.to( turet, { time=200, x = display.contentWidth/2 })
      end
    end
    return true  --prevents touch propagation to underlying objects
  end

  turet:construct()

  scene.gameView:insert(turet)
  scene.gameView:insert(turet.healthBar)
  table.insert(scene.turets, turet)

  return turet
end
--------------------------------------------------------------------------------------------------------------
--- Declare a Tank Turet "class"
-- NOTE: This is not true inheritance.  Constructors will have to
-- be re-invoked, but all other function can be called and overriden.
function Turet:newTankTuret(scene, type, x, y, direction, stats)
  local turet = Turet:newTuret(scene, type, x, y, direction, stats)
  turet.t = {}

  function turet:construct()
    turet.class = "Tank"
  end

  function turet.t:timer(event)
    if (turet.isDragging) then return end
  end

  --- Represents the turet's behavior, which varies based
  -- on the class of turet.
  -- ------------------------------------------------
  function turet:handleBehavior(otherTuret)

  end

  turet:construct()

  return turet
end

--------------------------------------------------------------------------------------------------------------
--- Declare a Ranger Turet "class"
-- NOTE: This is not true inheritance.  Constructors will have to
-- be re-invoked, but all other function can be called and overriden.
function Turet:newRangerTuret(scene, type, x, y, direction, stats)
  local turet = Turet:newTuret(scene, type, x, y, direction, stats)
  turet.t = {}
  turet.isTuretNear = false

  function turet:construct()
    turet.class = "Ranger"
    turet.t = timer.performWithDelay(1000, turet.t, -1)
  end

  function turet.t:timer(event)
    if (turet.isDragging) then return end
    local bullet = Turet:newBullet(scene, turet)

    --turet:setLinearVelocity(turet.direction*20, 0)
  end

  --- Represents the turet's behavior, which varies based
  -- on the class of turet.
  -- ------------------------------------------------
  function turet:handleBehavior(otherTuret)
    if (math.abs(turet.x - otherTuret.x) < 500 and math.abs(turet.y - otherTuret.y) < 100 and turet.type ~= otherTuret.type) then
      turet.isTuretNear = true
      --stop the Turets
      -- if (turet.setLinearVelocity~=nil) then
      --   local vx, vy = turet:getLinearVelocity()
      --   turet:setLinearVelocity(0, vy)
      -- end
    else
      turet.isTuretNear = false
    end
  end

  function turet:delete()
    turet.healthBar:die()
    timer.cancel(turet.t)
    print('timer removed')
    display.remove(turet)
    -- Remove the turet
    for i=1, #scene.turets do
      if (scene.turets[i] == turet) then
        table.remove(scene.turets, i)
      break
      end
    end
  end

  turet:construct()

  return turet
end

--------------------------------------------------------------------------------------------------------------
--- Declare a Support Turet "class"
-- NOTE: This is not true inheritance.  Constructors will have to
-- be re-invoked, but all other function can be called and overriden.
function Turet:newSupportTuret(scene, type, x, y, direction, stats)
  local turet = Turet:newTuret(scene, type, x, y, direction, stats)
  turet.t = {}
  turet.isTuretNear = false

  function turet:construct()
    turet.class = "Support"
    turet.t = timer.performWithDelay(3000, turet.t, -1)
  end

  function turet.t:timer(event)
    if (turet.isDragging) then return end

    -- create a healing force field
    Turet:newHealField(scene, turet)
  end

  --- Represents the turet's behavior, which varies based
  -- on the class of turet.
  -- ------------------------------------------------
  function turet:handleBehavior(otherTuret)
    if (math.abs(turet.x - otherTuret.x) < 500 and math.abs(turet.y - otherTuret.y) < 100 and turet.type ~= otherTuret.type) then
      turet.isTuretNear = true
      --stop the Turets
      -- if (turet.setLinearVelocity~=nil) then
      --   local vx, vy = turet:getLinearVelocity()
      --   turet:setLinearVelocity(0, vy)
      -- end
    else
      turet.isTuretNear = false
    end
  end

  turet:construct()

  return turet
end

--------------------------------------------------------------------------------------------------------------
--- Declare a Heal Field "class"
-- This will be fired by Ranger turets.
function Turet:newHealField(scene, turet)
  local healField = display.newCircle(0, 0, 50)
  healField.name = "healField"
  healField.x = turet.x
  healField.y = turet.y
  healField.type = turet.type
  healField.damage = turet.damage

  transition.to( healField, { time=2000, xScale=2, yScale=2, alpha=0, onComplete=function(e)
    healField:die()
  end })

  function healField:collision(event)
    --event.contact.isEnabled = false
    if event.phase=="began" then
      if event.target.type == event.other.type then
        if (event.other.name == "turet" and event.other ~= turet) then
          -- heal it
          self:healObject(event.other)
        elseif (event.other.name == "tower") then
          -- heal it
            self:healObject(event.other)
        end
      end
      return true
    end
  end

  function healField:healObject(obj)
    if (obj.HP + self.damage > obj.HPMax) then
      obj.HP = obj.HPMax
    else
      obj.HP = obj.HP + self.damage
    end
    obj.healthBar:updateDamageBar()

    local txt = Classes:newFloatText(self.damage, obj.x, obj.y-32, 1000)
    txt:setFillColor(0,1,0,1)
    scene.gameView:insert(txt)
  end

  function healField:enterFrame(event)
    --healField:scale(2, 2)
  end

  function healField:die(event)
    Runtime:removeEventListener("enterFrame", healField)
    display.remove(healField)
    scene:removeObject(healField)
  end

  healField:addEventListener("collision", healField)
  physics.addBody(healField, "dynamic", { density=1.0, friction=0, bounce=0.0 })
  healField.isSensor = true
  healField.gravityScale = 0
  Runtime:addEventListener("enterFrame", healField)

  scene.gameView:insert(healField)
  table.insert(scene.objects, healField)

  return healField
end


--------------------------------------------------------------------------------------------------------------
--- Declare a Bullet "class"
-- This will be fired by Ranger turets.
function Turet:newBullet(scene, turet)
  local bullet = display.newRect(0, 0, 16, 8)
  bullet.name = "bullet"
  bullet.x = (turet.x+20*turet.direction)
  bullet.y = (turet.y-5)
  bullet.type = turet.type
  bullet.damage = turet.damage

  function bullet:collision(event)
    if (event.other.name == bullet.name) then
      event.contact.isEnabled = false
      return true
    end
    if event.phase=="began" then
      if event.target.type ~= event.other.type then
        if (event.other.name == "turet") then
          event.target:die()
          event.other:takeDamage(event.target.damage)
        elseif (event.other.name == "tower") then
          event.target:die()
	        event.other:takeDamage(event.target.damage)
        end
      end
      return true
    end
  end

  function bullet:enterFrame(event)
    if (bullet.x > display.contentWidth-display.screenOriginX*2 or bullet.x < 0) then
      bullet:die()
    end
  end

  function bullet:die(event)
    Runtime:removeEventListener("enterFrame", bullet)
    display.remove(bullet)
    scene:removeObject(bullet)
  end

  bullet:addEventListener("collision", bullet)
  physics.addBody(bullet, "dynamic", { density=1.0, friction=1, bounce=0.0, filter=turet.bulletFilter })
  -- bullet.gravityScale = 0
  bullet:applyForce(50*turet.direction, -15, bullet.x, bullet.y)

  Runtime:addEventListener("enterFrame", bullet)

  scene.gameView:insert(bullet)
  table.insert(scene.objects, bullet)

  return bullet
end
