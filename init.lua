-- internationalization boilerplate
local MP = minetest.get_modpath(minetest.get_current_modname())
local S, NS = dofile(MP.."/intllib.lua")

-- get right image number for players compass
local function get_compass_stack(player, stack)
	local dir = player:get_look_horizontal()
	local angle_dir = math.deg(dir)
	local compass_image = math.floor((angle_dir/22.5) + 0.5)%16
	local newstack = ItemStack("north_compass:"..compass_image)
	return newstack
end

-- update inventory
minetest.register_globalstep(function(dtime)
	for i,player in ipairs(minetest.get_connected_players()) do
		if player:get_inventory() then
			for i,stack in ipairs(player:get_inventory():get_list("main")) do
				if i > 8 then
					break
				end
				if string.sub(stack:get_name(), 0, 14) == "north_compass:" then
					player:get_inventory():set_stack("main", i, get_compass_stack(player, stack))
				end
			end
		end
	end
end)

local directions = {
	[0] = S("North"),
	S("North-northwest"),
	S("Northwest"),
	S("West-northwest"),
	S("West"),
	S("West-southwest"),
	S("Southwest"),
	S("South-southwest"),
	S("South"),
	S("South-southeast"),
	S("Southeast"),
	S("East-southeast"),
	S("East"),
	S("East-northeast"),
	S("Northeast"),
	S("North-northeast"),
}

-- register items
for i = 0, 15 do
	local image = "north_compass_16_"..i..".png"
	local groups = {}
	if i > 0 then
		groups.not_in_creative_inventory = 1
	end
	minetest.register_tool("north_compass:"..i, {
		description = S("Compass Facing @1", directions[i]),
		inventory_image = image,
		wield_image = image,
		groups = groups,
	})
end

minetest.register_craft({
	output = 'north_compass:0',
	recipe = {
		{'', 'group:wood', ''},
		{'group:wood', 'default:steel_ingot', 'group:wood'},
		{'', 'group:wood', ''}
	}
})
