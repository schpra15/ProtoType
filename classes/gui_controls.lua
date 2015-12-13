-----------------------------------------------------------------------------------------
--
-- gui_controls.lua
--
-- Defines the gui controls structures to be used
-----------------------------------------------------------------------------------------
print "gui_button.lua initialized"

GuiControls = {} -- Define the root of the object
-- Special variables for this "class"
-----------------------------------------------------------------------------------------
GuiControls.styles = {
	default = {
		strokeColor = { 0.7, 0.7, 0.7, 1 },
		fillColor = { 1, 1, 1, 1 },
		textColor = { 0.6, 0.6, 0.6, 1 },
		embrossColor = { highlight={ r=0, g=0, b=0 } }
	},
	default_disabled = {
		strokeColor = { 0.7, 0.7, 0.7, 1 },
		fillColor = { 0.81, 0.81, 0.81, 1 },
		textColor = { 0.6, 0.6, 0.6, 1 },
		embrossColor = { highlight={ r=0, g=0, b=0 } }
	},
	primary = {
		strokeColor = { 0, 0, 0.9, 1 },
		fillColor = { 0, 0, 1, 1 },
		textColor = { 1, 1, 1, 1 },
		embrossColor = { highlight={ r=0, g=0, b=0 } }
	},
	success = {
		strokeColor = { 0, 0.8, 0, 1 },
		fillColor = { 0, 0.9, 0, 1 },
		textColor = { 1, 1, 1, 1 },
		embrossColor = { highlight={ r=0, g=0, b=0 } }
	},
	warning = {
		strokeColor = { 0.7, 0.5, 0, 1 },
		fillColor = { 1, 0.8, 0, 1 },
		textColor = { 1, 1, 1, 1 },
		embrossColor = { highlight={ r=0, g=0, b=0 } }
	},
	danger = {
		strokeColor = { 0.7, 0, 0, 1 },
		fillColor = { 1, 0, 0, 1 },
		textColor = { 1, 1, 1, 1 },
		embrossColor = { highlight={ r=0, g=0, b=0 } }
	}
}

-- Functions
-----------------------------------------------------------------------------------------
--- Instantiates a new button, using our own templates
function GuiControls:newButton(x, y, width, height, text, style, onTouchEvent)
	if (style == nil or style.fillColor == nil) then
		style = GuiControls.styles.default
	end

	local grp = display.newGroup()
	grp.anchorX = 0.5
	grp.anchorY = 0.5
	grp.x = x
	grp.y = y

	local btn = display.newRoundedRect(grp, 0, 0, width, height, 1)
	btn.strokeWidth = 1
	btn:setFillColor(unpack(style.fillColor))
	btn:setStrokeColor(unpack(style.strokeColor))
	btn.anchorX = 0.5
	btn.anchorY = 0.5

	btn.isPressed = false
	btn.isEnabled = true

	btn:addEventListener("touch", function(event)
			if not btn.isEnabled then return end
			if event.phase == "began" then
				display.getCurrentStage():setFocus( event.target, event.id )
				transition.to(grp, {time=50, xScale=0.98, yScale=0.98})
				btn.isPressed = true
			elseif event.phase == "ended" and btn.isPressed then
				display.getCurrentStage():setFocus( nil, event.id )
				transition.to(grp, {time=50, xScale=1, yScale=1})
				onTouchEvent(event)
				btn.isPressed = false
			end

			return true
		end
	)

	local txt = display.newEmbossedText(grp, text, 0, 0, native.systemFont, 12 )
	txt.anchorX = 0.5
	txt.anchorY = 0.5
	txt:setFillColor(unpack(style.textColor))
	txt:setEmbossColor(style.embrossColor)


	function grp:setEnabled(enabled)
		btn.isEnabled = enabled
	end

	return grp
end

