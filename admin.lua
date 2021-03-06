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

minetest.register_chatcommand("op", {
	params = S("<name>"),
	description = S("Give all privilege to player"),
	func = function(name, grantname)
		if not minetest.check_player_privs(name, {privs=true}) and
				not minetest.check_player_privs(name, {basic_privs=true}) then
			return false, S("Your privileges are insufficient.")
		end
		if not minetest.auth_table[grantname] then
			minetest.chat_send_player(name, minetest.colorize("#FF0000", S("That player cannot be found")))
			return false
		end
		local grantprivs = minetest.registered_privileges
		local privs = minetest.get_player_privs(grantname)
		local basic_privs =
			minetest.string_to_privs(minetest.setting_get("basic_privs") or "interact,shout")
		for priv, _ in pairs(grantprivs) do
			if not basic_privs[priv] and
					not minetest.check_player_privs(name, {privs=true}) then
				return false, S("Your privileges are insufficient.")
			end
			privs[priv] = true
		end
		minetest.set_player_privs(grantname, privs)
		minetest.chat_send_player(grantname, S("You are now op"))
		return true
	end,
})

minetest.register_chatcommand("deop", {
	params = S("<name>"),
	description = S("Remove all privilege from player"),
	privs = {},
	func = function(name, revoke_name)
		if not minetest.check_player_privs(name, {privs=true}) and
				not minetest.check_player_privs(name, {basic_privs=true}) then
			return false, S("Your privileges are insufficient.")
		end
		local revoke_priv_str = "all"
		if not minetest.auth_table[revoke_name] then
			minetest.chat_send_player(name, minetest.colorize("#FF0000", S("That player cannot be found")))
			return false
		end
		local revoke_privs = minetest.string_to_privs(revoke_priv_str)
		local privs = minetest.get_player_privs(revoke_name)
		local basic_privs =
			minetest.string_to_privs(minetest.setting_get("basic_privs") or "interact,shout")
		for priv, _ in pairs(revoke_privs) do
			if not basic_privs[priv] and
					not minetest.check_player_privs(name, {privs=true}) then
				return false, S("Your privileges are insufficient.")
			end
		end
		privs = {}
		minetest.set_player_privs(revoke_name, privs)
		minetest.chat_send_player(revoke_name, S("You are no longer op"))
		return true
	end,
})

minetest.register_privilege("kill", {description = "Can kill the players", give_to_singleplayer = false})
minetest.register_chatcommand("kill", {
	description = S("Kill the player"),
	params = S("[player]"),
	privs = {kill = true},
	func = function(name, targetname)
		local target = minetest.get_player_by_name(targetname)
		
		if target then
			target:set_hp(0)
			minetest.chat_send_all(targetname .. " fell out of the world")
			minetest.chat_send_player(name, "Killed " .. targetname)
		else
			minetest.chat_send_player(name, minetest.colorize("#FF0000", S("That player cannot be found")))
		end
	end
})

minetest.register_privilege("clear", {description = "Can clear player's inventory", give_to_singleplayer = false})

minetest.register_chatcommand("clear", {
	description = S("Clear [player]'s inventory"),
	params = S("[player] [item]"),
	privs = {clear = true},
	func = function(name, param)
		local function clear(pname, listname, itemname)
			local inv = minetest.get_inventory({type = "player", name = pname})
			local player = minetest.get_player_by_name(pname)
			if not player then return nil end
			if not inv then return nil end
			local list = inv:get_list(listname)
			if not list then return nil end
			local index, stack
			local count = 0
			local ss

			for index, stack in pairs(list) do
				if itemname == "*" then ss = stack:get_name() else ss = itemname end
				if (not inv:get_stack(listname, index):is_empty()) and stack:get_name() == ss then
					inv:set_stack(listname, index, ItemStack(""))
					count = count + 1
				end
			end
			return count
		end
		local user = minetest.get_player_by_name(name)
		local target = minetest.get_player_by_name(param:split(' ')[1] or "")
		local itemstring = param:split(' ')[2] or "*"
		local cleareditems
		if param == "" then
			target = user
		end
		if target then
			local count = 0
			count = count + (clear(name, "main", itemstring) or 0)
			count = count + (clear(name, "craft", itemstring) or 0)
			count = count + (clear(name, "craftpreview", itemstring) or 0)
			count = count + (clear(name, "craftresult", itemstring) or 0)
			if count == 0 then
				minetest.chat_send_player(name,
					minetest.colorize("#FF0000",
						S("Could not clear the inventory of @1, no items to remove", target:get_player_name())
					)
				)
			else
				minetest.chat_send_player(name,
					S("Cleared inventory of @1, removing @2 items.", target:get_player_name(), tostring(count))
				)
			end
		else
			minetest.chat_send_player(name, minetest.colorize("#FF0000", S("That player cannot be found")))
		end
	end
})

