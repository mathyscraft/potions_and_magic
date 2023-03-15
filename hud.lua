function create_potion_hud(potion_effect, user)
    local meta = user:get_meta()
    local effect_count = meta:get_int(potion_effect.."_count") or 0 -- Nombre de potion consomées pour cet effet
    local effect_hud_position = meta:get_int(potion_effect.."_position") or 0 -- position de l'hud de l'effet
    local position_availability = minetest.deserialize(meta:get_string("position_availability"))
        or {false, false, false, false, false, false, false} -- Permet de connaitre les disponibilités de position
    minetest.chat_send_player(user:get_player_name(), meta:get_string("position_availability") .. minetest.serialize(position_availability))
    -- Si c'est le premier hud créé pour cet effet, cherche la position la plus haute disponible
    if effect_count == 0 then 
        for i = 1, 7 do
            if not position_availability[i] then
                effect_hud_position = i - 1
                position_availability[i] = true -- Met à jour les disponibilités
                meta:set_string("position_availability", minetest.serialize(position_availability))
                minetest.chat_send_player(user:get_player_name(), meta:get_string("position_availability") .. minetest.serialize(position_availability))
                
                break
            end
        end
    end
    
    local hud = user:hud_add({
        hud_elem_type = "image",
        text = "hud_" .. potion_effect .. ".png",
        scale = {x = 0.75, y = 0.75},
        position = {x = 1, y = 0.5},
        offset = {x = -40, y = -135 + 70 * effect_hud_position} -- Place le hud en fonction de la position de l'effet
    })
    
    -- Compte le nombre de potion bue d'un même effet :
    effect_count = effect_count + 1
    meta:set_int(potion_effect.."_count", effect_count)
    meta:set_int(potion_effect.."_position", effect_hud_position)

    minetest.after(59, function()
        -- Retire 1 à 1 toutes les potions bues pendant que le joueur avait déjà l'effet
        effect_count = effect_count - 1
        user:hud_remove(hud)
        -- Une fois tous les huds supprimés, on retire l'effet du compte et on libère sa position
        if effect_count == 0 then 
            position_availability[effect_hud_position + 1] = false
            meta:set_string("position_availability", minetest.serialize(position_availability))
            minetest.chat_send_player(user:get_player_name(), minetest.colorize("#FF0000", "remove ".. potion_effect .. ": ".. effect_count.. " , ".. effect_hud_position))
        end
    end)
    minetest.chat_send_player(user:get_player_name(), hud.. " | ".. potion_effect.. ": ".. effect_count.. " , ".. effect_hud_position)
end


-------------------------
function create_potion_hud(potion_effect, user)
    local meta = user:get_meta()
    local effects_count = meta:get_int(potion_effect.."_count") or 0
    local position = meta:get_int(potion_effect.."_position") or 0
    
    -- Si c'est le premier hud, cherche 1 à 1 la position la plus haute disponible
    if effects_count == 0 then
        local positions = meta:get_string("positions")
        for i = 1, 7 do
            if positions:sub(i, i) == "0" then
                position = i - 1
                positions = positions:sub(1, i-1).."1"..positions:sub(i+1)
                break
            end
        end
        meta:set_string("positions", positions)
    end
    
    local hud = user:hud_add({
        hud_elem_type = "image",
        text = "hud_" .. potion_effect .. ".png",
        scale = {x = 0.75, y = 0.75},
        position = {x = 1, y = 0.5},
        offset = {x = -40, y = -135 + 70 * position}
    })
    
    effects_count = effects_count + 1
    meta:set_int(potion_effect.."_count", effect_count)
    meta:set_int(potion_effect.."_position", position)
    
    minetest.after(59, function()
        effects_count = effects_count - 1
        meta:set_int(potion_effect.."_count", effects_count)
        user:hud_remove(hud)
        
        if effects_count == 0 then
            local positions = meta:get_string("positions")
            positions = positions:sub(1, position+1).."0"..positions:sub(position+2)
            meta:set_string("positions", positions)
        end
    end)
end