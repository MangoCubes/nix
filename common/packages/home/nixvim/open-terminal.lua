function(state)
	local node = state.tree:get_node()
	local path = node.path
	path = path:gsub("/+$", "")

	local lastSlashIndex = path:match("^(.*)/")

	local command = 'ghostty --working-directory="' .. lastSlashIndex .. '"'

	vim.notify("Opening terminal in " .. lastSlashIndex .. "!")
	os.execute("(" .. command .. " > /dev/null 2>&1 &)")
end
