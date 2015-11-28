-----------------------------------------------------------------------------------------
--
-- classes.lua
--
-- Defines other utility classes.
-----------------------------------------------------------------------------------------
print "classes.lua initialized"

Classes = {} -- Define the tower utility object

-----------------------------------------------------------------------------
--- Creates a new healthbar, which will update based on the object passed in.
function Classes:newHealthBar(obj, offsetX, offsetY)
  local healthBar = display.newGroup()
  healthBar.alpha = 0.5

  local healthBarBase = display.newRect(healthBar, 0, -30, 50, 5)
  healthBarBase:setFillColor( 100/255, 100/255, 100/255 )
  healthBarBase.strokeWidth = 1
  healthBarBase:setStrokeColor( 0, 0, 0, 1 )
  healthBarBase.anchorX = 0
  healthBarBase.x = -healthBarBase.width/2

  local damageBar = display.newRect(healthBar, 0, -30, 50, 5)
  damageBar:setFillColor( 0/255, 255/255, 0/255 )
  damageBar.anchorX = 0
  damageBar.x = -healthBarBase.width/2

  Runtime:addEventListener("enterFrame", healthBar)

  function healthBar:enterFrame(event)
    healthBar.x = obj.x + offsetX
    healthBar.y = obj.y + offsetY
  end

  --- Fades the damage on the healthbar
  function healthBar:updateDamageBar()
    -- turet.damageBar.x = turet.HP / 4
    transition.to(damageBar, {time=200, width=math.max(obj.HP/obj.HPMax*50, 0) })
    -- turet.damageBar.width = math.max(turet.HPMax - turet.HP, 0)/2

    if (obj.HP/obj.HPMax < 0.25) then
        damageBar:setFillColor( 1, 0, 0 )
    elseif (obj.HP/obj.HPMax < .6) then
        damageBar:setFillColor( 1, 1, 0 )
    else
        damageBar:setFillColor( 0, 1, 0)
    end
  end

  function healthBar:die()
    Runtime:removeEventListener("enterFrame", healthBar)
    display.remove(healthBar)
  end

  return healthBar
end

-----------------------------------------------------------------------------
--- Creates a new healthbar, which will update based on the object passed in.
function Classes:newFloatText(text, x, y, time)
  local txt = display.newEmbossedText(text, x, y, native.systemFontBold, 16)
		txt.anchorX = 0.5
		txt.anchorY = 0.5
		txt:setFillColor(1, 1, 1, 1)
		--txt:setEmbossColor(GuiControls.styles.success.embrossColor)

    transition.to(txt, { time=time, alpha=0, y=y-10, onComplete=function()
      display.remove(txt)
      end
    })

  return txt
end

-----------------------------------------------------------------------------
--- Creates text that will update its value when the value is changed.  It
-- will have a numeric scrolling effect.
function Classes:newUpdateText(text, x, y, value)

  local txt = display.newEmbossedText(text..value, x, y, native.systemFontBold, 20)
    txt.anchorX = 0
    txt.anchorY = 0
    txt:setFillColor(0, 0.7, 0, 1)
    txt:setEmbossColor(GuiControls.styles.success.embrossColor)

    txt.displayValue = value
    txt.newValue = value

    function txt:enterFrame(event)
      if (txt.displayValue ~= txt.newValue) then
          txt.displayValue = math.floor(txt.displayValue + 0.5 * (txt.newValue - txt.displayValue))
          txt.text = text..txt.displayValue
      end
    end

    function txt:setValue(val)
      txt.newValue = val
    end

    Runtime:addEventListener("enterFrame", txt)

  return txt
end
