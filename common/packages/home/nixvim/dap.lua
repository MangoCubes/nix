local dap = require("dap")

local function get_executable_path(name)
	local handle = io.popen("which " .. name)
	if handle == nil then
		error(name .. " is not installed! Please install it.")
	end
	local result = handle:read("*a"):gsub("%s+", "")
	handle:close()
	return result
end

local ldap = get_executable_path("lldb-dap")

dap.adapters.lldb = {
	type = "executable",
	command = ldap,
	name = "lldb",
}
