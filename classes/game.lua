-----------------------------------------------------------------------------------------
--
-- game.lua
--
-- Contains all global variables and functions for gameplay purposes.
-----------------------------------------------------------------------------------------
print "game.lua initialized"

Game = {} -- Define the game utility object

Game.money = 0
Game.levelMoney = 0
Game.currentLevel = 1

Game.myTurets = {
  {
    turetName = "TestFighter",
    class = "Fighter",
    HPMax = 100,
    damage = 10,
    armor = 1,
    stamina = 100,
    deployCost = 100,
    deathReward = 10
  },
  {
    turetName = "TestMage",
    class = "Mage",
    HPMax = 100,
    damage = 10,
    armor = 0,
    stamina = 100,
    deployCost = 100,
    deathReward = 10
  },
  {
    turetName = "TestTank",
    class = "Tank",
    HPMax = 100,
    damage = 0,
    armor = 4,
    stamina = 100,
    deployCost = 200,
    deathReward = 10
  }
}

Game.levels = {
	{
		floors = {
			{
				tower = 1, -- 0 = player, 1 = enemy
				theme = 0,
			},
			{
				tower = 0, -- 0 = player, 1 = enemy
				theme = 0,
			},			{
				tower = 0, -- 0 = player, 1 = enemy
				theme = 0,
			},			{
				tower = 0, -- 0 = player, 1 = enemy
				theme = 0,
			},			{
				tower = 0, -- 0 = player, 1 = enemy
				theme = 0,
			},			{
				tower = 0, -- 0 = player, 1 = enemy
				theme = 0,
			},			{
				tower = 0, -- 0 = player, 1 = enemy
				theme = 0,
			},
		},
		startMoney = 1000,
		condition = 0
	},
}