-- Bloc lumineux qui simulera une vision nocturne
minetest.register_node("potions_and_magic:light_block", {
    description = "light block (for nightvision potion)",
    tiles = {"pm_light_block.png"},
    drawtype = "plantlike", -- permet la transparence
    -- car  use_texture_alpha = "clip"  produit des bugs d'affichahe
	light_source = 15,
    walkable = false,
    pointable = false,
    diggable = false,
    groups = {not_in_creative_inventory = 1}
})

-- fonction qui place un bloc de lumière constament aux pieds du joueur
function light_walker(activate, player)
    local timer = 60 + minetest.get_gametime()
    local pos = nil
    local old_pos = nil
    local meta = player:get_meta()
    
    minetest.register_globalstep(function(dtime)
        if minetest.get_gametime() < timer then
            old_pos = pos
            pos = player:get_pos()
            meta:set_string("light_block_pos", minetest.pos_to_string(pos))

            if pos ~= old_pos then
                -- l'attente permet d'éviter qu'il n'y ai plus de bloc de lumière
                -- ATTENTION LE BLOC NE SE SUPPRIME PAS A LA DECONEXION
                -- minetest.after(2, function()
                    if old_pos ~= nil then 
                        minetest.set_node(old_pos, {name = "air"})
                    end
                -- end)
                minetest.set_node(pos, {name="potions_and_magic:light_block"})
            end

        else
            minetest.set_node(pos, {name = "air"})
        end

    end)
end

-- fonction appelée quand un joueur se déconnecte pour supprimer les blocs de lumière si ce n'est pas fait
function remove_light_block(player)
    minetest.debug("Player left")
    local meta = player:get_meta()
    local pos_string = meta:get_string("light_block_pos")
    local pos = minetest.string_to_pos(pos_string)
    local node = minetest.get_node(pos)
    if node.name == "potions_and_magic:light_block" then
        minetest.set_node(pos, {name = "air"})
    end
end
minetest.register_on_shutdown(function()
    for _, i in ipairs(minetest.get_connected_players()) do
        remove_light_block(i)
    end
end)
minetest.register_on_leaveplayer(function(left_player, timed_out)
    remove_light_block(left_player)
end)

minetest.register_craftitem("potions_and_magic:nightvision_potion", {
    description = "Potion of night vision",
    inventory_image = "pm_nightvision_potion.png",
    on_use = function(itemstack, user, pointed_thing)
        user:override_day_night_ratio(1)
        light_walker(true, user)
        create_potion_hud("nightvision", user)

        minetest.after(60, function()
            if effects_count.nightvision.count == 0 then
                user:override_day_night_ratio(nil)
            end
        end)
    end
})