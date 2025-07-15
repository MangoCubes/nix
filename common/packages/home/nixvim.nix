{
  pkgs,
  inputs,
  unstable,
  device,
  ...
}:
let
  # Disable if headless
  dih = attrset: (if device == "server" then { } else attrset);
  # Empty if headless
  eih = attrset: (if device == "server" then [ ] else attrset);
in
{
  imports = [ inputs.nixvim.homeManagerModules.nixvim ];
  home.packages = [
    pkgs.nil
    pkgs.lazygit
  ];
  programs.nixvim = {
    nixpkgs.pkgs = unstable;
    enable = true;
    colorschemes.catppuccin = {
      enable = true;
      settings.color_overrides = {
        mocha = {
          rosewater = "#f5e0dc";
          flamingo = "#f2cdcd";
          pink = "#f5c2e7";
          mauve = "#cba6f7";
          red = "#ff1688";
          maroon = "#ff629d";
          peach = "#fab387";
          yellow = "#ffcc11";
          green = "#a6e3a1";
          teal = "#94e2d5";
          sky = "#89dceb";
          sapphire = "#74c7ec";
          blue = "#47c8c0";
          lavender = "#b4befe";
          text = "#d6d9da";
          subtext1 = "#adb3b5";
          subtext0 = "#9ca4a6";
          overlay2 = "#8c9597";
          overlay1 = "#7b8589";
          overlay0 = "#6b767a";
          surface2 = "#5a676b";
          surface1 = "#465053";
          surface0 = "#3c4547";
          base = "#282e2f";
          mantle = "#1e2223";
          crust = "#090a0b";
        };
      };
    };
    clipboard = dih {
      providers.wl-copy.enable = true;
      register = "unnamedplus";
    };
    plugins =
      (dih {
        nix.enable = true;
        treesitter.enable = true;
        dap.enable = true;
        dap-lldb.enable = true;
        dap-ui.enable = true;
        dap-virtual-text.enable = true;
        # notify.enable = true;
        gitsigns.enable = true;
        neoscroll = {
          enable = true;
          settings = {
            cursor_scrolls_alone = true;
            easing_function = "quadratic";
            mappings = [
              "<C-u>"
              "<C-d>"
              "<C-b>"
              "<C-f>"
              "<C-y>"
              "<C-e>"
              "zt"
              "zz"
              "zb"
            ];
          };
        };
        # noice.enable = true;

        # nvim-jdtls.enable = true;
        navic = {
          enable = true;
          settings.lsp.auto_attach = true;
        };
        lsp = {
          enable = true;
          inlayHints = true;
          servers = {
            clangd.enable = true;
            ts_ls.enable = true;
            jdtls.enable = true;
            pyright.enable = true;
            nil_ls = {
              settings.formatting.command = [ "${pkgs.nixfmt-rfc-style}/bin/nixfmt" ];
              enable = true;
            };
            lua_ls = {
              enable = true;
              settings = {
                diagnostics.globals = [
                  "require"
                  "vim"
                ];
              };
            };
            jsonls.enable = true;
            # hls = {
            #   enable = true;
            #   installGhc = true;
            # };
            rust_analyzer = {
              enable = true;
              installCargo = false;
              installRustc = false;
            };
            # typos_lsp.enable = true;
          };
        };
        lsp-format.enable = true;
        neoclip.enable = true;
        # smear-cursor = {
        #   enable = true;
        # };
      })
      // {
        marks = {
          enable = true;
        };
        grug-far.enable = true;
        lz-n.enable = true;
        lualine = {
          settings = {
            options.section_separators = {
              left = "◣";
              right = "◢";
            };
            #            sections = {
            #              lualine_c = { 'filename',
            #            };
          };
          enable = true;
        };
        auto-save = {
          enable = true;
          settings.condition = (builtins.readFile ./nixvim/auto-save.lua);
        };
        comment = {
          enable = true;
          settings = {
            mappings = {
              basic = true;
              extra = true;
            };
            padding = true;
            sticky = true;
          };
        };
        gitignore.enable = true;
        yazi.enable = true;
        telescope.enable = true;
        image = {
          enable = true;
          settings.backend = "kitty";
        };
        startify = {
          enable = true;
          settings = {
            change_to_dir = true;
            custom_header = [
              " __       __ ______ __    __ __    __ __     __ ______ __       __ "
              "|  \\     /  \\      \\  \\  /  \\  \\  |  \\  \\   |  \\      \\  \\     /  \\"
              "| ▓▓\\   /  ▓▓\\▓▓▓▓▓▓ ▓▓ /  ▓▓ ▓▓  | ▓▓ ▓▓   | ▓▓\\▓▓▓▓▓▓ ▓▓\\   /  ▓▓"
              "| ▓▓▓\\ /  ▓▓▓ | ▓▓ | ▓▓/  ▓▓| ▓▓  | ▓▓ ▓▓   | ▓▓ | ▓▓ | ▓▓▓\\ /  ▓▓▓"
              "| ▓▓▓▓\\  ▓▓▓▓ | ▓▓ | ▓▓  ▓▓ | ▓▓  | ▓▓\\▓▓\\ /  ▓▓ | ▓▓ | ▓▓▓▓\\  ▓▓▓▓"
              "| ▓▓\\▓▓ ▓▓ ▓▓ | ▓▓ | ▓▓▓▓▓\\ | ▓▓  | ▓▓ \\▓▓\\  ▓▓  | ▓▓ | ▓▓\\▓▓ ▓▓ ▓▓"
              "| ▓▓ \\▓▓▓| ▓▓_| ▓▓_| ▓▓ \\▓▓\\| ▓▓__/ ▓▓  \\▓▓ ▓▓  _| ▓▓_| ▓▓ \\▓▓▓| ▓▓"
              "| ▓▓  \\▓ | ▓▓   ▓▓ \\ ▓▓  \\▓▓\\\\▓▓    ▓▓   \\▓▓▓  |   ▓▓ \\ ▓▓  \\▓ | ▓▓"
              " \\▓▓      \\▓▓\\▓▓▓▓▓▓\\▓▓   \\▓▓ \\▓▓▓▓▓▓     \\▓    \\▓▓▓▓▓▓\\▓▓      \\▓▓"
            ];
          };
        };
        telescope = {
          # lazyLoad.enable = true;
          keymaps = {
            "<leader>ff" = {
              action = "find_files";
              options.desc = "Find files";
            };
            "<leader>fg" = {
              action = "live_grep";
              options.desc = "Live grep";
            };
            "<leader>fb" = {
              action = "buffers";
              options.desc = "Find buffers";
            };

            "<leader>fh" = {
              action = "help_tags";
              options.desc = "Telescope help tags";
            };
          };
        };

        multicursors.enable = true;
        cmp = {
          enable = true;
          autoEnableSources = true;
          settings = {
            sources =
              [
                { name = "path"; }
                { name = "buffer"; }
              ]
              ++ (eih [
                { name = "cmp-dictionary"; }
                { name = "cmp-dap"; }
                { name = "nvim_lsp"; }
                { name = "orgmode"; }
              ]);
            mapping = {
              "<Up>" = "cmp.mapping.select_prev_item()";
              "<Down>" = "cmp.mapping.select_next_item()";
              "<Tab>" = "cmp.mapping.confirm({ select = true })";
              "<CR>" =
                "cmp.mapping({
                  i = function(fallback)
                    if cmp.visible() and cmp.get_active_entry() then
                      cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
                    else
                      fallback()
                    end
                  end,
                  s = cmp.mapping.confirm({ select = true }),
                  -- c = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }),
                })";

              "<Esc>" = ''
                function (fallback)
                  if (cmp.visible()) then
                    cmp.abort()
                    vim.defer_fn(
                      function ()
                        vim.cmd("stopinsert")
                      end,
                      0 -- 0 milliseconds
                    )
                  else
                    fallback()
                  end
                end'';
            };
            preselect = "cmp.PreselectMode.None";
          };
          cmdline =
            let
              base = sources: {
                mapping.__raw = "cmp.mapping.preset.cmdline()";
                inherit sources;
              };
            in
            let
              buffer = (base [ { name = "buffer"; } ]);
            in
            {
              ":" =
                (base [
                  { name = "path"; }
                  { name = "cmdline"; }
                ])
                // {
                  matching.disallow_symbol_nonprefix_matching = false;
                };
              "/" = buffer;
              "?" = buffer;
            };
          #lazyLoad.enable = true;
        };
        lazygit.enable = true;
        neo-tree = {
          enable = true;
          enableGitStatus = true;
          enableModifiedMarkers = true;
          enableRefreshOnWrite = true;
          window = {
            sameLevel = true;
            mappings = {
              "gx" = {
                command.__raw = (builtins.readFile ./nixvim/xdg-open.lua);
                desc = "Open file in external application";
              };
              "gX" = {
                command.__raw = (builtins.readFile ./nixvim/open-terminal.lua);
                desc = "Open file location in terminal";
              };
            };
          };
        };
        web-devicons.enable = true;
        which-key.enable = true;
        yanky = {
          enable = true;
          enableTelescope = true;
        };
      };

    globals.mapleader = " ";
    opts = {
      number = true;
      shiftwidth = 4;
      # autochdir = true;
      # virtualedit = "onemore";
      tabstop = 4;
      expandtab = false;
      conceallevel = 2;
      # concealcursor = "nc";
      whichwrap = "<,>,[,]";
      ignorecase = true;
      smartcase = true;
      relativenumber = true;
      fillchars.fold = " ";
      foldmethod = "expr";
      foldexpr = "v:lua.vim.treesitter.foldexpr()";
      foldenable = false;
      foldlevel = 99;
    };

    viAlias = true;
    vimAlias = true;

    keymaps = (
      (eih [
        {
          key = "<M-S-s>";
          action = "<cmd>DapNew<CR>";
          mode = "n";
          options = {
            noremap = true;
            silent = true;
          };
        }
        {
          key = "<M-e>";
          action = "<cmd>DapEval<CR>";
          mode = "n";
          options = {
            noremap = true;
            silent = true;
          };
        }
        {
          key = "<M-Left>";
          action = "<cmd>DapStepOut<CR>";
          mode = "n";
          options = {
            noremap = true;
            silent = true;
          };
        }
        {
          key = "<M-CR>";
          action = "<cmd>DapContinue<CR>";
          mode = "n";
          options = {
            noremap = true;
            silent = true;
          };
        }
        {
          key = "<M-Right>";
          action = "<cmd>DapStepIn<CR>";
          mode = "n";
          options = {
            noremap = true;
            silent = true;
          };
        }
        {
          key = "<M-Down>";
          action = "<cmd>DapStepOver<CR>";
          mode = "n";
          options = {
            noremap = true;
            silent = true;
          };
        }
        {
          key = "<M-q>";
          action = "<cmd>DapTerminate<CR>";
          mode = "n";
          options = {
            noremap = true;
            silent = true;
          };
        }
        {
          key = "<M-b>";
          action = "<cmd>DapToggleBreakpoint<CR>";
          mode = "n";
          options = {
            noremap = true;
            silent = true;
          };
        }
        {
          key = "<M-t>";
          action = "<cmd>DapVirtualTextToggle<CR>";
          mode = "n";
          options = {
            noremap = true;
            silent = true;
          };
        }
        {
          key = "<M-S-t>";
          action = "<cmd>DapVirtualTextForceRefresh<CR>";
          mode = "n";
          options = {
            noremap = true;
            silent = true;
          };
        }
        {
          key = "<leader>ca";
          action = ''<cmd>let @+ = expand("%:p")<CR>'';
          options.desc = "Copy absolute filename";
        }
        {
          key = "<leader>py";
          action = ''<cmd>silent exec "!kitty yazi &"<CR>'';
          options.desc = "Launch Yazi";
        }
        {
          key = "<leader>pt";
          action = ''<cmd>silent exec "!kitty bash &"<CR>'';
          options.desc = "Launch Kitty terminal";
        }
      ])
      ++ [
        {
          key = "<leader>s";
          action = ":Neotree<CR>";
          options.desc = "Open Neotree";
        }
        {
          key = "<leader>S";
          action = ":Neotree reveal<CR>";
          options.desc = "Reveal the current file in Neotree";
        }
        {
          key = "<leader>g";
          action = ":LazyGit<CR>";
          options.desc = "Open LazyGit";
        }
        {
          key = "<leader>tn";
          action = "<cmd>tabnew<CR><cmd>Neotree<CR>";
          options.desc = "Open a new tab";
        }
        {
          key = "<leader>tq";
          action = "<cmd>tabclose<CR>";
          options.desc = "Close tab";
        }
        {
          key = "<leader>d";
          action = "<cmd>diffthis<CR>";
          options.desc = "Diff this file";
        }
        {
          key = "<leader>fn";
          action = ''<cmd>Telescope notify<CR>'';
          options.desc = "View all notifications";
        }
        {
          key = "<leader>tt";
          action = "<cmd>tabnew | term<CR>";
          options.desc = "Open a new tab and open a terminal";
        }
        {
          key = "<leader>y";
          action = "<cmd>Yazi<CR>";
        }
        {
          key = "<leader>Y";
          action = "<cmd>Yazi cwd<CR>";
        }
        {
          key = "<leader>r";
          action = "<cmd>Yazi toggle<CR>";
        }
        {
          key = "<C-Esc>";
          action = "<C-\\><C-n>";
          mode = "t";
        }
        {
          key = "<C-`>";
          action = ":belowright split | resize 15 | terminal<CR>";
        }
        {
          key = "<C-n>";
          action = "<cmd>vnew<CR>";
        }

        # {
        #   key = "<leader>";
        #   action = "<cmd>w %:r-tmp.%:e<CR>";
        #   options.desc = "Temporarily save a file";
        # }
        {
          key = "g<Left>";
          action = "^";
          mode = "n";
          options.silent = true;
        }
        {
          key = "g<Right>";
          action = "$";
          mode = "n";
          options.silent = true;
        }
        {
          key = "g<UP>";
          action = "gg";
          mode = "n";
          options.silent = true;
        }
        {
          key = "g<DOWN>";
          action = "G";
          mode = "n";
          options.silent = true;
        }
        {
          key = "<Down>";
          action = "gj";
          mode = "n";
          options.silent = true;
        }
        {
          key = "<Up>";
          action = "gk";
          mode = "n";
          options.silent = true;
        }
        {
          key = "<Down>";
          action = "<C-o>gj";
          mode = "i";
          options.silent = true;
        }
        {
          key = "gD";
          action = "<cmd>lua vim.lsp.buf.declaration()<CR>";
          options.desc = "Go to declaration";
        }

        {
          key = "gd";
          action = "<cmd>lua vim.lsp.buf.definition()<CR>";
          options.desc = "Go to definition";
        }

        {
          key = "K";
          action = "<cmd>lua vim.lsp.buf.hover()<CR>";
          options.desc = "Show information at the cursor";
        }

        {
          key = "gr";
          action = "<cmd>lua vim.lsp.buf.references()<CR>";
        }

        {
          key = "gs";
          action = "<cmd>lua vim.lsp.buf.signature_help()<CR>";
        }

        {
          key = "gi";
          action = "<cmd>lua vim.lsp.buf.implementation()<CR>";
          options.desc = "Go to implementation";
        }

        {
          key = "gy";
          action = "<cmd>lua vim.lsp.buf.type_definition()<CR>";
        }

        {
          key = "<A-w>";
          action = "<cmd>lua vim.lsp.buf.document_symbol()<CR>";
        }

        {
          key = "<A-W>";
          action = "<cmd>lua vim.lsp.buf.workspace_symbol()<CR>";
        }

        {
          key = "<A-f>";
          action = "<cmd>lua vim.lsp.buf.code_action()<CR>";
        }

        {
          key = "S";
          action = "<cmd>lua vim.diagnostic.open_float()<CR>";
          options.desc = "Show warnings and errors at the cursor";
        }

        {
          key = "<A-r>";
          action = "<cmd>lua vim.lsp.buf.rename()<CR>";
          options.desc = "Rename a variable";
        }

        {
          key = "<leader>=";
          action = "<cmd>lua vim.lsp.buf.format()<CR>";
        }

        {
          key = "<A-i>";
          action = "<cmd>lua vim.lsp.buf.incoming_calls()<CR>";
        }

        {
          key = "<A-o>";
          action = "<cmd>lua vim.lsp.buf.outgoing_calls()<CR>";
        }
        {
          key = "<leader>n";
          action = ''<cmd>lua require("notify").dismiss({pending = true, silent = true})<CR>'';
          options.desc = "Clear all notifications";
        }
        {
          key = "<Up>";
          action = "<C-o>gk";
          mode = "i";
          options.silent = true;
        }
        {
          key = "<A-CR>";
          action = ''<cmd>lua require("orgmode").action("org_mappings.meta_return")<CR>'';
        }
        {
          key = "<A-RIGHT>";
          action = ''<cmd>lua require("orgmode").action("org_mappings.do_promote")<CR>'';
        }
        {
          key = "<A-LEFT>";
          action = ''<cmd>lua require("orgmode").action("org_mappings.do_demote")<CR>'';
        }

      ]
    );
    extraConfigLua = ''
      vim.o.exrc = true
      vim.api.nvim_create_autocmd("TermOpen", {
          pattern = "*",
          callback = function()
              vim.opt_local.number = true
              vim.opt_local.relativenumber = true
          end,
      })
    '';
  };
  xdg.mimeApps.defaultApplications."text/plain" = "nvim.desktop";
  home.sessionVariables.EDITOR = "nvim";
}
