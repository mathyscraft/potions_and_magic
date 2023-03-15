minetest.register_decoration({
    name = "potions_and_magic:vitality_plant",
    deco_type = "simple",
    place_on = {"default:dirt_with_grass"},
    sidelen = 16,
    noise_params = {
        offset = 0.00,
        scale = 0.003,
        spread = {x = 200, y = 200, z = 200},
        seed = 2,
        octaves = 3,
        persist = 0.8
    },
    y_max = 31000,
    y_min = 1,
    decoration = "potions_and_magic:vitality_plant",
})

minetest.register_decoration({
    name = "potions_and_magic:glow_mushroom",
    deco_type = "simple",
    place_on = {"default:stone"},
    sidelen = 16,
    noise_params = {
        offset = 0.03,
        scale = 0.06,
        spread = {x = 30, y = 30, z = 30},
        seed = 3,
        octaves = 3,
        persist = 0.7
    },
    flags = "all_floors", -- Permet la génération dans les grottes
    y_min = -31000,
    y_max = -0,
    decoration = "potions_and_magic:glow_mushroom",
})

minetest.register_decoration({
    name = "potions_and_magic:gillykelp",
    deco_type = "simple",
    place_on = {"default:sand"},
    place_offset_y = -1, -- Descend de 1 car "plantlike_rooted"
    sidelen = 16,
    noise_params = {
        offset = -0.01,
        scale = 0.02,
        spread = {x = 100, y = 100, z = 100},
        seed = 4,
        octaves = 3,
        persist = 0.6
    },
    flags = "force_placement",
    y_max = -1,
    y_min = -30,
    decoration = "potions_and_magic:gillykelp",
})

minetest.register_decoration({
    name = "potions_and_magic:sugar_cane",
    deco_type = "simple",
    place_on = {"default:sand"},
    sidelen = 16,
    noise_params = {
        offset = 0,
        scale = 0.02,
        spread = {x = 100, y = 100, z = 100},
        seed = 5,
        octaves = 3,
        persist = 0.7
    },
    y_max = 3,
    y_min = 1,
    height = 2,
    height_max = 4,
    spawn_by = "default:water_source",
    -- num_spawn_by = 1,
    decoration = "potions_and_magic:sugar_cane"
})

minetest.register_decoration({
    name = "potions_and_magic:slime_block",
    deco_type = "simple",
    place_on = {"default:dirt_with_grass", "default:dirt_with_rainforest_litter", "default:dirt_with_coniferous_litter"},
    place_offset_y = -1,
    sidelen = 16,
    noise_params = {
        offset = 0,
        scale = 0.04,
        spread = {x = 100, y = 100, z = 100},
        seed = 4,
        octaves = 3,
        persist = 0.6
    },
    biomes = {"coniferous_forest", "rainforest", "rainforest_swamp"},
    flags = "force_placement",
    y_max = 31000,
    y_min = 1,
    decoration = "potions_and_magic:slime_block",
})