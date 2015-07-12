---------------------------------------------------------------------------------
-- Project: 
-- app_timer.lua
-- timer class that acts like a stopwatch. the timer will update itself after
-- start() is called for the first time.
---------------------------------------------------------------------------------

local app_timer = {}

	-- create a new timer object
	function app_timer.new()
	
		local new_app_timer = {}
		
		-- create a timer object
		new_app_timer.time = 0				-- the timer value (all values in ms)
		new_app_timer.delta = 0				-- time change between frames
		new_app_timer.prevTimeTotal = 0		-- system time of the last frame (used to calculate delta)
		new_app_timer.running = false		-- true when timer is running
		new_app_timer.listening = false		-- used to initialize timer only once
		new_app_timer.kill_timer = false  	-- used to know when to free resources
		
		-- update timer
		function new_app_timer:update()
		
			local now = system.getTimer()
			self.delta = now - self.prevTimeTotal
			self.prevTimeTotal = system.getTimer()
			
			if self.running == true then 
				self.time = self.time + self.delta
			end
		end
		
		-- start timer
		function new_app_timer:start()
			if self.listening == false then
				-- create an update listener that is called once per frame
				local function updateListener() 
					
					-- update timer or destroy event listener if self:destroy() was called
					if self.kill_timer == false then 
						-- update timer
						self:update() 
					else
						Runtime:removeEventListener("enterFrame", updateListener)
					end
				end
				Runtime:addEventListener("enterFrame", updateListener)
				self.listening = true
			end
			
			self.running = true
		end
		
		-- stop timer
		function new_app_timer:stop()
			self.running = false
		end
		
		-- toggle start/stop
		function new_app_timer:toggle()
			if self.running == false then
				self.running = true
			else
				self.running = false 
			end
		end
		
		-- restart timer
		function new_app_timer:restart()
			self.time = 0
			self:start()
		end
		
		-- free resources
		function new_app_timer:destroy()
			self.kill_timer = true
		end

		return new_app_timer
	end
	
return app_timer