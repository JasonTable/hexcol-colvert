minetest.register_chatcommand("colvert", {
    params = "<radius>",
    privs = {server=true},
    description = "Convert old hexcol nodes to new ones",
    func = function(name, param)
        local player = minetest.get_player_by_name(name)
        local radius = tonumber(param)
        if player == nil or radius == nil then return end
        local pos = vector.round(player:get_pos())
        local count = 0
        for x = pos.x-radius, pos.x+radius, 1 do
            for y = pos.y-radius, pos.y+radius, 1 do
                for z = pos.z-radius, pos.z+radius, 1 do
                    local node = minetest.get_node(vector.new(x,y,z))
                    local hex = string.match(node.name,"%x%x%x")
                    if string.match(node.name,"hexcol:%x%x%x") then
                        local ipos = vector.new(x,y,z)
                        -- update with new block 
                        minetest.set_node(ipos,{
                            name = "hexcol:"..string.sub(hex,1,1).."xx",
                            param2 = tonumber("0x"..string.sub(hex,2,3))
                        })
                        count = count+1
                    end
                end
            end
        end
        return true, ("Converted %d nearby nodes."):format(count)
    end,
})