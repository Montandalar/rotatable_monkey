minetest.register_node("rotatable_monkey:monkey_head", {
    drawtype = "mesh",
    mesh = "monkey_head.obj",
    tiles = {"rotatable_monkey_monkeytex.png"},
    paramtype2 = "degrotate",
    groups = {cracky=1}
})

local function generate_rotate_handler(multiplier)
    return function(itemstack, user, pointed_thing)
        if not pointed_thing.type == "node" then return false end

        local pos = minetest.get_pointed_thing_position(pointed_thing)
        if not pos then return end

        local node = minetest.get_node(pos)
        if not node.name == "rotatable_monkey:monkey_head" then return end

        local increment = 1
        if minetest.is_player(user) then
            local ctrl = user:get_player_control()
            if ctrl.sneak then increment = 15 end
            if ctrl.aux1 then increment = 30 end
        end

        node.param2 = (node.param2 + (increment*multiplier) ) % 240
        minetest.swap_node(pos, node)
    end
end

minetest.register_tool("rotatable_monkey:monkey_rotator", {
    description = "Monkey Rotator\nLeft-click: Clockwise\nRight-click: Anticlockwise\nSneak: increment of 22.5°\nAux1/Special: increment of 45°",
    short_description = "Monkey Rotator",
    inventory_image = "rotatable_monkey_tool.png",
    on_use = generate_rotate_handler(-1),
    on_place = generate_rotate_handler(1),
})
