local mod_pova = minetest.get_modpath("pova")
local potion_manager = {}
local potion_interval = 60

minetest.register_on_joinplayer(function(player)
    local player_name = player:get_player_name()
    potion_manager[player_name] = {
        in_use = {
            health = false,
            speed = false,
            jump = false,
            gravity = false,
            nightvision = false,
            breath = false,
            camouflage = false
        },
        -- Permet de connaitre les disponibilités de position
        positions = {false, false, false, false, false, false, false}
    }
end)

function create_potion_hud(potion_effect, user)
    local player_name = user:get_player_name()
    local position

    -- Si c'est le premier hud, cherche 1 à 1 la position la plus haute disponible
    if potion_manager[player_name].in_use[potion_effect] == false then
        for i = 1, 7 do
            if potion_manager[player_name].positions[i] == false then
                position =  i
                potion_manager[player_name].positions[i] = true
                -- store position so we can free it up when effect wears off
                potion_manager[player_name].in_use[potion_effect] = position
                break
            end
        end
    else
       -- effect potion already in use, return nil
       return
    end

    local hud = user:hud_add({
        hud_elem_type = "image",
        text = "hud_" .. potion_effect .. ".png",
        scale = {x = 0.75, y = 0.75},
        position = {x = 1, y = 0.5},
        -- place le hud en foction de la position de l'effet
        offset = {x = -40, y = -135 + 70 * (position - 1)}
    })

	return hud -- return hud number so potion timer can remove
end

local function remove_potion_hud(hud_number, user, potion_effect)
    -- remove hud element and reset potion effect position to 0
    user:hud_remove(hud_number)
    local player_name = user:get_player_name()
    local position = potion_manager[player_name].in_use[potion_effect]
    potion_manager[player_name].positions[position] = false
    potion_manager[player_name].in_use[potion_effect] = false
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
        local hud = create_potion_hud("health", user)
        if not hud then return end -- potion already in use
        local player_name = user:get_player_name()

        minetest.after(potion_interval, function()
            change_hp_max(20, user)
            remove_potion_hud(hud, user, "health")
        end)
    end
})

minetest.register_craftitem("potions_and_magic:speed_potion", {
    description = "Potion of speed",
    inventory_image = "pm_speed_potion.png",
    on_use = function(itemstack, user, pointed_thing)
        local player_name = user:get_player_name()
        if mod_pova then
           pova.add_override(player_name, "potions_and_magic:speed_potion", {speed = 2})
           pova.do_override(user)
        else
            user:set_physics_override({speed = 3})
        end
        local hud = create_potion_hud("speed", user)
        if not hud then return end -- potion already in use

        minetest.after(potion_interval, function()
            if mod_pova then
                pova.del_override(player_name, "potions_and_magic:speed_potion")
                pova.do_override(user)
            else
                user:set_physics_override({speed = 1})
            end
            remove_potion_hud(hud, user, "speed")
        end)
    end
})

minetest.register_craftitem("potions_and_magic:jump_potion", {
    description = "Potion of jump",
    inventory_image = "pm_jump_potion.png",
    on_use = function(itemstack, user, pointed_thing)
        local player_name = user:get_player_name()
        if mod_pova then
            pova.add_override(player_name, "potions_and_magic:jump_potion", {jump = 1})
            pova.do_override(user)
        else
            user:set_physics_override({jump = 2})
        end
        local hud = create_potion_hud("jump", user)
        if not hud then return end -- potion already in use

        minetest.after(potion_interval, function()
            if mod_pova then
                pova.del_override(player_name, "potions_and_magic:jump_potion")
                pova.do_override(user)
            else
                user:set_physics_override({jump = 1})
            end
            remove_potion_hud(hud, user, "jump")
        end)
    end
})

minetest.register_craftitem("potions_and_magic:weightlessness_potion", {
    description = "Potion of weightlessness",
    inventory_image = "pm_weightlessness_potion.png",
    on_use = function(itemstack, user, pointed_thing)
        local player_name = user:get_player_name()
        if mod_pova then
            pova.add_override(player_name, "potions_and_magic:weightlessness_potion", {gravity = -0.75})
            pova.do_override(user)
        else
            user:set_physics_override({gravity = 0.25})
        end
        local hud = create_potion_hud("gravity", user)
        if not hud then return end -- potion already in use

        minetest.after(potion_interval, function()
            if mod_pova then
                pova.del_override(player_name, "potions_and_magic:weightlessness_potion")
                pova.do_override(user)
            else
                user:set_physics_override({gravity = 1})
            end
            remove_potion_hud(hud, user, "gravity")
        end)
    end
})

minetest.register_craftitem("potions_and_magic:nightvision_potion", {
    description = "Potion of night vision",
    inventory_image = "pm_nightvision_potion.png",
    on_use = function(itemstack, user, pointed_thing)
        user:override_day_night_ratio(1)
        local hud = create_potion_hud("nightvision", user)
        if not hud then return end -- potion already in use
        local player_name = user:get_player_name()

        minetest.after(potion_interval, function()
            user:override_day_night_ratio(nil)
            remove_potion_hud(hud, user, "nightvision")
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
        local hud = create_potion_hud("breath", user)
        if not hud then return end -- potion already in use
        local player_name = user:get_player_name()

        minetest.after(potion_interval, function()
            user:set_properties({breath_max = 10})
            user:set_breath(10)
            remove_potion_hud(hud, user, "breath")
        end)
    end
})

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
