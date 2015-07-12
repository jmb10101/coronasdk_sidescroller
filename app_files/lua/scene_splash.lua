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
   
   -- add physics
   
   -- add display objects to scene
   
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
   local app_loop = event.params.app_loop
   local thisScene = self.thisScene
   
   if ( phase == "will" ) then
      -- Called when the scene is still off screen (but is about to come on screen).
   elseif ( phase == "did" ) then
      -- Called when the scene is now on screen.
      -- Insert code here to make the scene come alive.
      -- Example: start timers, begin animation, play audio, etc.
	  
	  -- Add process loop
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
   
   self.app_loop = nil
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

---------------------------------------------------------------------------------

return scene