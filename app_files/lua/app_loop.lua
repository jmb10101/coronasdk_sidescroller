---------------------------------------------------------------------------------
-- Project:
-- app_loop.lua
--
-- The app_loop class initializes the application and controls the program flow. 
-- This is done by having app_loop contain the highest level app components and 
-- updating and processing these components every frame by calling their 
-- respective member functions. This framework allows scene transitions based
-- on the app state, and contains an app message handler for dealing with high
-- level app events. 
---------------------------------------------------------------------------------

-- requires
local globals = require("app_files.lua.globals")					-- globals

local physics = require("physics")									-- physics
local composer = require("composer")								-- scene manager

local app_timer = require("app_files.lua.app_timer")				-- timer class

-- core app components
local player = require(globals.lua_path.."player")


-- app_loop class
local app_loop = {}

	-- define core app components and other members
	app_loop.app_state = globals.app_state.menu						-- app state
	app_loop.plr = nil
	
	-- init app
	function app_loop.init()
		-- hide status bar
		--display.setStatusBar(display.HiddenStatusBar) --disabled for debugging
		
		-- init sdk and core app components
		system.activate("multitouch")
		physics.start()
		--physics.setDrawMode( "hybrid" )
		
		-- init player
		app_loop.plr = player.new("undefined", globals.image.plr_sheet)
		
	end
	
	-- main loop
	-- This function should only be called once, after app_loop.init() has been called. The main app loop will be created,
	-- which is called once per frame, updating and processing core app components as necessary. Also, the first scene is
	-- set up and activated.
	function app_loop.start()

		-- main app loop
		-- ----------------------------------------------------------------------
		local function mainLoop()
		
			-- if app_state is anything other than an app exit message, process the app.
			-- Otherwise, clean up app
			if app_loop.app_state ~= globals.app_state.app_exit then 
			
				-- process app
				app_loop.process()			
			else 
			
				-- clean up app
				Runtime:removeEventListener("enterFrame", mainLoop)		

				app_loop.destroy()
			end
		end
		-------------------------------------------------------------------------
		
		-- add main loop enterFrame listener
		Runtime:addEventListener("enterFrame", mainLoop)	
		
		-- display first scene
		app_loop.process_app_message(nil, globals.app_msg.change_scene, {scene = globals.app_state.menu})
	end
	
	-- process app -- called once per frame to update and process app components
	-- general app-wide processing should go here, specific scene processing should go in the corresponding scene
	-----------------------------------------------------------------------------
	function app_loop.process()
		
		-- update app components
		
		-- process app components
		
	end
	
	-- app message handler
	-- interpret app messages and do stuff accordingly.
	-- --------------------------------------------------------------------------
	function app_loop.process_app_message(event, msg, msg_data)
	
		-- whether or not each parameter is required depends on the type of app message, and therefore the parameters themselves.
		-- one use case is to delegate event processing to this function by calling it and passing the event object as the first paramter.
		-- app messages are listed in the globals.app_msg table with possible values for msg_data for each corresponding msg
		
		-- filter by msg
		if msg == globals.app_msg.restart then 
		
			-- restart core app components
			
			return
		elseif msg == globals.app_msg.change_scene then
		
			-- change app state and load scene passed in msg_data
			app_loop.app_state = msg_data.scene
			composer.removeHidden()
			composer.removeScene(msg_data.scene)
			composer.gotoScene(msg_data.scene, {params = {app_loop = app_loop}}) 		-- give each scene access to this app_loop class
			
			-- additional required processing on core app components

			return
		elseif msg == globals.app_msg.change_state then
		
			-- change app state
			app_loop.app_state = msg_data.app_state
			
			return
		elseif msg == globals.app_msg.exit_app then
		
			-- this changes app state to globals.app_state.app_exit
			-- app_loop.destroy() will be called in the main loop after checking app state, and removing the enterFrame listener
			app_loop.app_state = globals.app_state.app_exit
			return
		end
		
		
	end
	
	-- clean up app
	function app_loop.destroy()
	
		-- destroy player
		app_loop.plr:destroy()
	end

return app_loop