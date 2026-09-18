local require = require("src.tools.require_relative")
local Game = {}
package.loaded[require.path(".")] = Game
package.loaded[require.path(".init")] = Game
require(".game")
return Game
