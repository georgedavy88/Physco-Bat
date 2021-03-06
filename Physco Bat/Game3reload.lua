local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

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
		local arrow	
		local scoreTitle
		local scoreDisplay
		local resetButton
		local wall1, wall2, wall3
		local beam, beam2
		local roof, roof2, roof3, roof4
		local bat1, bat2, bat3, bat4
		local rock1, rock2
		local egg
		local eggflag = false
		local game = display.newGroup();
		game.x = 0

		------------------------------------------------------------
		-- Sky and ground graphics
		------------------------------------------------------------
		local sky = display.newImage( "graphics/sky2.png", true )
		game:insert( sky )
		sky.x = 160; sky.y = 160

		local sky2 = display.newImage( "graphics/sky2.png", true )
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

		batBody = { density=15.0, friction=4.1, bounce=0.0, radius=10}
		batkingBody = { density=25.0, friction=10, bounce=0.0, radius=20}
		--castleBodyHeavy = { density=12.0, friction=0.3, bounce=0.4 }

		bat1 = movieclip.newAnim{ "graphics/bat_king.png", "graphics/bat_king_cracked.png" }
		game:insert( bat1 ); bat1.x = 684; bat1.y = 270; bat1.id = "bat1"
		physics.addBody( bat1, batkingBody )

		bat2 = movieclip.newAnim{ "graphics/bat.png", "graphics/bat_cracked.png" }
		game:insert( bat2 ); bat2.x = 802; bat2.y = 270; bat2.id = "bat2"
		physics.addBody( bat2, batBody )

		bat3 = movieclip.newAnim{ "graphics/bat.png", "graphics/bat_cracked.png" }
		game:insert( bat3 ); bat3.x = 744; bat3.y = 169; bat3.id = "bat3"
		physics.addBody( bat3, batBody )

		bat4 = movieclip.newAnim{ "graphics/bat.png", "graphics/bat_cracked.png" }
		game:insert( bat4 ); bat4.x = 566; bat4.y = 270; bat4.id = "bat4"
		physics.addBody( bat4, batBody )

		------------------------------------------------------------------------
		-- Construct castle 
		------------------------------------------------------------------------
		castleBody = { density=24.0, friction=10, bounce=0.2 }
		castleBodyHeavy = { density=40.0, friction=10, bounce=0.2}

		rock1 = movieclip.newAnim{ "graphics/rock.png", "graphics/rock_cracked.png" }
		game:insert( rock1 ); rock1.x = 510; rock1.y = 240; rock1.id = "rock1"
		physics.addBody( rock1, castleBodyHeavy )

		wall1 = movieclip.newAnim{ "graphics/wall.png", "graphics/wall_cracked.png" }
		game:insert( wall1 ); wall1.x = 620; wall1.y = 240; wall1.id = "wall1"
		physics.addBody( wall1, castleBody )

		wall2 = movieclip.newAnim{ "graphics/wall.png", "graphics/wall_cracked.png" }
		game:insert( wall2 ); wall2.x = 744; wall2.y = 240; wall2.id = "wall2"
		physics.addBody( wall2, castleBody )

		wall3 = movieclip.newAnim{ "graphics/wall.png", "graphics/wall_cracked.png" }
		game:insert( wall3 ); wall3.x = 856; wall3.y = 240; wall3.id = "wall3"
		physics.addBody( wall3, castleBody )

		roof = movieclip.newAnim{ "graphics/roof.png", "graphics/roof_cracked.png" }
		game:insert( roof ); roof.x = 682; roof.y = 190; roof.id = "roof"
		physics.addBody( roof, castleBody )

		roof2 = movieclip.newAnim{ "graphics/roof.png", "graphics/roof_cracked.png" }
		game:insert( roof2 ); roof2.x = 803; roof2.y = 190; roof2.id = "roof2"
		physics.addBody( roof2, castleBody )

		beam = movieclip.newAnim{ "graphics/beam.png", "graphics/beam_cracked.png" }
		game:insert( beam ); beam.x = 699; beam.y = 150; beam.id = "beam"
		physics.addBody( beam, castleBody )

		beam2 = movieclip.newAnim{ "graphics/beam.png", "graphics/beam_cracked.png" }
		game:insert( beam2 ); beam2.x = 790; beam2.y = 150; beam2.id = "beam2"
		physics.addBody( beam2, castleBody )

		roof3 = movieclip.newAnim{ "graphics/roof.png", "graphics/roof_cracked.png" }
		game:insert( roof3 ); roof3.x = 744; roof3.y = 110; roof3.id = "roof3"
		physics.addBody( roof3, castleBody )

		roof4 = movieclip.newAnim{ "graphics/roof.png", "graphics/roof_cracked.png" }
		game:insert( roof4 ); roof4.x = 561; roof4.y = 190; roof4.id = "roof4"
		physics.addBody( roof4, castleBody )

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

		arrow = display.newImage("graphics/arrow.png",true)
		arrow.x = 480
		arrow.y = 30

		------------------------------------------------------------
		-- Launch bird

		local bird 	= display.newImage( "graphics/redbird.png" )
		local easingx  	= require("easing");
		game:insert( bird )
		physics.addBody( bird, { density=10.0, friction=10, bounce=0.0, radius=25 } )
		bird.bodyType = "kinematic"
		bird.x = 50
		bird.y = 290

		local bird2 	= display.newImage( "graphics/whitebird.png" )
		local easingx  	= require("easing");
		game:insert( bird2 )
		physics.addBody( bird2, { density=10.0, friction=10, bounce=0.0, radius=25 } )
		bird2.bodyType = "kinematic"
		bird2.x = 20
		bird2.y = 287
		
		local function destroyObj(obj)
			display.remove(obj)
			obj=nil
		end

		local function resetValues()
				destroyObj(gameWon)
				destroyObj(gameRestart)
				destroyObj(gameNext)
				destroyObj(gameLost)
				destroyObj(arrow)	
				destroyObj(scoreTitle)
				destroyObj(scoreDisplay)
				destroyObj(resetButton)
				destroyObj(wall1)
				destroyObj(wall2)
				destroyObj(wall3)
				destroyObj(beam) 
				destroyObj(beam2)
				destroyObj(roof) 
				destroyObj(roof2)
				destroyObj(roof3)
				destroyObj(roof4)
				destroyObj(bat1) 
				destroyObj(bat2)
				destroyObj(bat3)
				destroyObj(bat4)
				destroyObj(rock1) 
				if eggflag == true then
					destroyObj(egg)
					sky2:removeEventListener("tap",dropEgg)
					eggflag = false
				end	
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
				storyboard.removeScene("Game3reload")
				storyboard.gotoScene ("playGame3", {effect = "fade", time = 500})
			end
		return true
		end

		local function nextLevel (event)
			if (event.phase == "began") then
				resetValues()
				gameRestart:removeEventListener ("touch", reload)
				gameNext:removeEventListener ("touch", nextLevel)
				storyboard.removeScene("Game3reload")
				storyboard.gotoScene ("playGame4", {effect = "fade", time = 500})
			end
		return true
		end		

		local function loadMenu (event)
			if (event.phase == "began") then
				resetValues()
				gameRestart:removeEventListener ("touch", reload)
				gameNext:removeEventListener ("touch", loadMenu)
				storyboard.removeScene("Game3reload")
				storyboard.gotoScene ("mainMenu", {effect = "fade", time = 500})
			end
		return true
		end		

		local function resetbird()
			if birdCount == 0 then
				bird.bodyType = "kinematic"
				transition.to(bird, {time=600, y=200, transition = easingx.easeOutElastic})
				bird:setLinearVelocity( 0, 0 ) 
				bird.angularVelocity = 0 			
			elseif birdCount == 1 then
				destroyObj(bird)
				bird2.bodyType = "kinematic"
				transition.to(bird2, {time=600, y=200, transition = easingx.easeOutElastic})
				bird2:setLinearVelocity( 0, 0 ) 
				bird2.angularVelocity = 0 
			end	

		end

		local function dropEgg(event)
			if birdCount == 1 then
				egg_spec = { density=125.0, friction=10, bounce=0.0, radius=20}
				egg = display.newImage("graphics/egg.png", true)
				game:insert( egg ); egg.x = bird2.x - 30; egg.y = bird2.y + 20; egg.id = "egg"
				physics.addBody( egg, egg_spec )
			end	
		end

		local function checkGame()
			if deadbat == 4 then
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

			elseif deadbat < 4 and birdRemain == 0 then
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
		local function moveCamera()
			if birdCount == 0 then
				if (bird.x > 80 and bird.x < 700) then
					game.x = -bird.x + 80
				end
			elseif birdCount == 1 then
				if (bird2.x > 80 and bird2.x < 700) then
					game.x = -bird2.x + 80
				end
			end	
		end

		local function moveLeft(event)
				local count = event.count
				game.x = game.x + count
				if count > 30 then
					timer.cancel(event.source)
				end	
		end

		local function moveRight(event)
				local count = event.count
				game.x = game.x - count
				if count > 30 then
					timer.cancel(event.source)
					timer.performWithDelay(100,moveLeft,0)
				end	

		end

		local function moveScreen(event)
				screenPosition = game.x
				timer.performWithDelay(10,moveRight,0)
				
		end

		Runtime:addEventListener( "enterFrame", moveCamera )

		function startListening()
			if bat1.postCollision then
				return
			end

			local function onbatCollision ( self, event )
				
				if ( event.force > 10.0 and event.force <= 45.0 ) then
					self:stopAtFrame(2)
							
					score = score + 1000
					scoreDisplay.text = score


				elseif ( event.force > 45.0 ) then
					deadbat = deadbat + 1				
					score = score + 2000
					scoreDisplay.text = score
					self:removeEventListener( "postCollision", self )
					destroyObj(self)
				end
			end

			local function oncastleCollision ( self, event )
					
					if ( event.force > 350.0 and event.force <= 450.0 ) then
						self:stopAtFrame(2)				
						score = score + 150
						scoreDisplay.text = score


					elseif ( event.force > 450.0 ) then		
						score = score + 300
						scoreDisplay.text = score
						self:removeEventListener( "postCollision", self )
						destroyObj(self)
					end
			end

			local function onrockCollision ( self, event )
					
					if ( event.force > 450.0 and event.force <= 600.0 ) then
						self:stopAtFrame(2)					
						score = score + 500
						scoreDisplay.text = score


					elseif ( event.force > 600.0 ) then			
						score = score + 1000
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

				bat4.postCollision = onbatCollision
				bat4:addEventListener( "postCollision", bat4 )	
					
				wall1.postCollision = oncastleCollision
				wall1:addEventListener( "postCollision", wall1 )

				wall2.postCollision = oncastleCollision
				wall2:addEventListener( "postCollision", wall2 )

				wall3.postCollision = oncastleCollision
				wall3:addEventListener( "postCollision", wall3 )

				roof.postCollision = oncastleCollision
				roof:addEventListener( "postCollision", roof )

				roof2.postCollision = oncastleCollision
				roof2:addEventListener( "postCollision", roof2 )

				roof3.postCollision = oncastleCollision
				roof3:addEventListener( "postCollision", roof3 )

				roof4.postCollision = oncastleCollision
				roof4:addEventListener( "postCollision", roof4 )

				beam.postCollision = oncastleCollision
				beam:addEventListener( "postCollision", beam )		

				beam2.postCollision = oncastleCollision
				beam2:addEventListener( "postCollision", beam2 )	

				rock1.postCollision = onrockCollision
				rock1:addEventListener( "postCollision", rock1 )

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
					bird2:applyForce((50 - event.x)*150, (200 - event.y)*150, bird2.x, bird2.y)
					birdRemain = birdRemain - 1
					sky2:addEventListener( "tap", dropEgg )	
				end	
				startListening()
				if birdCount ==0 then
					timer.performWithDelay( 5000, checkGame)
			    else
			    	timer.performWithDelay( 7000, checkGame)
			    end	
			end
		end

		local function newRound( event )
			game.x = 0
			birdCount = birdCount + 1
			resetbird()
			return true
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
		arrow:addEventListener("tap",moveScreen)
		bird:addEventListener( "touch", dropbird )
		bird2:addEventListener( "touch", dropbird )		
		gamePlay:insert(game)
end
function scene:exitScene(event)	
	local group = self.view
	Runtime:removeEventListener("enterFrame", moveCamera)
	arrow:removeEventListener("tap",moveScreen)
	bird:removeEventListener("touch", dropbird)
	bird2:removeEventListener("touch", dropbird)
	bat1:removeEventListener("postCollision", bat1) 
	bat2:removeEventListener("postCollision", bat2) 
	bat3:removeEventListener("postCollision", bat3)
	sky2:removeEventListener("tap",dropEgg)
	storyboard.removeScene("playGame1")
end	

scene:addEventListener( "createScene", scene )
scene:addEventListener( "enterScene", scene )
scene:addEventListener( "exitScene" , scene)
return scene