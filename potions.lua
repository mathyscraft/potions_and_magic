local potion_manager = {}
minetest.register_on_joinplayer(function(player)
    local player_name = player:get_player_name()
    potion_manager[player_name] = {
        effects_hud = {
            health = {count = 0, position = 0 },
            speed = {count = 0, position = 0 }, 
            jump = {count = 0, position = 0 },
            gravity = {count = 0, position = 0 },
            nightvision = {count = 0, position = 0 },
            breath = {count = 0, position = 0 },
            camouflage = {count = 0, position = 0 }
        },
        positions = {false, false, false, false, false, false, false} -- Permet de connaitre les disponibilités de position    
    }
end)

function create_potion_hud(potion_effect, user)
    local player_name = user:get_player_name()
    local effect_count = potion_manager[player_name].effects_hud[potion_effect].count
    local effect_position = potion_manager[player_name].effects_hud[potion_effect].position
    local positions = potion_manager[player_name].positions
-- Si c'est le premier hud, cherche 1 à 1 la position la plus haute disponible
    if effect_count == 0 then 
        for i = 1, 7 do
            if positions[i] == false then
                effect_position =  i - 1
                positions[i] = true
                potion_manager[player_name].positions = positions -- update global
                potion_manager[player_name].effects_hud[potion_effect].position = effect_position
                -- minetest.debug(minetest.serialize(potion_manager[player_name].positions))
                break
            end
        end
    end
    
    local hud = user:hud_add({
        hud_elem_type = "image",
        text = "hud_" .. potion_effect .. ".png",
        scale = {x = 0.75, y = 0.75},
        position = {x = 1, y = 0.5},
        offset = {x = -40, y = -135 + 70*effect_position} -- place le hud en foction de la position de l'effet
    })
-- compte le nombre de potion bue d'un même effet :
    effect_count = effect_count + 1
    potion_manager[player_name].effects_hud[potion_effect].count = effect_count --update global
    -- minetest.debug(minetest.serialize(potion_effect .. " count :" .. potion_manager[player_name].effects_hud[potion_effect].count .. " position :" .. potion_manager[player_name].effects_hud[potion_effect].position))

    minetest.after(59, function()
-- retire 1 à 1 toutes les potions bues pendant que le joueur avait déjà l'effet
        potion_manager[player_name].effects_hud[potion_effect].count = potion_manager[player_name].effects_hud[potion_effect].count - 1
        -- minetest.debug(minetest.serialize(potion_effect .. " count :" .. potion_manager[player_name].effects_hud[potion_effect].count .. " position :" .. potion_manager[player_name].effects_hud[potion_effect].position))
        user:hud_remove(hud)
-- une fois tous les hud supprimés, on retire l'effet du compte et on libère sa position
        if potion_manager[player_name].effects_hud[potion_effect].count == 0 then
            potion_manager[player_name].positions[effect_position + 1] = false
            -- minetest.debug(minetest.serialize(potion_manager[player_name].positions))
        end
    end)
end

function change_hp_max(hp, user)
    user:set_properties({hp_max = hp})
    user:set_hp(hp)

    minetest.hud_replace_builtin("health", {
        hud_elem_type = "statbar",
        position = {x = 0.5, y = 1},
        text = "heart.png",
        text2 = "heart_gone.png",
        number = hp,
        item = hp,
        direction = 0,
        size = {x = 24, y = 24},
        offset = {x = (-10 * 24) - 25, y = -(48 + 24 + 16)},
    })
    
end

minetest.register_craftitem("potions_and_magic:health_potion", {
    description = "potion of health",
    inventory_image = "pm_health_potion.png",
    on_use = function(itemstack, user, pointed_thing)
        change_hp_max(40, user)
        create_potion_hud("health", user)
        local player_name = user:get_player_name()

        minetest.after(60, function()
            if potion_manager[player_name].effects_hud.health.count == 0 then
                change_hp_max(20, user)
            end
        end)
    end
})

minetest.register_craftitem("potions_and_magic:speed_potion", {
    description = "Potion of speed",
    inventory_image = "pm_speed_potion.png",
    on_use = function(itemstack, user, pointed_thing)
        user:set_physics_override({speed = 3})
        create_potion_hud("speed", user)
        local player_name = user:get_player_name()
        
        minetest.after(60, function()
            if potion_manager[player_name].effects_hud.speed.count == 0 then
                user:set_physics_override({speed = 1})
            end
        end)
    end
})

minetest.register_craftitem("potions_and_magic:jump_potion", {
    description = "Potion of jump",
    inventory_image = "pm_jump_potion.png",
    on_use = function(itemstack, user, pointed_thing)
        user:set_physics_override({jump = 2})
        create_potion_hud("jump", user)
        local player_name = user:get_player_name()

        minetest.after(60, function()
            if potion_manager[player_name].effects_hud.jump.count == 0 then
                user:set_physics_override({jump = 1})
            end
        end)
    end
})

minetest.register_craftitem("potions_and_magic:weightlessness_potion", {
    description = "Potion of weightlessness",
    inventory_image = "pm_weightlessness_potion.png",
    on_use = function(itemstack, user, pointed_thing)
        user:set_physics_override({gravity = 0.25})
        create_potion_hud("gravity", user)
        local player_name = user:get_player_name()

        minetest.after(60, function()
            if potion_manager[player_name].effects_hud.gravity.count == 0 then
                user:set_physics_override({gravity = 1})
            end
        end)
    end
})

minetest.register_craftitem("potions_and_magic:nightvision_potion", {
    description = "Potion of night vision",
    inventory_image = "pm_nightvision_potion.png",
    on_use = function(itemstack, user, pointed_thing)
        user:override_day_night_ratio(1)
        create_potion_hud("nightvision", user)
        local player_name = user:get_player_name()

        minetest.after(60, function()
            if potion_manager[player_name].effects_hud.nightvision.count == 0 then
                user:override_day_night_ratio(nil)
            end
        end)
    end
})

minetest.hud_replace_builtin("breath", {
    hud_elem_type = "statbar",
    position = {x = 0.5, y = 1},
    text = "bubble.png",
    text2 = "bubble_gone.png",
    number = 10 * 2,
    item = 10 * 2,
    direction = 0,
    size = {x = 24, y = 24},
    offset = {x = (-10 * 24) - 25, y = -(48 + 50 + 16)},
})

minetest.register_craftitem("potions_and_magic:water_breathing_potion", {
    description = "Potion of water breathing",
    inventory_image = "pm_water_breathing_potion.png",
    on_use = function(itemstack, user, pointed_thing)
        user:set_properties({breath_max = 999})
        user:set_breath(999)
        create_potion_hud("breath", user)
        local player_name = user:get_player_name()
        
        minetest.after(60, function()
            if potion_manager[player_name].effects_hud.nightvision.count == 0 then
                user:set_properties({breath_max = 10})
                user:set_breath(10)
            end
        end)
    end
})