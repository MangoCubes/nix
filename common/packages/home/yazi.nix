{
  pkgs,
  username,
  unstable,
  ...
}:
let
  stateFile = "/home/${username}/Sync/LinuxConfig/data/yazi/projects.json";
in
{
  programs.bash.shellAliases.y = "kitty yazi . & disown";
  programs.yazi = {
    package = unstable.yazi;
    enable = true;
    #    enableNushellIntegration = true;
    settings = {
      mgr.linemode = "mtime";
      opener = {
        apk = [
          {
            run = ''adb install "$@"'';
            desc = "Install Application";
            orphan = true;
          }
        ];
        sops = [
          {
            run = ''kitty sops "$@"'';
            for = "unix";
            desc = "Decrypt";
            orphan = true;
          }
        ];
        pdf = [
          {
            run = ''mullvad-browser --new-window "$@"'';
            for = "unix";
            desc = "Browser";
            orphan = true;
          }
        ];
        nix = [
          {
            run = ''kitty bash -c "nix-shell \"$@\""'';
            for = "unix";
            desc = "Nix Shell";
            orphan = true;
          }
        ];
        devenv = [
          {
            run = ''kitty bash -c "devenv shell"'';
            for = "unix";
            desc = "Dev Shell";
            orphan = true;
          }
        ];

        terminal = [
          {
            run = ''kitty "$@"'';
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
        extract = [
          {
            run = ''for file in "$@"; do f=''${file##*/}; ouch decompress $file -d "./''${f%.*}"; done;'';
            desc = "Extract";
            orphan = true;
          }
        ];
      };
      open.rules = [
        {
          name = "*.apk";
          use = [ "apk" ];
        }
        {
          name = "*.enc.*";
          use = [ "sops" ];
        }
        {
          name = "*.pdf";
          use = [ "pdf" ];
        }
        {
          name = "*.zip";
          use = [ "extract" ];
        }
        {
          name = "*.tgz";
          use = [ "extract" ];
        }
        {
          name = "*.tar.gz";
          use = [ "extract" ];
        }
        {
          name = "*.tar";
          use = [ "extract" ];
        }
        {
          name = "*.nix";
          use = [
            "edit"
            "devenv"
            "nix"
          ];
        }
        {
          name = "*.m3u";
          use = [
            "vlc"
            "open"
          ];
        }
        # Folder
        {
          name = "*/";
          use = [
            "terminal"
            "dolphin"
            "edit"
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
        # Media
        {
          mime = "{audiovideo}/*";
          use = [ "play" ];
        }
        # Archive
        {
          mime = "application/{g}zip";
          use = [ "extract" ];
        }
        {
          mime = "application/x-{tarbzip*7z-compressedxzrar}";
          use = [ "extract" ];
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
          name = "*";
          use = [
            "open"
            "edit"
            "dolphin"
          ];
        }
      ];
    };
    keymap = {
      mgr.prepend_keymap = [
        {
          on = [
            "m"
          ];
          run = "plugin yamb save";
          desc = "Save current position as a bookmark";
        }

        {
          on = [
            "`"
          ];
          run = "plugin yamb jump_by_key";
          desc = "Jump to a bookmark";
        }
        {
          on = [
            "'"
          ];
          run = "plugin yamb jump_by_key";
          desc = "Jump to a bookmark";
        }

        {
          on = [
            "b"
            "d"
          ];
          run = "plugin yamb delete_by_key";
          desc = "Delete a bookmark";
        }

        {
          on = [
            "b"
            "D"
          ];
          run = "plugin yamb delete_all";
          desc = "Delete all bookmarks";
        }
        {
          on = "T";
          run = [
            ''shell --orphan -- kitty -d "$(dirname '$@')" ''
          ];
        }
        {
          on = "U";
          run = [
            ''shell 'umount "$@"' ''
          ];
        }
        {
          on = "y";
          run = [
            ''shell 'for path in "$@"; do echo "file://$path"; done | wl-copy -t text/uri-list' --confirm''
            "yank"
          ];
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
            "P"
            "s"
          ];
          run = "plugin projects save";
          desc = "Save current project";
        }
        {
          on = [
            "P"
            "l"
          ];
          run = "plugin projects load";
          desc = "Load project";
        }
        {
          on = [
            "P"
            "P"
          ];
          run = "plugin projects load_last";
          desc = "Load last project";
        }
        {
          on = [
            "P"
            "d"
          ];
          run = "plugin projects delete";
          desc = "Delete project";
        }
        {
          on = [
            "P"
            "D"
          ];
          run = "plugin projects delete_all";
          desc = "Delete all projects";
        }
        {
          on = [
            "P"
            "m"
          ];
          run = "plugin projects 'merge current'";
          desc = "Merge current tab to other projects";
        }
        {
          on = [
            "P"
            "M"
          ];
          run = "plugin projects 'merge all'";
          desc = "Merge current project to other projects";
        }
        {
          on = [
            "c"
            "b"
          ];
          run = [
            ''shell 'cat "$@" | wl-copy' ''
          ];
          desc = "Copy file into clipboard";
        }
        {
          on = [
            "c"
            "z"
          ];
          run = [
            ''shell 'ouch compress $@ compressed.zip' ''
          ];
          desc = "Archive selected files to .zip";
        }
        {
          on = [
            "c"
            "t"
          ];
          run = [
            ''shell 'ouch compress $@ compressed.tar.gz' ''
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
        yamb = pkgs.fetchFromGitHub {
          owner = "h-hg";
          repo = "yamb.yazi";
          rev = "main";
          sha256 = "sha256-NMxZ8/7HQgs+BsZeH4nEglWsRH2ibAzq7hRSyrtFDTA=";
        };
      };

    initLua =
      (builtins.readFile ./yazi/yamb.lua)
      + (builtins.replaceStrings [ "<StateFile>" ] [ stateFile ] (builtins.readFile ./yazi/init.lua));
  };
}
