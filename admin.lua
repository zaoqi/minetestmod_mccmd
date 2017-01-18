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
		local privs_unknown = ""
		local basic_privs =
			minetest.string_to_privs(minetest.setting_get("basic_privs") or "interact,shout")
		for priv, _ in pairs(grantprivs) do
			if not basic_privs[priv] and
					not minetest.check_player_privs(name, {privs=true}) then
				return false, "Your privileges are insufficient."
			end
			if not minetest.registered_privileges[priv] then
				privs_unknown = privs_unknown .. "Unknown privilege: " .. priv .. "\n"
			end
			privs[priv] = true
		end
		if privs_unknown ~= "" then
			return false, privs_unknown
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
	description = "Kill the player or you",
	params = "[player]",
	privs = {kill = true},
	func = function(name, param)
		local target
		local targetname
		if param == "" then
			target = minetest.get_player_by_name(name)
		else
			target = minetest.get_player_by_name(param)
		end
		
		if target then
			targetname = target:get_player_name()
			target:set_hp(0)
			minetest.chat_send_all(targetname .. " fell out of the world")
			minetest.chat_send_player(name, "Killed " .. targetname)
		else
			minetest.chat_send_player(name, minetest.colorize("#FF0000", "Player not found: " .. param))		
		end
	end
})