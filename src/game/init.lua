local Game = Game or {}
package.loaded["src.game"] = Game
package.loaded["src.game.init"] = Game
require("src.game.game")
return Game