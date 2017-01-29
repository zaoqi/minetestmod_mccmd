--Copyright (c) 2016 zaoqi  

--This program is free software: you can redistribute it and/or modify
--it under the terms of the GNU Affero General Public License as published
--by the Free Software Foundation, either version 3 of the License, or
--(at your option) any later version.

--This program is distributed in the hope that it will be useful,
--but WITHOUT ANY WARRANTY; without even the implied warranty of
--MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--GNU Affero General Public License for more details.

--You should have received a copy of the GNU Affero General Public License
--along with this program.  If not, see <http://www.gnu.org/licenses/>.
dofile(minetest.get_modpath("mccmd").."/admin.lua")
minetest.after(0, function()
	dofile(minetest.get_modpath("mccmd").."/aliases.lua")
end)
minetest.register_chatcommand("list", {
	description = "show who is logged on",
	func = function(name)
		local players = ""
		for _, player in ipairs(minetest.get_connected_players()) do
			players = players..player:get_player_name().."\n"
		end
		minetest.chat_send_player(name, players)
	end
})

minetest.register_chatcommand("ping", {
   description = "Ping",
   func = function()
      return true, "Pong!"
   end,
})

minetest.register_chatcommand("suicide", {
	description = "Suicide",
	func = function(name
		minetest.get_player_by_name(name):set_hp(0)
		minetest.chat_send_all(name .. " fell out of the world")
	end
})
