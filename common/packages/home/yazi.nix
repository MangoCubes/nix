{
  pkgs,
  username,
  device,
  unfree,
  config,
  lib,
  yazi,
  ...
}:
let
  isServer = device.type == "server";
  stateFile = "/home/${username}/Sync/LinuxConfig/data/yazi/projects.json";
  linktofile = pkgs.writeShellScriptBin "linktofile" ''cat "$@" > "$@-temp" && rm "$@" && mv "$@-temp" "$@"'';
  pastecp = pkgs.writeShellScriptBin "pastecp" ''
    OUTPUT=$(wl-paste -t text/uri-list || exit 0)
    if [ "$(echo "$OUTPUT" | grep -c -v '^file:///' )" -eq 0 ]; then
      echo "$OUTPUT" | while read -r line; do
        FILE_PATH="''${line#file://}"
        cp -r "$FILE_PATH" .
      done
    fi
  '';
  launch-flake = pkgs.writeShellScriptBin "launch-flake" ''
    dir=$(dirname "$@");
    cd "$dir" && nix develop;
  '';
in
{
  home.packages = [
    linktofile
    pastecp
  ];
  xdg.mimeApps.defaultApplications."inode/directory" = "yazi.desktop";
  programs.bash.shellAliases.y = "dt yazi";
  programs.yazi = {
    enable = true;
    package = yazi.packages.${pkgs.system}.default.override {
      _7zz = unfree._7zz-rar;
    };
    settings = {
      mgr.linemode = "mtime";
      opener =
        (
          if isServer then
            { }
          else
            {
              flake = [
                {
                  run = ''dt ${launch-flake}/bin/launch-flake "$@"'';
                  for = "unix";
                  desc = "Nix Flake";
                  orphan = true;
                }
              ];
              nix = [
                {
                  run = ''dt nix-shell "$@"'';
                  for = "unix";
                  desc = "Nix Shell";
                  orphan = true;
                }
              ];
              terminal = [
                {
                  run = (config.custom.terminal.genCmd { workingDirectory = ''$(dirname "$@")''; });
                  desc = "Open in terminal";
                  orphan = true;
                }
              ];
              vlc = [
                {
                  run = ''vlc "$@"'';
                  desc = "Open in VLC";
                  orphan = true;
                }
              ];
              dolphin = [
                {
                  run = ''dolphin "$@"'';
                  desc = "Open in Dolphin";
                  orphan = true;
                }
              ];
              apk = [
                {
                  run = ''adb install "$@"'';
                  desc = "Install Application";
                  orphan = true;
                }
              ];
              sops = [
                {
                  run = (config.custom.terminal.genCmd { command = ''sops "$@"''; });
                  for = "unix";
                  desc = "Decrypt";
                  orphan = true;
                }
              ];
              pdf = [
                {
                  run = ''browser "$@"'';
                  desc = "Browser";
                  orphan = true;
                }
                {
                  run = ''pdfjam --outfile "$@" --angle 270 --fitpaper true --rotateoversize true "$@"'';
                  desc = "Rotate Clockwise";
                  orphan = true;
                }
                {
                  run = ''pdfjam --outfile "$@" --angle 90 --fitpaper true --rotateoversize true "$@"'';
                  desc = "Rotate Anticlockwise";
                  orphan = true;
                }
              ];
            }
        )
        // {
          extract = [
            {
              run = ''for file in "$@"; do f=''${file##*/}; ouch decompress "$file" -d "./''${f%.*}"; done;'';
              desc = "Extract";
              orphan = true;
            }
          ];
          compress = [
            {
              run = ''ouch compress "$@" "$@.zip"'';
              desc = "Compress to .zip";
              orphan = true;
            }
            {
              run = ''ouch compress "$@" "$@.tar.gz"'';
              desc = "Compress to .tar.gz";
              orphan = true;
            }
          ];
          edit = [
            {
              run = "\${EDITOR:-vi} %s";
              desc = "$EDITOR";
              block = true;
            }
          ];
        };
      open.rules =
        (
          if isServer then
            [ ]
          else
            [
              {
                url = "*.apk";
                use = [ "apk" ];
              }
              {
                url = "*.enc.*";
                use = [ "sops" ];
              }
              {
                url = "*.pdf";
                use = [ "pdf" ];
              }
              {
                url = "*shell.nix";
                use = [
                  "edit"
                  "nix"
                ];
              }
              {
                url = "*flake.nix";
                use = [
                  "edit"
                  "flake"
                ];
              }
              {
                url = "*.m3u";
                use = [
                  "vlc"
                  "open"
                ];
              }
              # Media
              {
                mime = "{audiovideo}/*";
                use = [ "vlc" ];
              }
            ]
        )
        ++ [
          {
            mime = "application/{zip,rar,7z*,tar,gzip,xz,zstd,bzip*,lzma,compress,archive,cpio,arj,xar,ms-cab*}";
            use = [
              "extract"
            ];
          }
          # Folder
          {
            url = "*/";
            use =
              if isServer then
                [
                  "compress"
                ]
              else
                [
                  "terminal"
                  (lib.mkIf (!isServer) "dolphin")
                  "compress"
                ];
          }
          # Text
          {
            mime = "text/*";
            use = [ "edit" ];
          }
          # Image
          {
            mime = "image/*";
            use = [ "open" ];
          }
          # JSON
          {
            mime = "application/{jsonx-ndjson}";
            use = [ "edit" ];
          }
          # Empty file
          {
            mime = "inode/x-empty";
            use = [ "edit" ];
          }
          # Fallback
          {
            url = "*";
            use = [
              "open"
              "edit"
              (lib.mkIf (!isServer) "dolphin")
            ];
          }
        ];
    };
    keymap = {
      mgr.prepend_keymap =
        (
          if isServer then
            [ ]
          else
            [
              {
                on = "P";
                run = "shell 'pastecp' ";
              }
              {
                on = "T";
                run = [
                  "shell --orphan -- ${config.custom.terminal.genCmd { workingDirectory = ''$(dirname "$@")''; }}"
                ];
              }
              {
                on = [
                  "c"
                  "c"
                ];
                run = [
                  ''shell 'cat "$@" | wl-copy' ''
                ];
                desc = "Copy file into clipboard";
              }
            ]
        )
        ++ [
          {
            on = "y";
            run = [
              (lib.mkIf (
                !isServer
              ) ''shell 'for path in "$@"; do echo "file://$path"; done | wl-copy -t text/uri-list' --confirm'')
              "yank"
            ];
          }
          {
            on = "`";
            run = "plugin bunny";
            desc = "Jump to a bookmark";
          }
          {
            on = "'";
            run = "plugin bunny fuzzy";
            desc = "Jump to a bookmark by fzf";
          }
          {
            on = "U";
            run = [
              ''shell 'umount "$@"' ''
            ];
          }
          {
            on = "p";
            run = "paste";
          }
          {
            on = [
              "c"
              "m"
            ];
            run = "plugin chmod";
            desc = "Chmod on selected files";
          }
          {
            on = [
              "W"
              "s"
            ];
            run = "plugin projects save";
            desc = "Save current project";
          }
          {
            on = [
              "W"
              "l"
            ];
            run = "plugin projects load";
            desc = "Load project";
          }
          {
            on = [
              "W"
              "W"
            ];
            run = "plugin projects load_last";
            desc = "Load last project";
          }
          {
            on = [
              "W"
              "d"
            ];
            run = "plugin projects delete";
            desc = "Delete project";
          }
          {
            on = [
              "W"
              "D"
            ];
            run = "plugin projects delete_all";
            desc = "Delete all projects";
          }
          {
            on = [
              "W"
              "m"
            ];
            run = "plugin projects 'merge current'";
            desc = "Merge current tab to other projects";
          }
          {
            on = [
              "W"
              "M"
            ];
            run = "plugin projects 'merge all'";
            desc = "Merge current project to other projects";
          }
          {
            on = [
              "c"
              "L"
            ];
            run = [
              "shell 'linktofile $@' "
            ];
            desc = "Convert a link into a regular file";
          }
          {
            on = [
              "c"
              "p"
            ];
            run = [
              "copy path"
            ];
            desc = "Copy path of the file";
          }
          {
            on = [
              "c"
              "z"
            ];
            run = [
              "shell 'ouch compress $@ compressed.zip' "
            ];
            desc = "Archive selected files to .zip";
          }
          {
            on = [
              "c"
              "t"
            ];
            run = [
              "shell 'ouch compress $@ compressed.tar.gz' "
            ];
            desc = "Archive selected files to .tar.gz";
          }
          {
            on = [
              "M"
            ];
            run = "plugin mount";
            desc = "Mount plugin";
          }
        ];
    };
    plugins =
      let
        plugins-repo = pkgs.fetchFromGitHub {
          owner = "yazi-rs";
          repo = "plugins";
          rev = "main";
          hash = "sha256-80mR86UWgD11XuzpVNn56fmGRkvj0af2cFaZkU8M31I=";
        };
      in
      {
        chmod = "${plugins-repo}/chmod.yazi";
        mount = "${plugins-repo}/mount.yazi";
        # compress = "${plugins-repo}/compress.yazi";
        # full-border = "${yazi-plugins}/full-border.yazi";
        # max-preview = "${yazi-plugins}/max-preview.yazi";
        projects = pkgs.fetchFromGitHub {
          owner = "MasouShizuka";
          repo = "projects.yazi";
          rev = "main";
          sha256 = "sha256-XHGlQn0Nsxh/WScz4v2I+IWvzGJ9QTXbB7zgSCPQ+E0=";
        };
        bunny = pkgs.fetchFromGitHub {
          owner = "stelcodes";
          repo = "bunny.yazi";
          rev = "main";
          sha256 = "sha256-hTD/gW+xdz5rN3e/hyI9U/E17MlKgDd9sTnfES7SxCo=";
        };
        # yamb = pkgs.fetchFromGitHub {
        #   owner = "h-hg";
        #   repo = "yamb.yazi";
        #   rev = "main";
        #   sha256 = "sha256-NMxZ8/7HQgs+BsZeH4nEglWsRH2ibAzq7hRSyrtFDTA=";
        # };
      };

    initLua =
      (builtins.readFile ./yazi/bunny.lua)
      + (builtins.replaceStrings [ "<StateFile>" ] [ stateFile ] (builtins.readFile ./yazi/init.lua));
  };
}
