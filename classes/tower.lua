-----------------------------------------------------------------------------------------
--
-- tower.lua
--
-- Defines the tower "class" to be used
-----------------------------------------------------------------------------------------
print "tower.lua initialized"

Tower = {} -- Define the tower utility object

function Tower:newTower(scene, type, x, y, hp)

  local tower = display.newGroup()

  tower = display.newImage(tower, "images/tower.png", x, y)

  --- Initializes the turet.
  function tower:construct()
    tower.name = "tower"
    tower.type = type
    tower.anchorY = 1

    if (hp == nil) then hp = 100 end

    tower.HP = hp
    tower.HPMax = hp

  	physics.addBody(tower, "static", { density=500.0, friction=100, bounce=0.0 })

    tower.healthBar = Classes:newHealthBar(tower, 0, -40)
  end


  -- ------------------------------------------------
  -- Functions
  -- ------------------------------------------------
  --- Disposes the tower instance
  function tower:die()
    
  end

  -- ------------------------------------------------
  -- Event listeners
  -- ------------------------------------------------

  tower:construct()

  scene.gameView:insert(tower)
  scene.gameView:insert(tower.healthBar)
  table.insert(scene.towers, tower)

  return tower
end
