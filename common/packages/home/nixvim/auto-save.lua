function(buf)
	local filename = vim.api.nvim_buf_get_name(buf)

	local patterns = {
		".txt",      -- Match txt
		".md",
		".org"
	}

	local function matchesAnyPattern(s, ps)
		for _, pattern in ipairs(ps) do
			if string.match(s, pattern) then
				return true
			end
		end
		return false
	end

	if matchesAnyPattern(filename, patterns) then
		return true
	end
	return false
end;
