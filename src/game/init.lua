local require_relative = require("src.tools.require_relative")
local Game = {}
----@diagnostic disable-next-line: duplicate-set-field
package.loaded[require_relative.path(".")] = Game
----@diagnostic disable-next-line: duplicate-set-field
package.loaded[require_relative.path(".init")] = Game
--package.loaded["src.game.init"] = Game
require_relative(".game")
return Game
