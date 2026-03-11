require("bunny"):setup({
	hops = {
		{ key = "/",          path = "/", },
		{ key = "T",          path = "~/.local/share/Trash/files",         desc = "Trash" },
		{ key = "t",          path = "~/Temp", },
		{ key = "d",          path = "~/Downloads",                        desc = "Downloads" },
		{ key = "p",          path = "~/Nextcloud/Projects",               desc = "Projects" },
		{ key = "I",          path = "~/Mounts/Cloud/Documents/Important", desc = "Important Documents" },
		-- Quick sync gets its own unique hotkey because it should be fast
		{ key = "q",          path = "~/Sync/Quick Sync" },
		{ key = "n",          path = "~/Sync/Notes" },

		{ key = { "s", "s" }, path = "~/Sync" },
		{ key = { "s", "e" }, path = "~/Sync/EmacsConfig" },
		{ key = { "s", "g" }, path = "~/Sync/GeneralConfig" },
		{ key = { "s", "l" }, path = "~/Sync/LinuxConfig" },
		{ key = { "s", "n" }, path = "~/Sync/NixConfig" },
		{ key = { "s", "N" }, path = "~/Sync/NixEnv" },
		{ key = { "s", "q" }, path = "~/Sync/Quick Sync" },
		{ key = { "s", "p" }, path = "~/Sync/Passwords" },

		{ key = { "l", "s" }, path = "~/.local/share",                     desc = "Local share" },
		{ key = { "l", "b" }, path = "~/.local/bin",                       desc = "Local bin" },
		{ key = { "l", "t" }, path = "~/.local/state",                     desc = "Local state" },

		{ key = { "m", "a" }, path = "~/Mounts/Android/" },
		{ key = { "m", "c" }, path = "~/Mounts/Cloud/" },
		{ key = { "m", "K" }, path = "~/Mounts/Koofr/" },
		{ key = { "m", "k" }, path = "~/Mounts/Secrets" },
		{ key = { "m", "s" }, path = "~/Mounts/server-main/" },
		{ key = { "m", "m" }, path = "~/Mounts/" },

		{ key = { "c", "c" }, path = "~/Mounts/Cloud" },
		{ key = { "c", "d" }, path = "~/Mounts/Cloud/Documents" },
	},
	desc_strategy = "path", -- If desc isn't present, use "path" or "filename", default is "path"
	ephemeral = true,    -- Enable ephemeral hops, default is true
	tabs = true,         -- Enable tab hops, default is true
	notify = true,       -- Notify after hopping, default is false
	fuzzy_cmd = "fzf",   -- Fuzzy searching command, default is "fzf"
})
