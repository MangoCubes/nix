function(state)
  local node = state.tree:get_node()
  local filepath = node.path
  local osType = os.getenv("OS")

  local command

  if osType == "Windows_NT" then
    command = "start " .. filepath
  elseif osType == "Darwin" then
    command = "open " .. filepath
  else
    command = "xdg-open " .. filepath
  end
  vim.notify("Opening file " .. filepath .. "!")
  os.execute("(" .. command .. " &)")
end
