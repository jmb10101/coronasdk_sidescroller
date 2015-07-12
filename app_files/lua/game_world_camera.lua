---------------------------------------------------------------------------------
-- Project: 
-- game_world_camera.lua
-- This class controls the camera movement within a game world area. It is
-- important to differentiate game world camera units with corona display objects.
-- Units used with Corona display objects are relative to the content area that
-- is actually displayed, and units used in this class are relative to the game 
-- world area currently being viewed. The scale of both unit systems is the same,
-- which makes it possible to move the camera seamlessly over the game world area,
-- allowing the game to be "scrolled."
---------------------------------------------------------------------------------

local game_world_camera = {}

	-- create new game_world_camera object
	function game_world_camera.new()
		
		local new_cam = {}
		
		-- add camera properties
		new_cam.area_height = nil
		new_cam.area_width = nil
		new_cam.content_width = nil			-- default width / height properties are in portrait values, swap width/height to make landscape
		new_cam.content_height = nil
		new_cam.x = nil
		new_cam.y = nil
		
		-- init camera
		function new_cam:init(area_width, area_height, content_width, content_height)
		
			-- set properties
			self.area_height = area_height
			self.area_width = area_width
			self.content_width = content_width
			self.content_height = content_height
			
			-- start camera position in bottom left corner of game world area
			self.x = 0
			self.y = area_height - content_height
		end
		
		-- move camera
		function new_cam:move(display_group, x, y)
			
			-- return now if there is no movement, or display_group is nil
			if display_group == nil then return end
			if x == 0 and y == 0 then return end
			
			
			local movex = true
			local movey = true
			local camera_constraint_right = self.area_width - self.content_width
			local camera_constraint_bottom = self.area_height - self.content_height
			
			
			-- update camera position
			self.x = self.x + x
			self.y = self.y + y
			
			-- camera constraints
			if self.x < 0 then
				self.x = 0
				movex = false
			end
			if self.x > camera_constraint_right then
				self.x = camera_constraint_right
				movex = false	
			end
			if self.y < 0 then
				self.y = 0
				movey = false	
			end
			if self.y > camera_constraint_bottom then
				self.y = camera_constraint_bottom
				movey = false	
			end
			
			-- if camera is inside of constraints, update x and y positions of all display objects in view.
			-- content area units are used here instead of game world area units. The camera does not control
			-- the actual positions of objects in the game world, only the positions relative to the display area.
			for i=1, display_group.numChildren, 1 do
				if movex == true and display_group[i].position ~= "static" then 
					display_group[i].x = display_group[i].x - x
				end
				if movey == true and display_group[i].position ~= "static" then 
					display_group[i].y = display_group[i].y - y
				end
			end		
		end
		
		-- center camera at given position
		function new_cam:set_position(display_group, x, y)
			
			-- get difference between current position and new position
			local diffx = x - self.x
			local diffy = y - self.y
			
			-- move camera to new position
			self:move(display_group, diffx, diffy)

		end
		
		-- convert between display object units and game world area units
		function new_cam:display_units_to_game_world_units(x, y)
		
			local units = {}
			units.x = x + self.x
			units.y = y + self.y	
			return units
		end
		
		function new_cam:game_world_units_to_display_units(x, y)
		
			local units = {}
			units.x = x - self.x
			units.y = y - self.y
			return units
		end
		
		-- return the new camera object
		return new_cam
	end
	
return game_world_camera