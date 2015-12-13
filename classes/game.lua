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
Game.gamplayMode = 0
Game.currentLevel = 1

Game.myTurets = {
  {
    turetName = "Default-Fighter",
    class = "Fighter",
    HPMax = 100,
    damage = 10,
    armor = 1,
    stamina = 100,
    deployCost = 10,
    deathReward = 1
  },
  {
    turetName = "Default-Ranger",
    class = "Ranger",
    HPMax = 100,
    damage = 5,
    armor = 0,
    stamina = 100,
    deployCost = 10,
    deathReward = 1
  },
  {
    turetName = "Default-Tank",
    class = "Tank",
    HPMax = 100,
    damage = 0,
    armor = 2,
    stamina = 100,
    deployCost = 20,
    deathReward = 1
  },
  {
    turetName = "Default-Support",
    class = "Support",
    HPMax = 60,
    damage = 10,
    armor = 0,
    stamina = 100,
    deployCost = 20,
    deathReward = 1
  }
}

Game.levels = {
  -- Level 1: Basic level
	{
		floors = {
			{
				tower = 1, -- 0 = player, 1 = enemy
				theme = 0,
			},
			{
				tower = 0, -- 0 = player, 1 = enemy
				theme = 0,
			},
		},
    enemies = {
      {
        turetName = "Default-Ranger",
        class = "Ranger",
        HPMax = 100,
        damage = 5,
        armor = 0,
        stamina = 100,
        deployCost = 20,
        deathReward = 5
      },
    },
    startEnemyMoney = 50,
    descText = "Destroy the enemy's tower!",
		startMoney = 40,
		condition = 0,
    isUnlocked = true,
    isCleared = false,
	},
  -- Level 2: 3 Floors!
  {
    floors = {
      {
        tower = 1, -- 0 = player, 1 = enemy
        theme = 0,
      },
      {
        tower = 0, -- 0 = player, 1 = enemy
        theme = 0,
      },
      {
        tower = 1, -- 0 = player, 1 = enemy
        theme = 0,
      },
    },
    enemies = {
      {
        turetName = "Default-Ranger",
        class = "Ranger",
        HPMax = 100,
        damage = 6,
        armor = 0,
        stamina = 100,
        deployCost = 20,
        deathReward = 5
      },
    },
    startEnemyMoney = 100,
    descText = "Add another floor!",
    startMoney = 80,
    condition = 0,
    isUnlocked = false,
    isCleared = false,
  },
  -- Level 3: Protect two towers!
  {
    floors = {
      {
        tower = 0, -- 0 = player, 1 = enemy
        theme = 0,
      },
      {
        tower = 1, -- 0 = player, 1 = enemy
        theme = 0,
      },
      {
        tower = 0, -- 0 = player, 1 = enemy
        theme = 0,
      },
    },
    enemies = {
      {
        turetName = "Default-Ranger",
        class = "Ranger",
        HPMax = 100,
        damage = 5,
        armor = 0,
        stamina = 100,
        deployCost = 20,
        deathReward = 5
      },
    },
    startEnemyMoney = 50,
    descText = "Protect two towers!",
    startMoney = 100,
    condition = 0,
    isUnlocked = false,
    isCleared = false,
  },
}