--- Instantiates a new turet menu, which is used for selecting turets to spawn.
function GuiControls:newGuiTuretMenu(scene)

	local menu = display.newGroup()
	local turetListing = display.newGroup()
	local turetListingBase = display.newRect(turetListing, 0, 16, 460, 200)
	local guiButton = display.newGroup()
	local guiButtonBase = display.newRect(guiButton, 0, 16, 96, 32)
	local guiButtonText = display.newText(guiButton, "+ Turet", 16, 0, native.systemFont, 12)

	-- Initialization
	---------------------------------------------------------------------------
	function menu:construct()
		local totalCols = 4

		guiButtonText:setFillColor(0)
		guiButton.anchorX = 0
		guiButton.anchorY = 0
		guiButton.alpha = .7
		guiButton.x = display.screenOriginX
		guiButton.y = display.screenOriginY + display.contentHeight-16
		guiButtonBase.anchorX = 0
		guiButtonBase.anchorY = 1
		guiButtonText.anchorX = 0
		guiButtonText.anchorY = 0.5

		turetListing.anchorX = 0
		turetListing.anchorY = 1
		turetListing.x = display.screenOriginX
		turetListing.y = display.screenOriginY + display.contentHeight
		turetListing.anchorChildren = true
		turetListingBase.alpha = .7
		turetListingBase.anchorX = 0
		turetListingBase.anchorY = 1

		-- Add the different turets to the menu
		for k, v in pairs(Game.myTurets) do
			local row = (k > totalCols and 2 or 1)
			local col = k - totalCols*(row-1)

			local box = display.newImage(turetListing, "images/friends.png", 96*(col-1) + 64, -(turetListing.height-80*row))
			box.anchorX = 0
			box.anchorY = 1
			box.holdCount = -1
			local text = display.newText(turetListing, v.turetName, box.x+12, box.y, native.systemFont, 10)
			text:setFillColor(0)
			text.anchorX = 0.5
			-- Give the turet button a touch event, so the player can spawn it
			-- The player will need to hold down his/her finger on the turet
			-- icon and drag in order to spawn it.  Pressing and releasing will
			-- not work (it is prevented so the user doesn't sporaticly spawn turets).
			function box:touch(event)
				if event.phase == "began" then
					box.holdCount = 0
				elseif event.phase == "moved" then
					if (box.holdCount == -1) then
						return
					end
					box.holdCount = box.holdCount + 1
					if box.holdCount > 1 then
						local x, y = scene.scrollView:getContentPosition()

						if (Game.levelMoney - v.deployCost < 0) then
							-- Throw code in here as a warning

						elseif (v.class == "Ranger") then
								-- We have to offset the x position because of the scrollview's offset.
								-- The GUI control is not part of the scrollview, so its positioning is different.
								local t = Turet:newRangerTuret(scene, "friend", event.x-display.screenOriginX, event.y - y, 1, v)
								Game.levelMoney = Game.levelMoney - v.deployCost
								hideTuretMenu()
						elseif (v.class == "Support") then
								-- We have to offset the x position because of the scrollview's offset.
								-- The GUI control is not part of the scrollview, so its positioning is different.
								local t = Turet:newSupportTuret(scene, "friend", event.x-display.screenOriginX, event.y - y, 1, v)
								Game.levelMoney = Game.levelMoney - v.deployCost
								hideTuretMenu()
						else
								local t = Turet:newTuret(scene, "friend", event.x-display.screenOriginX, event.y - y, 1, v)
								Game.levelMoney = Game.levelMoney - v.deployCost
								hideTuretMenu()
						end

						box.holdCount = -1
						menu:toFront()
					end
				else
					box.holdCount = -1
				end
				return true
			end
			box:addEventListener("touch", box )
		end

		turetListing.isVisible = false

		guiButtonBase:addEventListener("touch", buttonTouch)
		guiButtonText:addEventListener("touch", textTouch)

		menu:insert(guiButton)
		menu:insert(turetListing)
	end

	-- Functions
	---------------------------------------------------------------------------
	function showTuretMenu()
		turetListing.isVisible = true
		guiButtonBase.isVisible = false
		transition.from(turetListing, {time=300, xScale=0.001, yScale=0.001})
		guiButtonText.text = "X"
		guiButton:toFront()
		guiButton.isActive = true
		menu:toFront()
	end

	function hideTuretMenu()
		turetListing.isVisible = false
		guiButtonBase.isVisible = true
		--transition.from(turetListing, {time=300, xScale=0.001, yScale=0.001})
		guiButtonText.text = "+ Turet"
		guiButton.isActive = false
	end

	-- Event listeners
	---------------------------------------------------------------------------
	-- Activates when the button base is touched
	function buttonTouch(event)
			if event.phase == "began" and not guiButton.isActive then
				showTuretMenu()
			end
			return true
	end

	-- Activates when the button text is touched (the event does not propogate)
	function textTouch(event)
		if event.phase == "began" and not guiButton.isActive then
			showTuretMenu()
	elseif event.phase == "began" and guiButton.isActive then
			hideTuretMenu()
		end
		return true
	end

	menu:construct()

  return menu
end
