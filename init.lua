
--
-- Blocks :
--
minetest.register_node("potions_and_magic:vitality_plant", {
    description = "vitality plant",
    drawtype = "plantlike",
    waving = 1,
    tiles = {"pm_vitality_plant.png"},
    inventory_image = "pm_vitality_plant.png",
	wield_image = "pm_vitality_plant.png",
    groups = {flammable = 1, snappy = 3, flower = 1, flora = 1, attached_node = 1},
    sounds = default.node_sound_leaves_defaults(),
    sunlight_propagates = true,
    paramtype = "light",
    walkable = false,
    buildable_to = true,
    selection_box = {
		type = "fixed",
		fixed = {-4 / 16, -0.5, -4 / 16, 4 / 16, 2 / 16, 4 / 16}
	},
})

minetest.register_node("potions_and_magic:glow_mushroom", {
    description = "glow mushroom",
    drawtype = "plantlike",
	tiles = {"pm_glow_mushroom.png"},
	inventory_image = "pm_glow_mushroom.png",
	wield_image = "pm_glow_mushroom.png",
    paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	buildable_to = true,
	groups = {snappy = 3, attached_node = 1, flammable = 1},
	sounds = default.node_sound_leaves_defaults(),
	light_source = 6,
    selection_box = {
		type = "fixed",
		fixed = {-4 / 16, -0.5, -4 / 16, 4 / 16, -1 / 16, 4 / 16},
	},
})

minetest.register_node("potions_and_magic:gillykelp", {
    description = "gillykelp",
    drawtype = "plantlike_rooted",
    waving = 1,
	tiles = {"default_sand.png"}, -- texture de la "racine"
    special_tiles = {{name = "pm_gillykelp.png", tileable_vertical = true}},
    use_texture_alpha = "clip",
    inventory_image = "pm_gillykelp.png",
	wield_image = "pm_gillykelp.png",
    groups = {flammable = 1, snappy = 3, flora = 1, attached_node = 1},
    sounds = default.node_sound_leaves_defaults(),
    sunlight_propagates = true,
    paramtype = "light",
    walkable = false,
    buildable_to = true,
    light_source = 2,
    selection_box = {
		type = "fixed",
		fixed = {
            {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5},
            {-4/16, 0.5, -4/16, 4/16, 1.5, 4/16},
		},
	},
})

minetest.register_node("potions_and_magic:sugar_cane", {
    description = "sugar cane",
    drawtype = "plantlike",
	tiles = {"pm_sugar_cane.png"},
	inventory_image = "pm_sugar_cane.png",
	wield_image = "pm_sugar_cane.png",
    paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	groups = {snappy = 3, flammable = 1},
	sounds = default.node_sound_leaves_defaults(),
})

minetest.register_node("potions_and_magic:slime_block", {
    description = "slime block",
    drawtype = "nodebox",
    use_texture_alpha = "blend",
	tiles = {"pm_slime_block.png"},
    paramtype = "light",
	sunlight_propagates = true,
	groups = {snappy = 3, bouncy = 80, fall_damage_add_percent = -100},
	light_source = 3,
    node_box = {
        type = "fixed",
		fixed = {
				{-0.5, -0.5, -0.5, 0.5, 0.3, 0.5},
		},  
    },
    collision_box = {
        type = "fixed",
		fixed = {
				{-0.3, -0.3, -0.3, 0.3, 0.1, 0.3},
		},
    },
})

--
-- Items :
--
minetest.register_craftitem("potions_and_magic:water_glass_bottle", {
    description = "bottle of water",
    inventory_image = "pm_water_glass_bottle.png",
    on_use = minetest.item_eat(0),
})

local golden_apple_count = {} -- Permet l'accumulation de l'effet
minetest.register_craftitem("potions_and_magic:golden_apple",{
    description = "Golden Apple",
    inventory_image = "pm_golden_apple.png",
    on_use = function(itemstack, user, pointed_thing)
        user:set_physics_override({gravity = -1})

        if golden_apple_count[user] == nil then -- Pour la première utilisation
            golden_apple_count[user] = 1
        else
            golden_apple_count[user] = golden_apple_count[user] + 1
        end
        minetest.after(1, function()
            golden_apple_count[user] = golden_apple_count[user] - 1
            if golden_apple_count[user] == 0 then
                user:set_physics_override({gravity = 1})
            end
        end)
    end
})
minetest.register_craftitem("potions_and_magic:sugar",{
    description = "Sugar",
    inventory_image = "pm_sugar.png",
    -- on_use = minetest.item_eat(1)
})
minetest.register_craftitem("potions_and_magic:slime",{
    description = "Slime",
    inventory_image = "pm_slime.png"
})

local pm_path = minetest.get_modpath("potions_and_magic")
-- Crafts :
dofile(pm_path.."/crafts.lua")
-- Generation :
dofile(pm_path.."/gen.lua")
-- Potions :
dofile(pm_path.."/potions.lua")