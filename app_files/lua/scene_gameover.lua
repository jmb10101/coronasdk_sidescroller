---------------------------------------------------------------------------------
-- Project:
-- 
---------------------------------------------------------------------------------

-- requires
local composer = require( "composer" )
local scene = composer.newScene()
local globals = require("app_files.lua.globals")

-- local forward references

-- create scene
function scene:create( event )

   local sceneGroup = self.view

   -- create display objects
   self.title = display.newText("Game Over", display.contentCenterX, display.contentCenterY - 75, globals.font.bold, 24)
   self.restart = display.newText("Restart", display.contentCenterX, display.contentCenterY - 30, globals.font.regular, 12)
   self.mainMenu = display.newText("Main Menu", display.contentCenterX, display.contentCenterY, globals.font.regular, 12)
   
   -- add physics
   
   -- add display objects to scene
   sceneGroup:insert(self.title)
   sceneGroup:insert(self.restart)
   sceneGroup:insert(self.mainMenu)
   
   -- create a reference to the app_loop
   self.app_loop = event.params.app_loop
   
   -- store the current app state
   self.thisScene = event.params.app_loop.app_state
   
   
      
end

-- process scene -- called once per frame
function scene:process()

	
end

-- show scene
function scene:show( event )

   local sceneGroup = self.view
   local phase = event.phase
   
   -- create local references
   local app_loop = self.app_loop
   local thisScene = self.thisScene
   
   if ( phase == "will" ) then
      -- Called when the scene is still off screen (but is about to come on screen).
   elseif ( phase == "did" ) then
      -- called when the scene is now on screen.
	  
	   -- add listeners
	   local function restart(event)

			if event.phase == "began" then 
				-- remove listener
				self.restart:removeEventListener("touch", restart)
				
				-- send an app state change event to the app_loop
				self.app_loop.process_app_message(nil, "change_scene", {scene = globals.app_state.game})
				return
			end
	   end
	   local function menu(event)
		
			if event.phase == "began" then
				-- remove listener
				self.mainMenu:removeEventListener("touch", menu)
				
				-- send an app state change event to the app_loop	
				self.app_loop.process_app_message(nil, "change_scene", {scene = globals.app_state.menu})
				return
			end
	   end
	   self.restart:addEventListener("touch", restart)
	   self.mainMenu:addEventListener("touch", menu)
	  
	  -- add process loop
	  local function process()
	  
		-- process this frame
		self:process()
		
		if  app_loop.app_state ~= thisScene then
			Runtime:removeEventListener("enterFrame", process)
		end
		
	  end
	  
	  Runtime:addEventListener("enterFrame", process)
   end
   
end

-- hide scene
function scene:hide( event )

   local sceneGroup = self.view
   local phase = event.phase

   if ( phase == "will" ) then
      -- Called when the scene is on screen (but is about to go off screen).
      -- Insert code here to "pause" the scene.
      -- Example: stop timers, stop animation, stop audio, etc.
   elseif ( phase == "did" ) then
      -- Called immediately after scene goes off screen.
   end
end

-- destroy scene
function scene:destroy( event )

   local sceneGroup = self.view

   -- Called prior to the removal of scene's view ("sceneGroup").
   -- Insert code here to clean up the scene.
   -- Example: remove display objects, save state, etc.
   
   
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

---------------------------------------------------------------------------------

return scene