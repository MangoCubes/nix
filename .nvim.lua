local function debug_flake()
	-- nixosConfigurations.<device>
	vim.cmd('silent !term bash -c "nix repl ." &')
end

vim.keymap.set('n', '<M-s>', debug_flake, { noremap = true, silent = true })
