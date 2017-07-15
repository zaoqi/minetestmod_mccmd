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

local function reg(name, from)
	if minetest.chatcommands[from] then
		minetest.register_chatcommand(name, minetest.chatcommands[from])
	end
end
reg("who", "list")
reg("tp", "teleport")
reg("summon", "spawnentity")
reg("stop", "shutdown")
