-----------------------------------------------------------------------------------------
--
-- turet.lua
--
-- Defines the turet "class" to be used
-----------------------------------------------------------------------------------------
print "turet.lua initialized"

Turet = {} -- Define the turet utility object
Turet.classes = {"Fighter", "Mage", "Tank", "Support"}

function Turet:newTuret(type, x, y)

  local turet = display.newGroup()
  turet.x = x
  turet.y = y
  if (type == "friend") then
    turet.body = display.newImage(turet, "images/friends.png", 0, 0)
  else
    turet.body = display.newImage(turet, "images/enemies.png", 0, 0)
  end

  --- Initializes the turet.
  function turet:construct()
    -- Define the turet's stats
    turet.name = "Bob"
    turet.type = type
    turet.class = "Tank"
    turet.HP = 100
    turet.HPMax = 100
    turet.damage = 10
    turet.armor = 10
    turet.stamina = 100
    turet.deployCost = 100
    turet.deathReward = 10
    turet.ability = nil

    turet.isDragging = false;
    -- Add this as a physics body
    physics.addBody( turet, "dynamic", { density=100.0, friction=0, bounce=0.0 })

    -- Add the event listeners
    if (turet.type == "friend") then
      turet:addEventListener( "touch", turet )
    end

    turet.healthBar = display.newRect( 0, -30, turet.HPMax/2, 5)
    turet.healthBar:setFillColor( 000/255, 255/255, 0/255 )
    turet.healthBar.strokeWidth = 1
    turet.healthBar:setStrokeColor( 255, 255, 255, .5 )
    turet.healthBar.x = turet.x
    turet.healthBar.y = turet.y

    turet.damageBar = display.newRect(0,-30,0,5)
    turet.damageBar:setFillColor( 255/255, 0/255, 0/255 )

  end

  --- Represents the turet's behavior, which varies based
  -- on the class of turet.
  -- ------------------------------------------------
  function turet:handleBehavior(otherTuret)

    turet.healthBar.x = turet.x
    turet.healthBar.y = turet.y

    turet.damageBar.x = turet.x
    turet.damageBar.y = turet.y

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
    print("Name: "..turet.name)
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
    turet.damageBar.x = turet.HP / 4
    turet.damageBar.width = (turet.HPMax - turet.HP)/2
  end

  --- Prints out the turet's stats to the command line
  -- for developer's reference.
  -- ------------------------------------------------
  function turet:checkDead()
    return (turet.HP <= 0)
  end

  -- ------------------------------------------------
  -- Event listeners
  -- ------------------------------------------------
  --- Handles when a turet is touched.
  function turet:touch( event )
    if ( event.phase == "began" ) then
      --code executed when the button is touched
      display.getCurrentStage():setFocus( turet, event.id )
      print( "object touched = "..tostring(event.target) )  --'event.target' is the touched object
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
      --code executed when the touch is moved over the object
      turet.x = (event.x - event.xStart) + turet.markX
      turet.y = (event.y - event.yStart) + turet.markY
    elseif ( event.phase == "ended" ) then
      --code executed when the touch lifts off the object
      display.getCurrentStage():setFocus( nil, event.id )
      print( "touch ended on object "..tostring(event.target) )
      turet.isDragging = false
      physics.addBody( turet, "dynamic", { density=100.0, friction=0, bounce=0.0 })
      transition.to( turet, { time=200, xScale = 1, yScale = 1 })
    end
    return true  --prevents touch propagation to underlying objects
  end

  turet:construct()

  return turet
end

--- Declare a Mage Turet "class"
-- NOTE: This is not true inheritance.  Constructors will have to
-- be re-invoked, but all other function can be called and overriden.
function Turet:newMageTuret(type, x, y)
  local turet = Turet:newTuret(type,x,y)

  function turet:construct()
    turet.class = "Mage"
  end

  turet:construct()

  return turet
end
