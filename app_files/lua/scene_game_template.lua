---------------------------------------------------------------------------------
-- Project:
-- 
---------------------------------------------------------------------------------

-- requires
local composer = require( "composer" )
local globals = require("app_files.lua.globals")

local game_world_camera = require(globals.lua_path.."game_world_camera")

-- local forward references

-- create scene
local scene = composer.newScene()

function scene:create( event )

   local sceneGroup = self.view

   -- create a reference to the app_loop
   self.app_loop = event.params.app_loop
   
   -- store the current app state
   self.thisScene = event.params.app_loop.app_state
   
   -- scene exit message
   self.exit_scene = false
   
   -- create game world properties and camera
   local game_world_area_width = 1000
   local game_world_area_height = 1000
   
   self.game_camera = game_world_camera.new()
   self.game_camera:init(game_world_area_width, game_world_area_height, display.contentWidth, display.contentHeight)
   
   -- create/add display objects
   
   -- pre defined physics options
   local ground_physics = {"static", {friction=.5, bounce=0}}
   
   -- add display objects


   -- add timers
   
   
	-- center camera
	--self.game_camera:set_position(self.view, x, y)
end

-- create a display object and add it to the screen. last parameter is optional and used to apply physics
-- the format for physics_options is: {"static", {friction=.5, bounce=0, ...}}
function scene:add_new_object(name, file, world_x, world_y, physics_options)

	-- scene objects group
	local sceneGroup = self.view
	
	-- create display object
	local obj_units = self.game_camera:game_world_units_to_display_units(world_x, world_y)
	self[name] = display.newImage(file, obj_units.x, obj_units.y)
	
	-- add physics if supplied as a parameter 
	if physics_options ~= nil and self[name] ~= nil then 
		local body = self[name]
		physics.addBody(body, physics_options[1], physics_options[2])
	end
	
	-- add display object to scene group
	sceneGroup:insert(self[name])
end

-- add a pre defined display object to the scene
function scene:add_object(name, display_object)

	-- add display object to scene objects group
	local sceneGroup = self.view
	self[name] = display_object	
	sceneGroup:insert(self[name])
end 

-- process scene -- called once per frame
function scene:process()
	
	-- load other scenes

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
      -- Called when the scene is now on screen.
     
	  -- show controller overlay
	  --composer.showOverlay(globals.app_state.game_controller, {params = {app_loop = app_loop}})
	  
	  -- add listeners
	  
	  -- add process loop
	  local function process()
	  
		-- if app state has changed, remove the event listener
		if self.exit_scene == false then 
			
			-- process app
			self:process()			
		else 
			
			-- free resources
			Runtime:removeEventListener("enterFrame", process)				
		end		
	  end
	  
	  Runtime:addEventListener("enterFrame", process)
   end
   
end

-- game controller button touch events
-- button x
function scene:game_controller_button_x_touch(event)

	if event.phase == "began" then 
	elseif event.phase == "moved" then
	elseif event.phase == "touch_leave" then
	elseif event.phase == "touch_enter" then
	elseif event.phase == "ended" then
	end
end

-- button y
function scene:game_controller_button_y_touch(event)

	if event.phase == "began" then 
	
		-- player jumps
		self.plr:jump()
	elseif event.phase == "moved" then
	elseif event.phase == "touch_leave" then
	elseif event.phase == "touch_enter" then
	elseif event.phase == "ended" then
	end
end

-- button menu
function scene:game_controller_button_menu_touch(event)

	if event.phase == "began" then 
	elseif event.phase == "moved" then
	elseif event.phase == "touch_leave" then
	elseif event.phase == "touch_enter" then
	elseif event.phase == "ended" then
	end
end

-- button directional left
function scene:game_controller_button_dl_touch(event)

	if event.phase == "began" then 
	elseif event.phase == "moved" then
	elseif event.phase == "touch_leave" then
	elseif event.phase == "touch_enter" then
	elseif event.phase == "ended" then
	end
end

-- button directional right
function scene:game_controller_button_dr_touch(event)

	if event.phase == "began" then 
	elseif event.phase == "moved" then
	elseif event.phase == "touch_leave" then
	elseif event.phase == "touch_enter" then
	elseif event.phase == "ended" then
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

-- remove physics
function scene:remove_physics(display_group)

	for i=1, display_group.numChildren, 1 do
		if display_group[i].isBodyActive ~= nil then
			physics.removeBody(display_group[i])
		end
	end	
end

-- destroy scene
function scene:destroy( event )

   local sceneGroup = self.view

   -- clean up scene
   self.plr:destroy()
   self:remove_physics(self.view)
   self.exit_scene = true
end

---------------------------------------------------------------------------------

-- listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

---------------------------------------------------------------------------------

return scene