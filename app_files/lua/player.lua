---------------------------------------------------------------------------------
-- Project: Stickman
-- player class
---------------------------------------------------------------------------------

-- requires
local globals = require("app_files.lua.globals")
local app_timer = require(globals.lua_path.."app_timer")

-- player class

local player = {}

function player.new(name, file)

	-- create a new player object
	local new_player = {}
	
	-- add player properties
	new_player.name = name
	new_player.plr_sheet_file = file
	new_player.max_health = 100
	new_player.health = new_player.max_health
	new_player.lives = 1
	new_player.speed = 100									-- player's general speed in pixels per second
	new_player.moving = false
	new_player.max_jumps = 3
	new_player.jumps = new_player.max_jumps					-- number of jumps player has
	new_player.num_collisions = 0
	new_player.dir = "none"									-- horizontal direction player is moving, can be "left", "right", or "none"
	new_player.body = nil									-- display object representing player
	new_player.wpn_melee = nil								-- melee weapon			
	new_player.timer = app_timer.new()						-- timer to control speed
	new_player.landed = false
	new_player.alive = false
	new_player.is_destroyed = false
	
	-- init player
	function new_player:init(name, file)		
	
		-- set properties
		
		-- add physics
		self:add_physics()		-- will create the player sprite and animations first
		
		-- hide player by default - player will be shown after a call to spawn() or show()
		self:hide()
	end
	
	-- initialize display objects
	function new_player:init_display_objects()
	
		-- player image sheet
		local options = {
			frames = 
			{
				{x = 0, y = 0, width = 11, height = 29},
				{x = 12, y = 0, width = 11, height = 29},
				{x = 24, y = 0, width = 11, height = 29},
				{x = 0, y = 30, width = 11, height = 29},
				{x = 12, y = 30, width = 11, height = 29},
				{x = 24, y = 30, width = 11, height = 29},
			}
		}
		local image_sheet = graphics.newImageSheet(self.plr_sheet_file, options)
		
		-- sprite sequence data
		local sequence_data = {
		
			{name = "walking_right", start=1, count=3, time = 300,},
			{name = "walking_left", start=4, count=3, time = 300,},
			{name = "running_right", start=1, count=3, time = 200,},
			{name = "running_left", start=4, count=3, time = 200,},
		}
		self.body = display.newSprite(image_sheet, sequence_data)

		-- add melee weapon
		self.wpn_melee = display.newImage(globals.image.plr_sword, 100, 800)	
	end
	
	-- add physics
	function new_player:add_physics()
		
		-- init display objects
		self:init_display_objects()
		
		-- add physics body
		physics.addBody(self.body, "dynamic", {bounce=0, friction=.5})
		self.body.isFixedRotation = true
		self.alive = true	

		-- set up a collision listener on player's body
		local body = self.body
		local plr = self
		local function collision(self, event) 
			plr:collision(event)				-- redirect collision event to player method
		end	

		-- add collision listener
		body.collision = collision
		body:addEventListener("collision", body)		

		-- do not allow body to sleep
		self.body.isSleepingAllowed = false	

		-- collision counter
		self.num_collisions = 0
	end
	
	-- spawn player in game world
	function new_player:spawn(display_group, x, y)
	
		-- add physics
		self:add_physics()
		
		-- show player
		self:show()
		
		-- set position
		self.body.x = x
		self.body.y = y
		self:change_dir("none")
		
		-- start timer
		self.timer:restart()
		
		-- player is now alive
		self.alive = true

		-- add player to display_group
		display_group:insert(self.body)
	
	end
	
	-- show/hide player (between scenes, etc)
	function new_player:show()
		self.body.isBodyActive = true
		self.body.alpha = 1	
	end
	
	function new_player:hide()
		self.body.isBodyActive = false
		self.body.alpha = 0
	end	
	
	-- process player -- should be called once per frame while player is allowed to move. a dir value of "none" will not move the player
	-- this will move and animate the player sprite and update any other player components that need to be updated
	function new_player:process()
		
		-- ensure player has been initialized before continuing
		if self.body == nil then return end
		
		-- ensure physics body is active
		if self.body.isBodyActive == false then return end
		
		-- handle animation
		if self.num_collisions == 0 then
			self.body:pause()
			self.body:setFrame(1)
		else
			if self.body.isPlaying == false and self.dir ~= "none" then
				self.body:play()
			end
		end
		
		-- adjust position from player movement
		-- find real speed (+ or -)
		local speed = self.speed
		if self.dir == "left" then
			speed = speed * -1
		elseif self.dir == "none" then
			speed = 0
		elseif self.dir == "right" then
		end
		
		-- update player position
		local xdelta = (self.timer.time/1000) * speed		-- to find the change in pixels, multiply the time since last call by the player speed (in pixels per second)
		self:translate(xdelta, 0)
		
		
		-- reset timer so that the timer's value represents the time between calls to this function
		self.timer:restart()
		
	end
	
	-- change player direction
	function new_player:change_dir(dir)
	
		if dir == "left" then
		
			self.body:setSequence("walking_left")
		elseif dir == "none" then
		
			self.body:pause()
		elseif dir == "right" then

			self.body:setSequence("walking_right")
		end
		
		-- change direction
		self.dir = dir
		self.body:setFrame(1)
	end
	
	-- translate player -- move player by a specific set of x and y values
	function new_player:translate(x, y)
		
		-- update player position
		self.body.x = self.body.x + x
		self.body.y = self.body.y + y
	end
	
	-- set player position
	function new_player:set_position(x, y)
	
		-- move player
		self.body.x = x
		self.body.y = y
	end
	
	-- jump
	function new_player:jump()
	
		-- check to see if player has any jumps left
		if self.jumps > 0 then 
		
			-- apply upward force on player
			self.body:applyForce(0,-1,self.body.x, self.body.y)
			self.jumps = self.jumps - 1
			self.body:pause()
		end
	end
	
	-- collisions
	function new_player:collision(event)
	
		-- 
		if event.phase == "began" then
		
			self.num_collisions = self.num_collisions + 1
			self.jumps = self.max_jumps
		elseif event.phase == "ended" then
		
			self.num_collisions = self.num_collisions - 1
			
			-- left ground
			self.landed = false
		end
		
	end
	
	-- destroy player
	function new_player:destroy()
		
		-- remove physics
		if self.body.isBodyActive ~= nil then
			physics.removeBody(self.body)
		end
		
		-- nil references
		self.body = nil

		-- clean up player components
		self.timer:destroy()
		
		-- set destroy properties
		self.alive = false
		self.is_destroyed = true
	end
	
	-- initialize player and return it
	new_player:init(new_player.name, new_player.plr_sheet_file)
	
	return new_player
end

return player