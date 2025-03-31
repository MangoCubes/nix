local function debug_flake()
	-- nixosConfigurations.<device>
	vim.cmd('silent !kitty sh -c "nix repl --accept-flake-config ." &')
end

vim.keymap.set('n', '<M-s>', debug_flake, { noremap = true, silent = true })
