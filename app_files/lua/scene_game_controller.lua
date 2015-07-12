---------------------------------------------------------------------------------
-- Project:
-- scene_game_controller
-- This scene is implemented as a composer scene overlay. The parent scene must
-- implement the button listener functions listed below in scene:show()
-- Two event.phase values are added to the buttons, "touch_leave", and "touch_enter"
-- A touch_leave event occurs when the user's finger is dragging on the screen and leaves
-- the button area, touch_enter events occur when the finger drags into the area.
-- These events can be handled just like the "began" and "ended" phases
---------------------------------------------------------------------------------

-- requires
local composer = require( "composer" )
local scene = composer.newScene()
local globals = require("app_files.lua.globals")
local etc_graphics = require(globals.lua_path.."etc_graphics")

-- local forward references

-- create scene
function scene:create( event )

	local sceneGroup = self.view

   -- create buttons
   -- button x
   self.bx = display.newImage(globals.image.gui_x, 390, 290)
   self.bx.alpha = .4
   self.bx.is_active = false	-- is true when finger is over the button area
   
   -- button y
   self.by = display.newImage(globals.image.gui_x, 460, 290)
   self.by.alpha = .4
   self.by.is_active = false
   
   -- button menu
   self.menu = display.newImage(globals.image.gui_menu, 250, 290)
   self.menu.alpha = .4
   self.menu.is_active = false
   
   -- button directional left
   self.dl = display.newImage(globals.image.gui_right_arrow, 30, 290)
   self.dl.rotation = 180
   self.dl.alpha = .4
   self.dl.is_active = false			
   
   
   -- button directional right
   self.dr = display.newImage(globals.image.gui_right_arrow, 120, 290)
   self.dr.alpha = .4
   self.dr.is_active = false
   
   -- add physics
   
   -- add display objects to scene
   sceneGroup:insert(self.bx)
   sceneGroup:insert(self.by)
   sceneGroup:insert(self.menu)
   sceneGroup:insert(self.dl)
   sceneGroup:insert(self.dr)
   
 	-- create a reference to the app_loop
	self.app_loop = event.params.app_loop
	   
	-- store the current app state
	self.thisScene = event.params.app_loop.app_state
	
	-- parent scene -- controller should be implemented as a subsene
	self.parent = nil
	
   -- scene exit message -- use to free memory/remove event listeners
   self.exit_scene = false
   
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
		-- called when the scene is still off screen (but is about to come on screen).
		-- set parent object
		self.parent = event.parent
	
   elseif ( phase == "did" ) then
		-- called when the scene is now on screen.
	  
		-- add button touch listeners -- parent scene must implement these methods:
		-- game_controller_button_x_touch(event)
		-- game_controller_button_y_touch(event)
		-- game_controller_button_menu_touch(event)
		-- game_controller_button_dl_touch(event)
		-- game_controller_button_dr_touch(event)
		
		-- screen listener -- used to listen for touch events to keep track of when user drags finger inside or outside a button area
		local function touch(event)
			
			if self.exit_scene == true then
				Runtime:removeEventListener("touch", touch)
				return
			end
			
			if event.phase == "moved" then 

				-- check button bounds against finger position
				local boff = 15		-- button offset for surrounding bounding box
				
				-- button x
				-- is touch outside of button?
				if etc_graphics.does_point_intersect_rct(event.x, event.y, self.bx.x, self.bx.y, self.bx.width, self.bx.height) == false then		
				
					-- does touch intersect the area around the button?
					if etc_graphics.does_point_intersect_rct(event.x, event.y, self.bx.x, self.bx.y, self.bx.width + boff, self.bx.height + boff) == true then
					
						-- finger is outside of button area, but inside of the offset area around the button, if button is currently active, a touch leave event has occured 
						if self.bx.is_active == true then
						
							-- touch leave event
							self.bx.is_active = false
							event.phase = "touch_leave"
							self.parent:game_controller_button_x_touch(event)
						end					
					end
				else
				
					-- finger is inside button area
					if self.bx.is_active == false then
					
						-- touch enter event
						self.bx.is_active = true
						event.phase = "touch_enter"
						self.parent:game_controller_button_x_touch(event)
					end
				end
				
				-- button y
				if etc_graphics.does_point_intersect_rct(event.x, event.y, self.by.x, self.by.y, self.by.width, self.by.height) == false then		
				
					-- does touch intersect the area around the button?
					if etc_graphics.does_point_intersect_rct(event.x, event.y, self.by.x, self.by.y, self.by.width + boff, self.by.height + boff) == true then
					
						-- finger is outside of button area
						if self.by.is_active == true then
						
							-- touch leave event
							self.by.is_active = false
							event.phase = "touch_leave"
							self.parent:game_controller_button_y_touch(event)
						end
					end
				else
				
					-- finger is inside button area
					if self.by.is_active == false then
					
						-- touch enter event
						self.by.is_active = true
						event.phase = "touch_enter"
						self.parent:game_controller_button_y_touch(event)
					end
				end
				
				-- button menu
				if etc_graphics.does_point_intersect_rct(event.x, event.y, self.menu.x, self.menu.y, self.menu.width, self.menu.height) == false then		
				
					-- does touch intersect the area around the button?
					if etc_graphics.does_point_intersect_rct(event.x, event.y, self.menu.x, self.menu.y, self.menu.width + boff, self.menu.height + boff) == true then
					
						-- finger is outside of button area
						if self.menu.is_active == true then
						
							-- touch leave event
							self.menu.is_active = false
							event.phase = "touch_leave"
							self.parent:game_controller_button_menu_touch(event)
						end
					end
				else
				
					-- finger is inside button area
					if self.menu.is_active == false then
					
						-- touch enter event
						self.menu.is_active = true
						event.phase = "touch_enter"
						self.parent:game_controller_button_menu_touch(event)
					end
				end
				
				-- directional left
				if etc_graphics.does_point_intersect_rct(event.x, event.y, self.dl.x, self.dl.y, self.dl.width, self.dl.height) == false then		
				
					-- does touch intersect the area around the button?
					if etc_graphics.does_point_intersect_rct(event.x, event.y, self.dl.x, self.dl.y, self.dl.width + boff, self.dl.height + boff) == true then
					
						-- finger is outside of button area
						if self.dl.is_active == true then
						
							-- touch leave event
							self.dl.is_active = false
							event.phase = "touch_leave"
							self.parent:game_controller_button_dl_touch(event)
						end
					end
				else
				
					-- finger is inside button area
					if self.dl.is_active == false then
					
						-- touch enter event
						self.dl.is_active = true
						event.phase = "touch_enter"
						self.parent:game_controller_button_dl_touch(event)
					end
				end
				
				-- directional right
				if etc_graphics.does_point_intersect_rct(event.x, event.y, self.dr.x, self.dr.y, self.dr.width, self.dr.height) == false then		
				
					-- does touch intersect the area around the button?
					if etc_graphics.does_point_intersect_rct(event.x, event.y, self.dr.x, self.dr.y, self.dr.width + boff, self.dr.height + boff) == true then
					
						-- finger is outside of button area
						if self.dr.is_active == true then
						
							-- touch leave event
							self.dr.is_active = false
							event.phase = "touch_leave"
							self.parent:game_controller_button_dr_touch(event)
						end
					end
				else
				
					-- finger is inside button area
					if self.dr.is_active == false then
					
						-- touch enter event
						self.dr.is_active = true
						event.phase = "touch_enter"
						self.parent:game_controller_button_dr_touch(event)
					end
				end
				
				--
				
			end
		end
		
		-- button x
		local function touch_bx(event)
		
			if event.phase == "began" then
				self.bx.is_active = true
			elseif event.phase == "ended" then
				self.bx.is_active = false
			end			
			self.parent:game_controller_button_x_touch(event)
		end
		
		-- button y
		local function touch_by(event)
		
			if event.phase == "began" then
				self.by.is_active = true
			elseif event.phase == "ended" then
				self.by.is_active = false
			end
			self.parent:game_controller_button_y_touch(event)
		end
		
		-- button menu
		local function touch_menu(event)
		
			if event.phase == "began" then
				self.menu.is_active = true
			elseif event.phase == "ended" then
				self.menu.is_active = false
			end
			self.parent:game_controller_button_menu_touch(event)
		end
		
		-- button directional left
		local function touch_dl(event)

			if event.phase == "began" then
				self.dl.is_active = true
			elseif event.phase == "ended" then
				self.dl.is_active = false
			end
			self.parent:game_controller_button_dl_touch(event)
		end		
		
		-- button directional right
		local function touch_dr(event)
		
			if event.phase == "began" then
				self.dr.is_active = true
			elseif event.phase == "ended" then
				self.dr.is_active = false
			end
			self.parent:game_controller_button_dr_touch(event)
		end		
		
		Runtime:addEventListener("touch", touch)
		
		self.bx:addEventListener("touch", touch_bx)
		self.by:addEventListener("touch", touch_by)
		self.menu:addEventListener("touch", touch_menu)
		self.dl:addEventListener("touch", touch_dl)
		self.dr:addEventListener("touch", touch_dr)
	  
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