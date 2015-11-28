-----------------------------------------------------------------------------------------
--
-- main.lua
--
-- Defines the starting point of the application
-----------------------------------------------------------------------------------------
local physics = require( "physics" )
local native = require( "native" )
local composer = require( "composer" )

-- Load the necessary classes
require ("classes.classes")
require ("classes.game")
require ("classes.turet")
require ("classes.gui_controls")
require ("classes.tower")

-- Navigate to the main menu scene
composer.gotoScene("scenes.main_menu")
