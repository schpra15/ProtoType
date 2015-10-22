-----------------------------------------------------------------------------------------
--
-- turet.lua
--
-- Defines the turet "class" to be used
-----------------------------------------------------------------------------------------
print "turet.lua initialized"

Turet = {} -- Define the turet utility object

function Turet:newTuret(x, y)
  local turet = display.newRect( x, y, 32, 32 )

  function turet:construct()
    -- Define the turet's stats
    turet.name = "Bob"
    turet.type = "Tank"
    turet.HP = 0
    turet.damage = 10
    turet.armor = 10
    turet.stamina = 100
    turet.deployCost = 100
    turet.deathReward = 10
    turet.ability = nil

    turet.isDragging = false;
    -- Add this as a physics body
    physics.addBody( turet )

    -- Add the event listeners
    turet:addEventListener( "touch", onTouch )

    turet:printStats()
  end

  function onTap( event )
    print("You tapped "..turet.name)
    turet:applyForce( 0.1, 0.1, event.x - turet.x, event.y - turet.y)
    return true
  end

  function onTouch( event )
    if ( event.phase == "began" ) then
      --code executed when the button is touched
      print( "object touched = "..tostring(event.target) )  --'event.target' is the touched object
      turet.isDragging = true
      turet.markX = turet.x
      turet.markY = turet.y
      turet.gravityScale = 0
      turet:setLinearVelocity(0,0)
      turet:scale(2,2)
    elseif ( event.phase == "moved" ) then
      --code executed when the touch is moved over the object
      turet.x = (event.x - event.xStart) + turet.markX
      turet.y = (event.y - event.yStart) + turet.markY
    elseif ( event.phase == "ended" ) then
      --code executed when the touch lifts off the object
      print( "touch ended on object "..tostring(event.target) )
      turet.isDragging = false
      turet.gravityScale = 1
      turet:scale(0.5,0.5)
    end
    return true  --prevents touch propagation to underlying objects
  end

  -- Prints out the turet's stats to the command line
  -- for developer's reference.
  -- ------------------------------------------------
  function turet:printStats()
    print("Name: "..turet.name)
    print("Class: "..turet.type)
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
