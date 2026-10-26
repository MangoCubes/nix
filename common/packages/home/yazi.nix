{
  pkgs,
  unfree,
  config,
  lib,
  inputs,
  colours,
  ...
}:
let
  isServer = config.custom.device.type == "server";
  zips = [
    "zip"
    "rar"
    "7z*"
    "tar"
    "gzip"
    "xz"
    "zstd"
    "bzip*"
    "lzma"
    "compress"
    "archive"
    "cpio"
    "arj"
    "xar"
    "ms-cab*"
  ];

in
{
  xdg = lib.mkIf (!isServer) {
    desktopEntries = {
      yazi-term = {
        name = "Yazi With Terminal";
        genericName = "Terminal File Manager";
        exec = config.custom.terminal.genCmd {
          command = "yazi %f";
        };
      };
    };
    mimeApps.defaultApplications =
      let
        zipsDefault = builtins.map (n: {
          "application/${n}" = "yazi-term.desktop";
        }) zips;
        merged = builtins.foldl' (x: y: x // y) { } zipsDefault;
      in
      {
        "inode/directory" = "yazi-term.desktop";
      }
      // merged;
  };
  programs.yazi = {
    enableZshIntegration = true;
    shellWrapperName = "y";
    enable = true;
    package = inputs.yazi.packages.${pkgs.stdenv.hostPlatform.system}.default.override {
      _7zz = unfree._7zz-rar;
    };
    settings = {
      mgr.linemode = "mtime";
      opener = lib.mkMerge [
        (lib.mkIf (!isServer) {
          flake = [
            {
              run = (
                config.custom.terminal.genCmd {
                  workingDirectory = "%d1";
                  command = "nix develop";
                }
              );
              for = "unix";
              desc = "Nix Flake";
              orphan = true;
            }
          ];
          nix = [
            {
              run = (config.custom.terminal.genCmd { command = "nix-shell %s1"; });
              for = "unix";
              desc = "Nix Shell";
              orphan = true;
            }
          ];
          terminal = [
            {
              run = (config.custom.terminal.genCmd { workingDirectory = "%s1"; });
              desc = "Open in terminal";
              orphan = true;
            }
          ];
          vlc = [
            {
              run = "vlc %s";
              desc = "Open in VLC";
              orphan = true;
            }
          ];
          dolphin = [
            {
              run = "dolphin %s";
              desc = "Open in Dolphin";
              orphan = true;
            }
          ];
          sops = [
            {
              run = "sops %s1";
              desc = "Edit decrypted";
              block = true;
            }
          ];
          apk = [
            {
              run = "adb install %s1";
              desc = "Install Application";
              orphan = true;
            }
          ];
          pdf = [
            {
              run = "browser %s";
              desc = "Browser";
              orphan = true;
            }
            {
              run = "pdfjam --outfile %s1 --angle 270 --fitpaper true --rotateoversize true %s1";
              desc = "Rotate Clockwise";
              orphan = true;
            }
            {
              run = "pdfjam --outfile %s1 --angle 90 --fitpaper true --rotateoversize true %s1";
              desc = "Rotate Anticlockwise";
              orphan = true;
            }
          ];
        })
        {
          extract = [
            {
              run = "ouch decompress %s";
              desc = "Extract";
              orphan = true;
            }
          ];
          compress = [
            {
              run = "ouch compress %s %s1.zip";
              desc = "Compress to .zip";
              orphan = true;
            }
            {
              run = "ouch compress %s %s1.tar.gz";
              desc = "Compress to .tar.gz";
              orphan = true;
            }
          ];
        }
      ];
      open.rules = lib.mkMerge [
        (lib.mkIf (!isServer) [
          {
            url = "*.enc.*";
            use = [ "sops" ];
          }
          {
            url = "*.apk";
            use = [ "apk" ];
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
            mime = "{audio,video}/*";
            use = [ "vlc" ];
          }
        ])
        [
          {
            mime = "application/{${builtins.concatStringsSep "," zips}}";
            use = [ "extract" ];
          }
          # Folder
          {
            url = "*/";
            use =
              if isServer then
                [ "compress" ]
              else
                [
                  "terminal"
                  "dolphin"
                  "compress"
                ];
          }
          {
            url = "*.org";
            use = [ "open" ];
            orphan = true;
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
            mime = "application/{json,ndjson}";
            use = [ "edit" ];
          }
          # Empty file
          {
            mime = "inode/empty";
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
        ]
      ];
    };
    keymap = {
      mgr.prepend_keymap = lib.mkMerge [
        (lib.mkIf (!isServer) [
          {
            on = [ "L" ];
            run = ''shell --orphan 'dragevac --load-dir "$PWD"' '';
            desc = "Mouse drag and drop current directory";
          }
          {
            on = "P";
            run = ''shell 'wl-paste -t text/uri-list | grep "^file:" | ${pkgs.trurl}/bin/trurl --url-file - --get "{path}" | xargs -r -d "\n" cp -r -t .' '';
          }
          {
            on = "T";
            run = [ "shell ${config.custom.shell.program} --block --confirm" ];
          }
          {
            on = [
              "c"
              "c"
            ];
            run = [ "shell 'cat %s | wl-copy' " ];
            desc = "Copy file into clipboard";
          }
        ])
        [
          {
            on = "M";
            run = "plugin mount";
          }
          {
            on = "y";
            run = [
              (lib.mkIf (!isServer)
                ''shell 'for f in %s; do ${pkgs.trurl}/bin/trurl --url file:/// --set "path=$f" --get "{url}\r"; done | wl-copy -t text/uri-list' ''
              )
              "yank"
            ];
          }
          {
            on = "`";
            run = "plugin whoosh jump_by_key";
            desc = "Jump to a bookmark";
          }
          {
            on = "'";
            run = "plugin whoosh jump_by_fzf";
            desc = "Jump to a bookmark by fzf";
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
              "c"
              "L"
            ];
            run = [
              ''shell 'for f in %s; do cp --remove-destination -- "$(readlink -f -- "$f")" "$f"; done' ''
            ];
            desc = "Convert a link into a regular file";
          }
          {
            on = [
              "c"
              "p"
            ];
            run = [ "copy path" ];
            desc = "Copy path of the file";
          }
          {
            on = [
              "c"
              "z"
            ];
            run = [ "shell 'ouch compress %s compressed.zip' " ];
            desc = "Archive selected files to .zip";
          }
          {
            on = [
              "c"
              "t"
            ];
            run = [ "shell 'ouch compress %s compressed.tar.gz' " ];
            desc = "Archive selected files to .tar.gz";
          }
        ]
      ];
    };
    plugins =
      let
        plugins-repo = pkgs.fetchFromGitHub {
          owner = "yazi-rs";
          repo = "plugins";
          rev = "main";
          hash = "sha256-IDmmXzQKFx3QZ9u5lMwcTOeWeMPWzIBeKBXkGAgJMaI=";
        };
      in
      {
        chmod = "${plugins-repo}/chmod.yazi";
        mount = "${plugins-repo}/mount.yazi";
        whoosh = pkgs.fetchFromGitHub {
          owner = "WhoSowSee";
          repo = "whoosh.yazi";
          rev = "d6ede9895a0e14b1bb1d65cd0eb783f92f2fc522";
          sha256 = "sha256-LwugSeuG3+PmPW9KFvRThqx+g792CmUnw+vY6wSZJoo=";
        };
      };
    theme = (import ./yazi/theme.nix) { inherit colours; };
    initLua = (builtins.readFile ./yazi/whoosh.lua);
  };
}
