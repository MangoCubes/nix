# NixVim documentation
# https://mattsturgeon.github.io/nixvim/
{
  pkgs,
  inputs,
  unstable,
  device,
  colours,
  config,
  ...
}:
let
  # Disable if headless
  dih = attrset: (if device.type == "server" then { } else attrset);
  # Empty if headless
  eih = attrset: (if device.type == "server" then [ ] else attrset);
in
{
  imports = [
    inputs.nixvim.homeModules.nixvim
    inputs.secrets.hm.nixvim
  ];
  home.packages = [
    pkgs.nil
    pkgs.lazygit
    pkgs.libxml2
  ];
  programs.nixvim = {
    autoCmd = [
      {
        desc = "Use xmllint if current file is XML";
        event = [
          "FileType"
        ];
        pattern = "xml";
        command = "set equalprg=xmllint\\ --format\\ -";
      }
    ];
    nixpkgs.pkgs = unstable;
    enable = true;
    highlight = {
      DapBreakpointText = {
        fg = "#${colours.base.teto}";
      };
      DapBreakpointLine = {
        bg = "#${colours.base.darkBg}";
      };
      DapStoppedText = {
        fg = "#${colours.base.rin}";
      };
      DapStoppedLine = {
        bg = "#${colours.base.lightBg}";
      };
    };
    colorschemes.catppuccin = {
      enable = true;
      settings = {
        transparent_background = true;
        color_overrides = {
          mocha = {
            rosewater = "#f5e0dc";
            flamingo = "#f2cdcd";
            pink = "#f5c2e7";
            mauve = "#cba6f7";
            red = "#ff1688";
            maroon = "#${colours.base.teto}";
            peach = "#fab387";
            yellow = "#${colours.base.rin}";
            green = "#a6e3a1";
            teal = "#94e2d5";
            sky = "#89dceb";
            sapphire = "#74c7ec";
            blue = "#${colours.base.miku}";
            lavender = "#b4befe";
            text = "#d6d9da";
            subtext1 = "#adb3b5";
            subtext0 = "#9ca4a6";
            overlay2 = "#8c9597";
            overlay1 = "#7b8589";
            overlay0 = "#6b767a";
            surface2 = "#${colours.base.lightBg}";
            surface1 = "#465053";
            surface0 = "#3c4547";
            base = "#282e2f";
            mantle = "#1e2223";
            crust = "#090a0b";
          };
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
        dap = {
          enable = true;
          signs = {
            dapBreakpoint = {
              text = "⬤";
              texthl = "DapBreakpointText";
              linehl = "DapBreakpointLine";
            };
            dapStopped = {
              text = "➤";
              texthl = "DapStoppedText";
              linehl = "DapStoppedLine";
            };
          };
        };
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
        # transparent.enable = true;
        nvim-surround.enable = true;
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
        blink-cmp = {
          settings.keymap.preset = "super-tab";
          enable = true;
          setupLspCapabilities = true;
        };
        lazygit.enable = true;
        neo-tree = {
          enable = true;
          settings = {
            enable_git_status = true;
            enable_diagnostics = true;
            name = {
              use_git_status_colors = true;
            };
            window = {
              insert_as = "sibling";
              same_level = true;
              mappings = {
                "F" = {
                  command = "clear_filter";
                };
              }
              // (dih {
                "gx" = {
                  command.__raw = (builtins.readFile ./nixvim/xdg-open.lua);
                  desc = "Open file in external application";
                };
                "gX" = {
                  command.__raw = (builtins.readFile ./nixvim/open-terminal.lua);
                  desc = "Open file location in terminal";
                };
              });
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
          action = ''<cmd>silent exec "!${
            config.custom.terminal.genCmd {
              command = "yazi";
              detached = true;
            }
          }"<CR>'';
          options.desc = "Launch Yazi";
        }

        {
          key = "<leader>lj";
          action = ''<cmd>setf json<CR>'';
          options.desc = "JSON";
        }
        {
          key = "<leader>pt";
          action = ''<cmd>silent exec "!td"<CR>'';
          options.desc = "Launch terminal";
        }
        {
          key = "<leader>pT";
          action = ''<cmd>silent exec "!niri msg action spawn -- t"<CR>'';
          options.desc = "Launch terminal outside this environment";
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
          key = "<A-e>";
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
          key = "<M-s>";
          action = (
            config.custom.terminal.genCmd {
              command = "start";
              detached = true;
            }
          );
          options.desc = ''Build (debug) and run program in a new terminal'';
        }
        {
          key = "<M-C-s>";
          action = (
            config.custom.terminal.genCmd {
              command = "start-release";
              detached = true;
            }
          );
          options.desc = ''Build (release) and run program in a new terminal'';
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
          action = "<cmd>tabnew | terminal /usr/bin/env bash<CR>";
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
          key = "<C-Esc>";
          action = "<C-\\><C-n>";
          mode = "t";
        }
        {
          key = "<C-`>";
          action = ":belowright split | resize 15 | terminal /usr/bin/env bash<CR>";
        }
        {
          key = "<C-n>";
          action = "<cmd>cn<CR>";
          options.desc = "Jump to next grep";
        }
        {
          key = "<C-S-n>";
          action = "<cmd>cp<CR>";
          options.desc = "Jump to previous grep";
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
          key = "$";
          action = "g$";
          options.silent = true;
        }
        {
          key = "^";
          action = "g^";
          options.silent = true;
        }
        {
          key = "g$";
          action = "$";
          options.silent = true;
        }
        {
          key = "g^";
          action = "^";
          options.silent = true;
        }
        {
          key = "g0";
          action = "0";
          options.silent = true;
        }
        {
          key = "gj";
          action = "<Down>";
          options.silent = true;
        }
        {
          key = "gk";
          action = "<Up>";
          options.silent = true;
        }
        {
          key = "g$";
          action = "$";
          options.silent = true;
        }
        {
          key = "0";
          action = "g0";
          options.silent = true;
        }
        {
          key = "<Down>";
          action = "gj";
          options.silent = true;
        }
        {
          key = "<Up>";
          action = "gk";
          options.silent = true;
        }
        {
          key = "<M-Left>";
          action = "gT";
          options.silent = true;
        }
        {
          key = "<M-Right>";
          action = "gt";
          options.silent = true;
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
      ]
    );
    extraConfigLua = builtins.concatStringsSep "\n" (
      [
        # Allow loading from .nvim.lua
        ''
          vim.o.exrc = true
        ''
      ]
      ++ (eih [
        # Fix for diagnostic window not closing automatically
        ''
          vim.diagnostic.open_float(nil, {close_events = {'BufLeave', 'CursorMoved', 'InsertEnter'}})
        ''
        # Ensure UI opens whenever DAP is enabled
        (builtins.readFile ./nixvim/dapui.lua)
        # Set up DAP for LLDB
        (builtins.readFile ./nixvim/dap.lua)
      ])
    );
  };
  xdg.mimeApps.defaultApplications."text/plain" = "nvim.desktop";
  home.sessionVariables.EDITOR = "nvim";
}
