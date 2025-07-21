require("projects"):setup({
	save = {
		method = "lua",          -- yazi | lua
		lua_save_path = "<StateFile>", -- windows: "%APPDATA%/yazi/state/projects.json", unix: "~/.config/yazi/state/projects.json"
	},
	last = {
		update_after_save = true,
		update_after_load = true,
	},
	merge = {
		quit_after_merge = false,
	},
	notify = {
		enable = true,
		title = "Projects",
		timeout = 3,
		level = "info",
	},
})
return {
	entry = function()
		local h = cx.active.current.hovered
		ya.manager_emit(h and h.cha.is_dir and "enter" or "open", { hovered = true })
	end,
}
