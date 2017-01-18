dofile(minetest.get_modpath("mccmd").."/admin.lua")
minetest.register_chatcommand("list", {
	description = "show who is logged on",
	func = function(name, _)
		local players = ""
		for _, player in ipairs(minetest.get_connected_players()) do
			players = players..player:get_player_name().."\n"
		end
		minetest.chat_send_player(name, players)
	end
})

minetest.register_chatcommand("ping", {
   description = "Ping",
   func = function(_, _)
      return true, "Pong!"
   end,
})
dofile(minetest.get_modpath("mccmd").."/aliases.lua")