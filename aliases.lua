do
	local function reg(name, from)
		if minetest.chatcommands[from] then
			minetest.register_chatcommand(name, minetest.chatcommands[from])
		end
	end
    reg("who", "list")
    reg("tp", "teleport")
    reg("summon", "spawnentity")
    reg("stop", "shutdown")
end