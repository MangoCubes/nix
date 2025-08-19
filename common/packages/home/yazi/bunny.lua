require("bunny"):setup({
	hops = {
		{ key = "/",          path = "/", },
		{ key = "T",          path = "~/.local/share/Trash/files",         desc = "Trash" },
		{ key = "t",          path = "~/Temp", },
		{ key = "D",          path = "~/Mounts/Cloud/Documents",           desc = "Documents" },
		{ key = "d",          path = "~/Downloads",                        desc = "Downloads" },
		{ key = "p",          path = "~/Documents/Projects",               desc = "Projects" },
		{ key = "I",          path = "~/Mounts/Cloud/Documents/Important", desc = "Important Documents" },
		-- Quick sync gets its own unique hotkey because it should be fast
		{ key = "q",          path = "~/Sync/Quick Sync" },

		{ key = { "s", "s" }, path = "~/Sync" },
		{ key = { "s", "n" }, path = "~/Sync/NixConfig" },
		{ key = { "s", "N" }, path = "~/Sync/NixEnv" },
		{ key = { "s", "e" }, path = "~/Sync/EmacsConfig" },
		{ key = { "s", "l" }, path = "~/Sync/LinuxConfig" },
		{ key = { "s", "q" }, path = "~/Sync/Quick Sync" },
		{ key = { "s", "g" }, path = "~/Sync/GeneralConfig" },

		{ key = { "l", "s" }, path = "~/.local/share",                     desc = "Local share" },
		{ key = { "l", "b" }, path = "~/.local/bin",                       desc = "Local bin" },
		{ key = { "l", "t" }, path = "~/.local/state",                     desc = "Local state" },

		{ key = { "m", "w" }, path = "~/Mounts/Work" },

		{ key = { "c", "c" }, path = "~/Mounts/Cloud" },
		{ key = { "c", "g" }, path = "~/Mounts/Cloud/Gallery" },
		{ key = { "c", "d" }, path = "~/Mounts/Cloud/Documents" },
		{ key = { "c", "p" }, path = "~/Mounts/Cloud/Projects" },
	},
	desc_strategy = "path", -- If desc isn't present, use "path" or "filename", default is "path"
	ephemeral = true,    -- Enable ephemeral hops, default is true
	tabs = true,         -- Enable tab hops, default is true
	notify = true,       -- Notify after hopping, default is false
	fuzzy_cmd = "fzf",   -- Fuzzy searching command, default is "fzf"
})
