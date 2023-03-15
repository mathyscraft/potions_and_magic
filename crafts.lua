minetest.register_craft({
    type = "shapeless",
    output = "potions_and_magic:water_glass_bottle 1",
    recipe = {"vessels:glass_bottle", "bucket:bucket_water"}
})
minetest.register_craft({
    type = "shapeless",
    output = "potions_and_magic:health_potion 1",
    recipe = {
        "potions_and_magic:water_glass_bottle", 
        "potions_and_magic:vitality_plant", 
        "potions_and_magic:vitality_plant", 
        "potions_and_magic:vitality_plant", 
        "potions_and_magic:vitality_plant"
    }
})
minetest.register_craft({
    type = "shapeless",
    output = "potions_and_magic:nightvision_potion 1",
    recipe = {
        "potions_and_magic:water_glass_bottle", 
        "potions_and_magic:glow_mushroom",
        "potions_and_magic:glow_mushroom",
        "potions_and_magic:glow_mushroom",
        "potions_and_magic:glow_mushroom"
    }
})
minetest.register_craft({
    type = "shapeless",
    output = "potions_and_magic:golden_apple 1",
    recipe = {"default:apple", "default:gold_ingot"}
})
minetest.register_craft({
    type = "shapeless",
    output = "potions_and_magic:weightlessness_potion 1",
    recipe = {
        "potions_and_magic:water_glass_bottle", 
        "potions_and_magic:golden_apple",
        "potions_and_magic:golden_apple",
        "potions_and_magic:golden_apple",
        "potions_and_magic:golden_apple"
    }
})
minetest.register_craft({
    type = "shapeless",
    output = "potions_and_magic:water_breathing_potion 1",
    recipe = {
        "potions_and_magic:water_glass_bottle", 
        "potions_and_magic:gillykelp",
        "potions_and_magic:gillykelp",
        "potions_and_magic:gillykelp",
        "potions_and_magic:gillykelp"
    }
})
minetest.register_craft({
    type = "shapeless",
    output = "potions_and_magic:sugar 1",
    recipe = {"potions_and_magic:sugar_cane"}
})
minetest.register_craft({
    type = "shapeless",
    output = "potions_and_magic:speed_potion 1",
    recipe = {
        "potions_and_magic:water_glass_bottle", 
        "potions_and_magic:sugar",
        "potions_and_magic:sugar",
        "potions_and_magic:sugar",
        "potions_and_magic:sugar"
    }
})
minetest.register_craft({
    type = "shapeless",
    output = "potions_and_magic:slime 9",
    recipe = {"potions_and_magic:slime_block"}
})
minetest.register_craft({
    type = "shapeless",
    output = "potions_and_magic:slime_block 1",
    recipe = {
        "potions_and_magic:slime", 
        "potions_and_magic:slime",
        "potions_and_magic:slime",
        "potions_and_magic:slime",
        "potions_and_magic:slime",
        "potions_and_magic:slime",
        "potions_and_magic:slime",
        "potions_and_magic:slime",
        "potions_and_magic:slime"
    }
})
minetest.register_craft({
    type = "shapeless",
    output = "potions_and_magic:jump_potion 1",
    recipe = {
        "potions_and_magic:water_glass_bottle", 
        "potions_and_magic:slime",
        "potions_and_magic:slime",
        "potions_and_magic:slime",
        "potions_and_magic:slime"
    }
})