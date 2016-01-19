local storyboard = require( "storyboard" )
local scene = storyboard.newScene()
fsm = require("fsm")
function scene:createScene( event )
	local group = self.view
end

function scene:enterScene(event)	
		local gamePlay = self.view
		local movieclip = require( "movieclip" )
		local widget = require( "widget" )
		local physics = require ("physics")
		local gravity = 9.8
		local birdCount = -1
		local birdRemain = 2
		local deadbat = 0
		physics.start()
		local gameWon
		local gameRestart
		local gameLost
		local scoreTitle
		local scoreDisplay
		local resetButton
		local bat1, bat2, bat3
		local game = display.newGroup();
		game.x = 0


		------------------------------------------------------------
		-- Sky and ground graphics
		------------------------------------------------------------
		local sky = display.newImage( "graphics/sky4.png", true )
		game:insert( sky )
		sky.x = 160; sky.y = 160

		local sky2 = display.newImage( "graphics/sky4.png", true )
		game:insert( sky2 )
		sky2.x = 1120; sky2.y = 160

		local grass = display.newImage( "graphics/grass.png", true )
		game:insert( grass )
		grass.x = 160
		grass.y = 310
		physics.addBody( grass, "static", { friction=0.5, bounce=0.3 } )

		local grass2 = display.newImage( "graphics/grass.png", true )
		game:insert( grass2 )
		grass2.x = 1120
		grass2.y = 310
		physics.addBody( grass2, "static", { friction=0.5, bounce=0.3 } )


		------------------------------------------------------------
		-- Construct bats
		------------------------------------------------------------
		 function loadBat()
		        local options =
		                   {
		                   -- The params below are required
		                    width = 56,
		                    height = 56,
		                    numFrames = 11,
		                   -- The params below are optional; used for dynamic resolution support
		                    sheetContentWidth = 616,  -- width of original 1x size of entire sheet
		                    sheetContentHeight = 56  -- height of original 1x size of entire sheet
		                   }

		        local imageSheet = graphics.newImageSheet( "graphics/darkbat.png", options )

		        local sequenceData =
		                        {
		                            name="fly",
		                            start=1,
		                            count=11,
		                            time=900,
		                            loopCount = 0,   -- Optional ; default is 0 (loop indefinitely)
		                            loopDirection = "forward"    -- Optional ; values include "forward" or "bounce"
		                        }
		        return display.newSprite ( imageSheet, sequenceData )

		end

		batBody = { density=15.0, friction=4.1, bounce=0.0, radius=10}
		--castleBodyHeavy = { density=12.0, friction=0.3, bounce=0.4 }

		bat1 = loadBat()
		bat1:play()
		game:insert( bat1 ); bat1.id = "bat1"
		physics.addBody( bat1, batBody )

		bat2 = loadBat()
		bat2:play()
		game:insert( bat2 ); bat2.id = "bat2"
		physics.addBody( bat2, batBody )

		bat3 = loadBat()
		bat3:play()
		game:insert( bat3 ); bat3.id = "bat3"
		physics.addBody( bat3, batBody )

		------------------------------------------------------------
		-- Simple score display
		scoreTitle = display.newText( "SCORE", 0, 0, native.systemFont, 15 )
		scoreTitle:setFillColor(0, 0, 0)
		scoreTitle.x = display.contentWidth / 2
		scoreTitle.y = 15

		scoreDisplay = display.newText( "0", 0, 0, native.systemFont, 15 )
		scoreDisplay:setFillColor(0, 0, 0)
		scoreDisplay.x = display.contentWidth / 2
		scoreDisplay.y = 30

		score = 0

		------------------------------------------------------------
		-- Launch bird

		local bird 	= display.newImage( "graphics/redbird.png" )
		local easingx  	= require("easing");
		game:insert( bird )
		physics.addBody( bird, { density=10.0, friction=10.0, bounce=0.0, radius=25 } )
		bird.bodyType = "kinematic"
		bird.x = 50
		bird.y = 290

		local bird2 	= display.newImage( "graphics/redbird.png" )
		local easingx  	= require("easing");
		game:insert( bird2 )
		physics.addBody( bird2, { density=10.0, friction=10.0, bounce=0.0, radius=25 } )
		bird2.bodyType = "kinematic"
		bird2.x = 20
		bird2.y = 290
		
		local function destroyObj(obj)
			display.remove(obj)
			obj=nil
		end

		local function resetValues()
				destroyObj(gameWon)
				destroyObj(gameRestart)
				destroyObj(gameNext)
				destroyObj(gameLost)	
				destroyObj(scoreTitle)
				destroyObj(scoreDisplay)
				destroyObj(resetButton)
				destroyObj(bat1) 
				destroyObj(bat2)
				destroyObj(bat3)
				score = 0
				gravity = 9.8
				birdCount = -1
				birdRemain = 2
				deadbat = 0
				game.x = 0
		end

		local function reload (event)
			if (event.phase == "began") then
				resetValues()
				gameRestart:removeEventListener ("touch", reload)
				storyboard.removeScene("Game4reload")
				storyboard.gotoScene ("playGame4", {effect = "fade", time = 500})
			end
		return true
		end

		local function nextLevel (event)
			if (event.phase == "began") then
				resetValues()
				gameRestart:removeEventListener ("touch", reload)
				gameNext:removeEventListener ("touch", nextLevel)
				storyboard.removeScene("Game4reload")
				storyboard.gotoScene ("mainMenu", {effect = "fade", time = 500})
			end
		return true
		end		

		local function loadMenu (event)
			if (event.phase == "began") then
				resetValues()
				gameRestart:removeEventListener ("touch", reload)
				gameNext:removeEventListener ("touch", loadMenu)
				storyboard.removeScene("Game4reload")
				storyboard.gotoScene ("mainMenu", {effect = "fade", time = 500})
			end
		return true
		end		

		local function resetbird()
			if birdCount == 0 then
				bird.bodyType = "kinematic"
				transition.to(bird, {time=600, y=200, transition = easingx.easeOutElastic})
				bird:setLinearVelocity( 0, 0 ) -- stop bird moving
				bird.angularVelocity = 0 -- stop bird rotating				
			elseif birdCount == 1 then
				destroyObj(bird)
				bird2.bodyType = "kinematic"
				transition.to(bird2, {time=600, y=200, transition = easingx.easeOutElastic})
				bird2:setLinearVelocity( 0, 0 ) -- stop bird moving
				bird2.angularVelocity = 0 -- stop bird rotating
			end	

		end

		local function checkGame()
			if deadbat == 3 then
					if birdRemain == 1 then
						score = score + 3000
						scoreDisplay.text = score
					end	
					gameWon = display.newImage("graphics/youwin.png", true)
					gameWon.x = display.contentWidth / 2
					gameWon.y = display.contentHeight / 2
					gameRestart = display.newImage("graphics/restart.png", true)
					gameRestart.x = (display.contentWidth / 2) + 20
					gameRestart.y = (display.contentHeight / 2)	+ 30
					gameNext = display.newImage("graphics/next.png", true)
					gameNext.x = (display.contentWidth / 2) + 120
					gameNext.y = (display.contentHeight / 2)	+ 30
					gameNext:addEventListener ("touch", nextLevel)
					gameRestart:addEventListener ("touch", reload)

			elseif deadbat < 3 and birdRemain == 0 then
					gameLost = display.newImage("graphics/youlose.png", true)
					gameLost.x = display.contentWidth / 2
					gameLost.y = display.contentHeight / 2		
					gameRestart = display.newImage("graphics/restart.png", true)
					gameRestart.x = (display.contentWidth / 2) + 20 
					gameRestart.y = (display.contentHeight / 2)	+ 30
					gameNext = display.newImage("graphics/menu.png", true)
					gameNext.x = (display.contentWidth / 2) + 120
					gameNext.y = (display.contentHeight / 2)	+ 30
					gameNext:addEventListener ("touch", loadMenu)
					gameRestart:addEventListener ("touch", reload)
			end	
		end

		function startListening()
			if bat1.postCollision then
				return
			end

			local function onbatCollision ( self, event )
				
				if ( event.force > 25.0 and event.force <= 55.0 ) then
					score = score + 150
					scoreDisplay.text = score


				elseif ( event.force > 55.0 ) then
					deadbat = deadbat + 1			
					score = score + 300
					scoreDisplay.text = score
					self:removeEventListener( "postCollision", self )
					destroyObj(self)
				end
			end


				bat1.postCollision = onbatCollision
				bat1:addEventListener( "postCollision", bat1 )
				
				bat2.postCollision = onbatCollision
				bat2:addEventListener( "postCollision", bat2 )
				
				bat3.postCollision = onbatCollision
				bat3:addEventListener( "postCollision", bat3 )
			
		end

		local function dropbird ( event )
			if  event.phase == "began"  then
		        if birdCount == 0 then
					startX = bird.x   
					startY = bird.y
				elseif birdCount == 1 then
					startX = bird2.x   
					startY = bird2.y
				end		
			elseif event.phase == "moved"  then	
				 if birdCount == 0 then
				    bird.x = event.x
				    bird.y = event.y
				elseif birdCount == 1 then
				    bird2.x = event.x
				    bird2.y = event.y
				end	    
			elseif event.phase == "ended" then
				if birdCount == 0 then
					bird.bodyType = "dynamic"
					bird:applyForce((50 - event.x)*200, (200 - event.y)*200, bird.x, bird.y)
					birdRemain = birdRemain - 1
				elseif birdCount == 1 then
					bird2.bodyType = "dynamic"
					bird2:applyForce((50 - event.x)*200, (200 - event.y)*200, bird2.x, bird2.y)
					birdRemain = birdRemain - 1
				end	
				startListening()
				timer.performWithDelay( 5000, checkGame)
			end
		end

		local function newRound( event )
			game.x = 0
			birdCount = birdCount + 1
			resetbird()
			return true
		end

		local function onUpdate( event )
 
		    local t = event.time * .004
		    bat1.x = 350 + 70 * math.cos(t*0.4)
		    bat1.y = 110 + 70 * math.sin(t*0.3)
		  	bat2.x = 300 + 70 * math.cos(t*0.3)
		    bat2.y = 150 + 70 * math.sin(t*0.4)
		    bat3.x = 280 + 70 * math.cos(t*0.8)
		    bat3.y = 130 + 70 * math.sin(t*0.2)
		 
		end

		resetButton = widget.newButton
		{
			defaultFile = "graphics/tab.png",
			overFile = "graphics/tab.png",
			label = "New bird",
			labelColor = 
			{ 
				default = { 255 }, 
			},
			emboss = true,
			onPress = newRound
		}

		resetButton.x = 30
		resetButton.y = 30
		timer.performWithDelay( 3000, startListening )
		bird:addEventListener( "touch", dropbird )
		bird2:addEventListener( "touch", dropbird )	
		Runtime:addEventListener( "enterFrame", onUpdate )	
		gamePlay:insert(game)
end
function scene:exitScene(event)	
	local group = self.view
	Runtime:removeEventListener("enterFrame", moveCamera)
	Runtime:removeEventListener( "enterFrame", onUpdate )
	bird:removeEventListener("touch", dropbird)
	bird2:removeEventListener("touch", dropbird)
	bat1:removeEventListener("postCollision", bat1) 
	bat2:removeEventListener("postCollision", bat2) 
	bat3:removeEventListener("postCollision", bat3)
	storyboard.removeScene("Game4reload")
end	

scene:addEventListener( "createScene", scene )
scene:addEventListener( "enterScene", scene )
scene:addEventListener( "exitScene" , scene)
return scene