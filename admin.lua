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
minetest.register_chatcommand("op", {
	params = "<name>",
	description = "Give all privilege to player",
	func = function(name, grantname)
		if not minetest.check_player_privs(name, {privs=true}) and
				not minetest.check_player_privs(name, {basic_privs=true}) then
			return false, "Your privileges are insufficient."
		end
		if not minetest.auth_table[grantname] then
			return false, "Player " .. grantname .. " does not exist."
		end
		local grantprivs = minetest.registered_privileges
		local privs = minetest.get_player_privs(grantname)
		local basic_privs =
			minetest.string_to_privs(minetest.setting_get("basic_privs") or "interact,shout")
		for priv, _ in pairs(grantprivs) do
			if not basic_privs[priv] and
					not minetest.check_player_privs(name, {privs=true}) then
				return false, "Your privileges are insufficient."
			end
			privs[priv] = true
		end
		minetest.set_player_privs(grantname, privs)
		minetest.log("action", name..' granted ('..minetest.privs_to_string(grantprivs, ', ')..') privileges to '..grantname)
		if grantname ~= name then
			minetest.chat_send_player(grantname, name
					.. " granted you privileges: "
					.. minetest.privs_to_string(grantprivs, ' '))
		end
		return true, "Privileges of " .. grantname .. ": "
			.. minetest.privs_to_string(
				minetest.get_player_privs(grantname), ' ')
	end,
})

minetest.register_chatcommand("deop", {
	params = "<name>",
	description = "Remove all privilege from player",
	privs = {},
	func = function(name, revoke_name)
		if not minetest.check_player_privs(name, {privs=true}) and
				not minetest.check_player_privs(name, {basic_privs=true}) then
			return false, "Your privileges are insufficient."
		end
		local revoke_priv_str = "all"
		if not minetest.auth_table[revoke_name] then
			return false, "Player " .. revoke_name .. " does not exist."
		end
		local revoke_privs = minetest.string_to_privs(revoke_priv_str)
		local privs = minetest.get_player_privs(revoke_name)
		local basic_privs =
			minetest.string_to_privs(minetest.setting_get("basic_privs") or "interact,shout")
		for priv, _ in pairs(revoke_privs) do
			if not basic_privs[priv] and
					not minetest.check_player_privs(name, {privs=true}) then
				return false, "Your privileges are insufficient."
			end
		end
		privs = {}
		minetest.set_player_privs(revoke_name, privs)
		minetest.log("action", name..' revoked ('
				..minetest.privs_to_string(revoke_privs, ', ')
				..') privileges from '..revoke_name)
		if revoke_name ~= name then
			minetest.chat_send_player(revoke_name, name
					.. " revoked privileges from you: "
					.. minetest.privs_to_string(revoke_privs, ' '))
		end
		return true, "Privileges of " .. revoke_name .. ": "
			.. minetest.privs_to_string(
				minetest.get_player_privs(revoke_name), ' ')
	end,
})

minetest.register_privilege("kill", {description = "Can kill the players", give_to_singleplayer = false})
minetest.register_chatcommand("kill", {
	description = "Kill the player",
	params = "[player]",
	privs = {kill = true},
	func = function(name, targetname)
		local target = minetest.get_player_by_name(targetname)
		
		if target then
			target:set_hp(0)
			minetest.chat_send_all(targetname .. " fell out of the world")
			minetest.chat_send_player(name, "Killed " .. targetname)
		else
			minetest.chat_send_player(name, minetest.colorize("#FF0000", "Player not found: " .. targetname))
		end
	end
})
