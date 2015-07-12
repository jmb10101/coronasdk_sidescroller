---------------------------------------------------------------------------------
-- Project:
-- etc_graphics.lua
-- additional graphics helper functions are defined here
---------------------------------------------------------------------------------

local etc_graphics = {}

-- test if a point intersects a non-rotated rectangle
function etc_graphics.does_point_intersect_rct(point_x, point_y, rct_center_x, rct_center_y, rct_width, rct_height)

	-- set bounds
	local left = rct_center_x - (rct_width/2)
	local top = rct_center_y - (rct_height/2)
	local right = rct_center_x + (rct_width/2)
	local bottom = rct_center_y + (rct_height/2)					
	
	-- check bounds against point position
	if point_x < left or point_x > right or point_y < top or point_y > bottom then
		-- no collision
		return false
	else
		-- collision
		return true
	end
end

return etc_graphics