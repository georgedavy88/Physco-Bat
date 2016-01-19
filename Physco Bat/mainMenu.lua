-----------------------------------------------------------------------------------------
-- Main menu 
-----------------------------------------------------------------------------------------
display.setStatusBar( display.HiddenStatusBar )
local storyboard = require( "storyboard" )
local scene = storyboard.newScene()
function scene:createScene( event )
	local menu = self.view
end

function scene:enterScene(event)	
 	local menu 					= self.view
	local menuBackground 	 	= display.newImageRect( "graphics/menubackground.png",display.contentWidth,display.contentHeight)
 	local playD 				= display.newText ("PLAY", (display.contentWidth / 2) - 5, 240, font, 30)
	menuBackground.x 			= display.contentWidth /2
	menuBackground.y 			= display.contentHeight /2
 	local function playDListener (event)
		if (event.phase == "began") then
			storyboard.gotoScene ("playGame1", {effect = "fade", time = 500})
		end
		return true
	end
	playD:addEventListener ("touch", playDListener)
	menu:insert (menuBackground)
	menu:insert (playD)
end
function scene:exitScene(event)	
	local group = self.view
	Runtime:removeEventListener("touch", playDListener)
	storyboard.removeScene("mainMenu")
end	
scene:addEventListener( "createScene", scene )
scene:addEventListener( "enterScene", scene )
scene:addEventListener( "exitScene", scene )
return scene