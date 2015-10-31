-----------------------------------------------------------------------------------------
--
-- turet.lua
--
-- Defines the turet "class" to be used
-----------------------------------------------------------------------------------------
print "turet.lua initialized"

Turet = {} -- Define the turet utility object
Turet.classes = {"Fighter", "Mage", "Tank", "Support"}

function Turet:newTuret(scene, type, x, y, direction, stats)

  local turet = display.newGroup()
  turet.name = "turet"
  turet.x = x
  turet.y = y
  if (type == "friend") then
    turet.body = display.newImage(turet, "images/friends.png", 0, 0)
    turet.filter = { groupIndex = -2 }
    turet.bulletFilter = { groupIndex = -2 }
  else
    turet.body = display.newImage(turet, "images/enemies.png", 0, 0)
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
      damage=10,
      armor=10,
      stamina=100,
      deploycost=100,
      deathReward=10
    } or stats)

    turet.HPMax = (stats.HPMax ~= nil and stats.HPMax or 100)
    turet.HP = turet.HPMax
    turet.damage = (stats.damage ~= nil and stats.damage or 10)
    turet.armor = (stats.armor ~= nil and stats.armor or 10)
    turet.stamina = (stats.stamina ~= nil and stats.stamina or 100)
    turet.deployCost = (stats.deployCost ~= nil and stats.deployCost or 100)
    turet.deathReward = (stats.deathReward ~= nil and stats.deathReward or 10)
    turet.ability = nil


    turet.isDragging = false
    turet.isDead = false
    turet.direction = direction
    -- Add this as a physics body
    physics.addBody( turet, "dynamic", { density=50.0, friction=1, bounce=0.0, filter=turet.filter })

    -- Add the event listeners
    if (turet.type == "friend") then
      turet:addEventListener( "touch", turet )
    end

    turet.healthBar = display.newGroup()
    turet.healthBar.alpha = 0.5
    -- turet:insert(turet.healthBar)
    turet.healthBarBase = display.newRect(turet.healthBar, 0, -30, turet.HPMax/2, 5)
    turet.healthBarBase:setFillColor( 100/255, 100/255, 100/255 )
    turet.healthBarBase.strokeWidth = 1
    turet.healthBarBase:setStrokeColor( 0, 0, 0, 1 )
    turet.healthBarBase.anchorX = 0
    turet.healthBarBase.x = -turet.healthBarBase.width/2
    -- turet.healthBar.x = turet.x
    -- turet.healthBar.y = turet.y

    turet.damageBar = display.newRect(turet.healthBar, 0, -30, turet.HPMax/2, 5)
    turet.damageBar:setFillColor( 0/255, 255/255, 0/255 )
    turet.damageBar.anchorX = 0
    turet.damageBar.x = -turet.healthBarBase.width/2

    Runtime:addEventListener("enterFrame", turet)

  end

  function turet:enterFrame(event)
    turet.healthBar.x = turet.x
    turet.healthBar.y = turet.y - (turet.isDragging and 30 or 0)
  end

  --- Represents the turet's behavior, which varies based
  -- on the class of turet.
  -- ------------------------------------------------
  function turet:handleBehavior(otherTuret)
    if (math.abs(turet.x - otherTuret.x) < 100) then
      --stop the Turets
      if (turet.setLinearVelocity~=nil) then
        local vx, vy = turet:getLinearVelocity()
        turet:setLinearVelocity(0, vy)
      end
    end
  end

  --- Prints out the turet's stats to the command line
  -- for developer's reference.
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

  --- Prints out the turet's stats to the command line
  -- for developer's reference.
  function turet:updateDamageBar()
    -- turet.damageBar.x = turet.HP / 4
    transition.to(turet.damageBar, {time=200, width=math.max(turet.HP, 0)/2 })
    -- turet.damageBar.width = math.max(turet.HPMax - turet.HP, 0)/2

    if (turet.HP/turet.HPMax < 0.25) then
        turet.damageBar:setFillColor( 1, 0, 0 )
    elseif (turet.HP/turet.HPMax < .6) then
        turet.damageBar:setFillColor( 1, 1, 0 )
    else
        turet.damageBar:setFillColor( 0, 1, 0)
    end
  end

  --- Prints out the turet's stats to the command line
  -- for developer's reference.
  -- ------------------------------------------------
  function turet:die()
    -- physics.removeBody(turet)
    turet.isDead = true
    if (turet.t ~= nil) then timer.cancel(turet.t) end
    transition.to(turet, { time=200, alpha=0, onComplete=function()
        display.remove(turet)
        display.remove(turet.healthBar)
        Runtime:removeEventListener("enterFrame", turet)
        -- Remove the turet
        for i=1, #scene.allTurets do
          if (scene.allTurets[i] == turet) then
              table.remove(scene.allTurets, i)
            break
          end
        end
        if (turet.type == "enemy") then
          scene:newEnemy()
        end
      end
    })
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
    end
    return true  --prevents touch propagation to underlying objects
  end

  turet:construct()

  scene.view:insert(turet)
  scene.view:insert(turet.healthBar)
  table.insert(scene.allTurets, turet)

  return turet
end

--- Declare a Mage Turet "class"
-- NOTE: This is not true inheritance.  Constructors will have to
-- be re-invoked, but all other function can be called and overriden.
function Turet:newMageTuret(scene, type, x, y, direction, stats)
  local turet = Turet:newTuret(scene, type, x, y, direction, stats)
  turet.t = {}

  function turet:construct()
    turet.class = "Mage"
    turet.t = timer.performWithDelay(1000, turet.t, -1)
  end

  function turet.t:timer(event)
    if (turet.isDragging) then return end
    local bullet = Turet:newBullet(scene, turet)

    turet:setLinearVelocity(turet.direction*20, 0)
  end

  turet:construct()

  return turet
end

--- Declare a Bullet "class"
-- This will be fired by Mage turets.
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
    if event.phase=="began" and event.other.name=="turet" then
      if event.target.type ~= event.other.type then
        event.target:die()
        event.other.HP = event.other.HP - event.target.damage
        event.other:updateDamageBar()
        if (not event.other.isDead and event.other.HP <= 0) then
          event.other:die()
        end
      end
    end
  end

  function bullet:enterFrame(event)
    if (bullet.x > display.contentWidth or bullet.x < 0) then
      bullet:die()
    end
  end

  function bullet:die(event)
    display.remove(bullet)
    Runtime:removeEventListener("enterFrame", bullet)
  end

  bullet:addEventListener("collision", bullet)
  physics.addBody(bullet, "dynamic", { density=1.0, friction=1, bounce=0.0, filter=turet.bulletFilter })
  -- bullet.gravityScale = 0
  bullet:applyForce(50*turet.direction, -15, bullet.x, bullet.y)

  Runtime:addEventListener("enterFrame", bullet)

  return bullet
end
