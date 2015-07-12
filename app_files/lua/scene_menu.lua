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
   scene.title = display.newText(globals.app_name, display.contentCenterX, display.contentCenterY - 75, globals.font.default, 24)
   scene.hint = display.newText("Tap to play", display.contentCenterX, display.contentCenterY - 30, globals.font.default, 12)
  
   
   -- add display objects to scene
   sceneGroup:insert(scene.title)
   sceneGroup:insert(scene.hint)
   
   -- add physics
   
   -- load audio
   scene.sfx_click = audio.loadSound(globals.audio.click1)
   
   -- create a reference to the app_loop
   self.app_loop = event.params.app_loop
   
   -- store the current app state
   self.thisScene = event.params.app_loop.app_state
   
   -- exit scene message
   self.exit_scene = false
   
end

-- process scene -- called once per frame while the scene is being displayed
function scene:process()


end

-- show scene
function scene:show( event )

   local sceneGroup = self.view
   local phase = event.phase
   
   -- create local references
   local app_loop = event.params.app_loop
   local thisScene = self.thisScene
   
   if ( phase == "will" ) then
      -- Called when the scene is still off screen (but is about to come on screen).
   elseif ( phase == "did" ) then
	   -- Called when the screen is now on screen
   
       -- add listeners
	   local function touch(event)
			
			if event.phase == "began" then
		
				-- remove listener
				Runtime:removeEventListener("touch", touch)

				-- send an app state change event to the app_loop
				self:destroy()
				self.app_loop.process_app_message(nil, "change_scene", {scene = globals.app_state.game})
				audio.play(self.sfx_click)
				return
			end
	   end
	   Runtime:addEventListener("touch", touch)
	  
	  -- add process loop
	  local function process()
	
		-- if app state has changed, remove the event listener
		if app_loop.app_state == thisScene then 
			
			-- process app
			self:process()			
		else 
			
			-- free resources
			Runtime:removeEventListener("enterFrame", process)				
		end			
	  end
	  
	  -- add enter frame event listener
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
   
   self.exit_scene = true
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

---------------------------------------------------------------------------------

return scene