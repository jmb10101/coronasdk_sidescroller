---------------------------------------------------------------------------------
-- Project:
-- 
---------------------------------------------------------------------------------

-- requires
local composer = require( "composer" )
local globals = require("app_files.lua.globals")
local app_timer = require("app_files.lua.app_timer")
local physics = require("physics")									-- physics
local game_world_camera = require(globals.lua_path.."game_world_camera")
local player = require(globals.lua_path.."player")

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
   local game_world_area_width = 2150
   local game_world_area_height = 1000
   
   self.game_camera = game_world_camera.new()
   self.game_camera:init(game_world_area_width, game_world_area_height, display.contentWidth, display.contentHeight)
   
   -- create/add display objects
   
   -- background
   local grad = {type="gradient", color1={1,1,1}, color2={.5,.9,1}, direction="down"}	-- create gradient background
   local bg = display.newRect(display.contentWidth/2,display.contentHeight/2,display.contentWidth + 200, display.contentHeight) -- cover display area
   bg:setFillColor(grad)			-- apply gradient to background
   self:add_object("bg", bg)
   self.bg.position = "static"		-- setting this will make the bg fixed on the content area (camera will ignore it)
    
	
   -- pre defined physics options
   local ground_physics = {"static", {friction=.5, bounce=0}}
   
   -- add image objects
   self:add_new_object("ground1", globals.image.large_dirt, 150, 850, ground_physics)
   self:add_new_object("ground3", globals.image.large_dirt, 550, 1000, ground_physics)
   self:add_new_object("ground2", globals.image.large_dirt, 355, 905, ground_physics)
		self.ground2.rotation = 30
   self:add_new_object("tree1", globals.image.tree_trunk, 800, 950, ground_physics)
   self:add_new_object("tree2", globals.image.tree_trunk, 900, 1050, ground_physics)		
   self:add_new_object("tree3", globals.image.tree_trunk, 1000, 1000, ground_physics)
   self:add_new_object("tree4", globals.image.tree_trunk, 1145, 900, ground_physics)       
   self:add_new_object("tree5", globals.image.tree_trunk, 1300, 850, ground_physics)     

   self:add_new_object("tree_branch1", globals.image.tree_branch, 1100, 800, ground_physics) 
   self:add_new_object("tree_branch2", globals.image.tree_branch, 1300, 800, ground_physics) 
	  
   -- bg objects for next part
   self:add_new_object("tree_bg", globals.image.tree_trunk, 1600, 700)
   self.tree_bg.alpha = .6
   self:add_new_object("cave_enterance", globals.image.cave_enterance, 2000, 775)
   
   self:add_new_object("ground2_1", globals.image.large_dirt, 1600, 950, ground_physics)
   self:add_new_object("ground2_2", globals.image.large_dirt, 1900, 950, ground_physics)
   self:add_new_object("ground2_3", globals.image.large_dirt, 2200, 950, ground_physics)
   
	
   
   -- add player
   self.plr = self.app_loop.plr
   obj_units = self.game_camera:game_world_units_to_display_units(50,680)
   self.plr:spawn(sceneGroup, obj_units.x, obj_units.y)
   
   -- add physics
 
   -- add timers
   
	-- center camera on player
	local world_units = self.game_camera:display_units_to_game_world_units(self.plr.body.x, self.plr.body.y)
	self.game_camera:set_position(self.view, world_units.x - (display.contentWidth/2), world_units.y - (display.contentHeight/2))
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
	
	-- check if player has fallen out of game world area
	local world_units = self.game_camera:display_units_to_game_world_units(self.plr.body.x, self.plr.body.y)
	if world_units.y > self.game_camera.area_height then
	
		-- player is outside the game world area
		-- send an app state change event to the app_loop
		self:destroy()
		self.app_loop.process_app_message(nil, "change_scene", {scene = globals.app_state.gameover})
		return
	end
	

		
	-- block player from leaving game world area
	local dunits = self.game_camera:game_world_units_to_display_units(self.game_camera.area_width, self.game_camera.area_height)
	if world_units.x < (self.plr.body.width/2) then	
		self.plr.body.x = (self.plr.body.width/2)
	elseif world_units.x > (self.game_camera.area_width - (self.plr.body.width/2)) then
		self.plr.body.x = (dunits.x - self.plr.body.width/2)
	end
	
	-- load other scenes
	if world_units.x > 2000 and world_units.x < 2080 then

		self:destroy()
		self.app_loop.process_app_message(nil, "change_scene", {scene = globals.app_state.game_cave1})
		return
	end
	
	-- move player
	self.plr:process()
	
	-- center camera on player
	local world_units = self.game_camera:display_units_to_game_world_units(self.plr.body.x, self.plr.body.y)
	self.game_camera:set_position(self.view, world_units.x - (display.contentWidth/2), world_units.y - (display.contentHeight/2))

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
	  composer.showOverlay(globals.app_state.game_controller, {params = {app_loop = app_loop}})
	  
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
		
		self.plr:change_dir("left")
	elseif event.phase == "moved" then
	
	elseif event.phase == "touch_leave" then
	
		self.plr:change_dir("none")
	elseif event.phase == "touch_enter" then
	
		self.plr:change_dir("left")
	elseif event.phase == "ended" then
	
		self.plr:change_dir("none")
	end
end

-- button directional right
function scene:game_controller_button_dr_touch(event)

	if self.plr ~= nil then
		if event.phase == "began" then 
			
			self.plr:change_dir("right")
		elseif event.phase == "moved" then
		
		elseif event.phase == "touch_leave" then
		
			self.plr:change_dir("none")
		elseif event.phase == "touch_enter" then
		
			self.plr:change_dir("right")
		elseif event.phase == "ended" then
		
			self.plr:change_dir("none")
		end
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
   self.plr:hide()
   self:remove_physics(self.view)
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