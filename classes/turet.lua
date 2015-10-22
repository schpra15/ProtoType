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

  local turet = nil
  if (type == "friend") then
    turet = display.newImage("friends.png", x, y)
  else
    turet = display.newImage("enemies.png", x, y)
  end

  --[[
    Initializes the turet.
  ]]--
  function turet:construct()
    -- Define the turet's stats
    turet.name = "Bob"
    turet.type = type
    turet.class = "Tank"
    turet.HP = 0
    turet.damage = 10
    turet.armor = 10
    turet.stamina = 100
    turet.deployCost = 100
    turet.deathReward = 10
    turet.ability = nil

    turet.isDragging = false;
    -- Add this as a physics body
    physics.addBody( turet, "dynamic", { density=1.0, friction=0, bounce=0.0 })

    -- Add the event listeners
    if (turet.type == "friend") then
      turet:addEventListener( "touch", onTouch )
    end

    turet:printStats()
  end

  --[[
    Handles when a turet is touched.
  ]]--
  function onTouch( event )
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
      physics.addBody( turet, "dynamic", { density=1.0, friction=0, bounce=0.0 })
      transition.to( turet, { time=200, xScale = 1, yScale = 1 })
    end
    return true  --prevents touch propagation to underlying objects
  end

  -- Prints out the turet's stats to the command line
  -- for developer's reference.
  -- ------------------------------------------------
  function turet:printStats()
    print("Name: "..turet.name)
    print("Class: "..turet.class)
    print("HP: "..turet.HP)
    print("Damage: "..turet.damage)
    print("Armor: "..turet.armor)
    print("Stamina: "..turet.stamina)
    print("Deploy $: "..turet.deployCost)
    print("Death Reward $: "..turet.deathReward)
    --print("Ability: "..turet.ability)
  end

  turet:construct()

  return turet
end
