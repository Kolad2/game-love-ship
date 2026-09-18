local require = require("src.tools.require_relative")
local Game = Game or {}
package.loaded[require.path(".")] = Game
package.loaded[require.path(".init")] = Game
package.loaded["src.game.init"] = Game
require(".game")
return Game