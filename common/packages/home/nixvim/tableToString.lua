function TableToString(tbl, indent)
	indent = indent or 0
	local result = ""
	local spacing = string.rep("  ", indent)

	if type(tbl) == "table" then
		result = result .. "{\n"
		for key, value in pairs(tbl) do
			result = result .. spacing .. "  [" .. tostring(key) .. "] = "
			if type(value) == "table" then
				result = result .. TableToString(value, indent + 1)
			else
				result = result .. tostring(value) .. "\n"
			end
		end
		result = result .. spacing .. "}\n"
	else
		result = tostring(tbl) .. "\n"
	end

	return result
end
