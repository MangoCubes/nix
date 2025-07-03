require("bookmarks"):setup({
	last_directory = { enable = false, persist = false, mode = "dir" },
	persist = "none",
	desc_format = "full",
	file_pick_mode = "hover",
	custom_desc_input = false,
	notify = {
		enable = false,
		timeout = 1,
		message = {
			new = "New bookmark '<key>' -> '<folder>'",
			delete = "Deleted bookmark in '<key>'",
			delete_all = "Deleted all bookmarks",
		},
	},
})
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
