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
	
	tower.isDead = false

  	physics.addBody(tower, "static", { density=500.0, friction=100, bounce=0.0 })

    tower.healthBar = Classes:newHealthBar(tower, 0, -40)
  end


  -- ------------------------------------------------
  -- Functions
  -- ------------------------------------------------
  --- Computes the damage done to a turet
  function tower:takeDamage(damage)
    local totalDamage = math.max(damage, 1)
    tower.HP = tower.HP - totalDamage
    tower.healthBar:updateDamageBar()

    local txt = Classes:newFloatText(totalDamage, tower.x, tower.y-32, 1000)
    scene.gameView:insert(txt)

    if (not tower.isDead and tower.HP <= 0) then
      tower:die()
    end
  end
  
  --- Disposes the tower instance
  function tower:die()
    tower.isDead = true
	tower.healthBar:die()
	scene:notifyTowerDead(tower)
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
