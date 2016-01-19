-----------------------------------------------------------------------------------------
local storyboard = require( "storyboard" )

local function main()
		storyboard.gotoScene ("mainMenu", {effect = "fade", time = 1500})
		return true
end

main()
-----------------------------------------------------------------------------------------