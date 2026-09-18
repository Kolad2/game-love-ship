local require = require("src.tools.require_relative")
local Game = {}
require.set_loaded(".", Game)
require.set_loaded(".init", Game)
require.load_this_module()
return Game
