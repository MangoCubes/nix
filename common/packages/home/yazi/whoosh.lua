require("whoosh"):setup({
	bookmarks = {
		{ key = "/",          path = "/",                                             tag = "/" },
		{ key = "T",          path = "~/.local/share/Trash/files",                    tag = "Trash" },
		{ key = "t",          path = "~/Temp",                                        tag = "~/Temp" },
		{ key = "d",          path = "~/Downloads",                                   tag = "Downloads" },
		{ key = "L",          path = "~/LocalDocuments/",                             tag = "Local Documents" },

		{ key = "N",          path = "~/Nextcloud",                                   tag = "Nextcloud Synchronised" },
		{ key = "p",          path = "~/Nextcloud/Projects",                          tag = "Projects" },
		{ key = "I",          path = "~/Nextcloud/Documents/Important",               tag = "Important Documents" },
		{ key = "S",          path = "~/Nextcloud/Documents/School/",                 tag = "School Files" },
		{ key = "C",          path = "~/Nextcloud/Documents/School/Research/Current", tag = "Current Researches" },

		{ key = "Q",          path = "~/Sync/Quick",                                  tag = "~/Sync/Quick" },
		{ key = "q",          path = "~/Sync/QuickSecure",                            tag = "~/Sync/QuickSecure" },
		{ key = "n",          path = "~/Sync/Notes",                                  tag = "~/Sync/Notes" },

		{ key = { "s", "s" }, path = "~/Sync",                                        tag = "~/Sync" },
		{ key = { "s", "e" }, path = "~/Sync/EmacsConfig",                            tag = "~/Sync/EmacsConfig" },
		{ key = { "s", "g" }, path = "~/Sync/GeneralConfig",                          tag = "~/Sync/GeneralConfig" },
		{ key = { "s", "l" }, path = "~/Sync/LinuxConfig",                            tag = "~/Sync/LinuxConfig" },
		{ key = { "s", "n" }, path = "~/Sync/NixConfig",                              tag = "~/Sync/NixConfig" },
		{ key = { "s", "N" }, path = "~/Sync/NixEnv",                                 tag = "~/Sync/NixEnv" },
		{ key = { "s", "p" }, path = "~/Sync/Passwords",                              tag = "~/Sync/Passwords" },

		{ key = { "l", "s" }, path = "~/.local/share",                                tag = "Local share" },
		{ key = { "l", "b" }, path = "~/.local/bin",                                  tag = "Local bin" },
		{ key = { "l", "t" }, path = "~/.local/state",                                tag = "Local state" },

		{ key = { "m", "a" }, path = "~/Mounts/Android/",                             tag = "~/Mounts/Android" },
		{ key = { "m", "c" }, path = "~/Mounts/Cloud/",                               tag = "~/Mounts/Cloud" },
		{ key = { "m", "K" }, path = "~/Mounts/Koofr/",                               tag = "~/Mounts/Koofr" },
		{ key = { "m", "k" }, path = "~/Mounts/Secrets",                              tag = "~/Mounts/Secrets" },
		{ key = { "m", "s" }, path = "~/Mounts/server-main/",                         tag = "~/Mounts/server-main" },
		{ key = { "m", "m" }, path = "~/Mounts/",                                     tag = "~/Mounts" },

		{ key = { "c", "d" }, path = "~/Mounts/Cloud/Documents",                      tag = "~/Mounts/Cloud/Documents" },
	},
	jump_notify = true,
	bookmarks_path = os.getenv("HOME") .. "/.local/state/yazi/whoosh-bookmarks",
})
