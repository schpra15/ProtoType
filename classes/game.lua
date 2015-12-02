-----------------------------------------------------------------------------------------
--
-- game.lua
--
-- Contains all global variables and functions for gameplay purposes.
-----------------------------------------------------------------------------------------
print "game.lua initialized"

Game = {} -- Define the game utility object

Game.money = 1000
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
