---------------------------------------------------------------------------------
-- Project: 
-- globals.lua
-- constants used throughout the app are defined here, such as file paths to
-- resources or modules, as well as some general helper functions.
---------------------------------------------------------------------------------

local globals = {}

-- global constants
globals.app_name = "Stickman"			-- app name

-- paths
globals.path = "app_files"
globals.lua_path = "app_files.lua."
globals.image_path = "app_files/images/"
globals.audio_path = "app_files/audio/"

-- app messages
-- messages that are interpreted by the app_loop are defined here
globals.app_msg = {

	-- messages
	restart = "restart",
	change_scene = "change_scene",		-- loads a new scene, destroying the previous one, and changes the app state
										-- msg_data values: 
										-- msg_data.scene - (required) name of the scene to go to. see globals.app_state for values
										
	change_state = "change_state",		-- only changes the app state
										-- msg_data values:
										-- msg_data.state - (required) name of the state to change to
	
	exit_app = "exit_app",
}

-- app states
-- if globals.app_state.* is a scene, its value will be the file path to that scene
-- else, it will be a string representing that state
globals.app_state = {
	
	-- scenes
	splash = globals.lua_path.."scene_splash",
	menu = globals.lua_path.."scene_menu",
	game = globals.lua_path.."scene_game",
	gameover = globals.lua_path.."scene_gameover",
	
	-- game sub-scenes
	game_cave1 = globals.lua_path.."scene_cave1",
	game_lvl1 = globals.lua_path.."scene_game_lvl1",
	
	-- game controller overlay scene
	game_controller = globals.lua_path.."scene_game_controller",
	
	-- app exit message
	app_exit = "appExit",
}

-- global resource values/paths
-- app fonts
globals.font = {	
					
	default = "Arial",
}

-- app images
globals.image = {

	-- gui images
	gui_x = globals.image_path.."button_x.png",
	gui_y = globals.image_path.."button_y.png",
	gui_menu = globals.image_path.."button_menu.png",
	gui_right_arrow = globals.image_path.."button_arrow_right.png",

	-- player images
	plr_sheet = globals.image_path.."plr_sheet.png",
	plr_sword = globals.image_path.."sword.png",
	
	-- environment images
	large_dirt = globals.image_path.."large_dirt.png",
	tree_trunk = globals.image_path.."tree_trunk.png",
	tree_branch = globals.image_path.."tree_branch.png",
	cave_enterance = globals.image_path.."cave_enterance.png",
	 
}

-- app audio
globals.audio = {

	click1 = globals.audio_path.."sfx_click.wav",
}


-- helper functions
-- shallow_copy copies primitive types
-- if a table is passed, primitives are copied on the first level and subtables are passed by reference
globals.shallow_copy = function(orig)

	local orig_type = type(orig)
	local cpy
	
	if orig_type == "table" then
		cpy = {}
		for k, v in pairs(orig) do
			cpy[k] = v
		end
	else	-- primitive types
		cpy = orig
	end
	
	return cpy
end

-- deep copy copies primitive types and tables recursively so all subtables are also copied
globals.deep_copy = function(orig)

	local orig_type = type(orig)
	local cpy
	
	if orig_type == "table" then
		cpy = {}
		for k, v in next, orig, nil do
			cpy[globals.deep_copy(k)] = globals.deep_copy(v)
		end
		setmetatable(cpy, globals.deep_copy(getmetatable(orig)))
	else	-- primitive types
		cpy = orig
	end
	
	return cpy
end

return globals