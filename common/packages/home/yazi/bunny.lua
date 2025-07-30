require("bunny"):setup({
	hops = {
		{ key = "/",          path = "/", },
		{ key = "T",          path = "/tmp", },
		{ key = "D",          path = "~/Documents",       desc = "Documents" },
		{ key = "q",          path = "~/Sync/Quick Sync" },
		{ key = { "s", "s" }, path = "~/Sync" },
		{ key = { "s", "n" }, path = "~/Sync/NixConfig" },
		{ key = { "s", "N" }, path = "~/Sync/NixEnv" },
		{ key = { "s", "e" }, path = "~/Sync/EmacsConfig" },
		{ key = { "s", "l" }, path = "~/Sync/LinuxConfig" },
		{ key = { "l", "s" }, path = "~/.local/share",    desc = "Local share" },
		{ key = { "l", "b" }, path = "~/.local/bin",      desc = "Local bin" },
		{ key = { "l", "t" }, path = "~/.local/state",    desc = "Local state" },
	},
	desc_strategy = "path", -- If desc isn't present, use "path" or "filename", default is "path"
	ephemeral = true,    -- Enable ephemeral hops, default is true
	tabs = true,         -- Enable tab hops, default is true
	notify = true,       -- Notify after hopping, default is false
	fuzzy_cmd = "fzf",   -- Fuzzy searching command, default is "fzf"
})
