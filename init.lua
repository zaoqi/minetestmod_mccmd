--Copyright (c) 2017 zaoqi  

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

-- Load support for intllib.
local S, NS = dofile(minetest.get_modpath("mccmd").."/intllib.lua")

dofile(minetest.get_modpath("mccmd").."/admin.lua")
minetest.after(0, function()
	dofile(minetest.get_modpath("mccmd").."/aliases.lua")
end)
minetest.register_chatcommand("list", {
	description = S("show who is logged on"),
	func = function(name)
		local players = ""
		for _, player in ipairs(minetest.get_connected_players()) do
			players = players..player:get_player_name().."\n"
		end
		minetest.chat_send_player(name, players)
	end
})

minetest.register_chatcommand("ping", {
   description = S("Ping"),
   func = function()
      return true, S("Pong!")
   end,
})

minetest.register_chatcommand("suicide", {
	description = S("Suicide"),
	func = function(name)
		minetest.get_player_by_name(name):set_hp(0)
		minetest.chat_send_all(S("@1 fell out of the world", name))
	end
})
