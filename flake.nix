{
  nixConfig = {
    # These servers hold the binaries that are built for us
    # We simply download them instead of building them ourselves
    substituters = [
      "https://nix-community.cachix.org"
      "https://cache.nixos.org/"
    ];
    trusted-substituters = [ ];

    # Their public keys in case the files are swapped by attackers
    trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    ];
  };
  # Where we will get our source code
  inputs = {
    mikuboot.url = "gitlab:evysgarden/mikuboot";
    nixvim = {
      url = "github:nix-community/nixvim";
    };
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    unstablePkg.url = "github:nixos/nixpkgs/nixos-unstable";
    niri-adv-rules.url = "github:MangoCubes/niri-adv-rules";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "unstablePkg";
    };
    ags = {
      url = "github:aylur/ags";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    kmonad = {
      url = "github:kmonad/kmonad?dir=nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    grub2-themes.url = "github:vinceliuice/grub2-themes";
    sops-nix.url = "github:Mic92/sops-nix";
    nix-alien.url = "github:thiagokokada/nix-alien";
    # Notice that the path starts with path:
    # This flake is stored in ./secrets
    secrets = {
      url = "path:/home/main/Sync/NixConfig/secrets";
      # flake = false;
      # inputs
    };
  };

  # This @ sign binds inputs to the value that comes after it
  # It's basically `let inputs = { self, nixpkgs, home-manager, unstable, ... }; in`
  outputs =
    inputs@{
      self,
      nixpkgs,
      home-manager,
      unstablePkg,
      sops-nix,
      ...
    }:
    let
      system = "x86_64-linux";
      # I build a sort of package repo from `unstablePkg`
      unstable = import unstablePkg { inherit system; };
      # Same thing, but I add additional property `config.allowUnfree = true`
      # This allows me to be explicit about pulling unfree packages without having to spam the config with `allowUnfreePredicate` stuff you get told about when you try to `nix-shell -p ...` an unfree package
      unfreeUnstable = import unstablePkg {
        inherit system;
        config.allowUnfree = true;
      };
      # Similar stuff, but it uses `nixpkgs` instead of `unstablePkg`
      # Any stuff downloaded from this are from NixOS 25.05
      pkgs = import nixpkgs {
        inherit system;
      };
      unfree = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      # Some personal variables
      username = "main";
      homeDir = "/home/${username}";
      colours = (import ./common/colours.nix);
    in
    # There is no real reasons to have multiple `let ... in`, but I like to add them for dividing variables into sections
    let
      # I define a function that takes in hostname, device config and extra modules I want to add, and returns a set that can be used as argument for the function nixpkgs.lib.nixosSystem
      # Reason for this to have both system builder (genSystem) and NixOS iso builder (genImage)
      sysBase =
        {
          hostname,
          device,
          extraModules,
        }:
        {
          # This particular line is equivalent to system = "x86_64-linux"
          inherit system;
          # This adds additional arguments to configuration.nix and other stuffs
          # Unstable packages can be accessed through 'unstable' and 'unfreeUnstable' argument
          specialArgs = {
            inherit
              inputs
              unstable
              unfree
              unfreeUnstable
              hostname
              device
              username
              homeDir
              ;
          };
          modules = [
            # This includes my basic desktop environment setup
            ./common/configuration.nix
            # This includes home manager module so that I can use home manager in my config
            # Note to self: This is not a function
            (home-manager.nixosModules.home-manager)
            {
              home-manager = {
                backupFileExtension = "backup";
                # Anything I put in here would become available when setting home-manager options
                # home-manager.users."${username}" =
                #   {
                #     pkgs,
                #     unstable,
                #     inputs,
                #     config,
                #     lib,
                #     system,
                #     ...
                #   }:
                extraSpecialArgs = {
                  inherit
                    inputs
                    unfreeUnstable
                    unstable
                    colours
                    hostname
                    device
                    system
                    username
                    homeDir
                    ;
                };
              };
            }
            # This allows me to use sops options within my config
            sops-nix.nixosModules.sops
          ]
          # ...then I add all extra modules at the end
          ++ extraModules;
        };
    in
    let
      genSystem =
        {
          hostname,
          device,
        }:
        let
          # This creates a module that you can add to the system
          # Once you add this module, this creates a bunch of new options such as `custom.features.tablet`
          # What makes this different from just adding new parameters like specialArgs is that these can be both read and written in the config
          # When added as specialArgs, you cannot change this within the config, and can only set them in flake.nix
          extraOptions = (import ./common/options.nix);
        in
        # And this is the value this function will return
        # I use hostname to set my device hostnames, and also specify which configuration should be loaded
        (sysBase {
          inherit hostname device;
          extraModules = (
            if device.type == "desktop" || device.type == "laptop" then
              [
                # This includes per-machine config based on the flake name
                ./desktop/${hostname}/configuration.nix
                extraOptions
              ]
            else if device.type == "server" then
              [
                # This includes per-machine config based on the flake name
                ./server/${hostname}/configuration.nix
              ]
            else
              builtins.throw "Invalid device type: ${device.type}"
          );
        });
      genImage =
        { hostname, device }:
        (sysBase {
          inherit hostname device;
          extraModules = [
            ./server/image/qcow.nix
            ./server/base/configuration.nix
            # This includes per-machine config based on the flake name
            ./server/${hostname}/configuration.nix
          ];
        });
    in
    {
      # This creates a development shell
      # With this, I can open development environment for this config folder by entering `nix develop`
      devShell.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.mkShell {
        packages = [ pkgs.bash ];
        shellHook =
          let
            initFile = pkgs.writeText ".bashrc" ''
              nvim .
            '';
          in
          ''
            bash --init-file ${initFile}; exit
          '';
      };
      # Generate config for each machine I have
      # homeConfigurations.portable = inputs.home-manager.lib.homeManagerConfiguration (
      #   ({
      #     pkgs = unstable;
      #   })
      #   // (genHome {
      #     hostname = "portable";
      #   })
      # );
      # This is note to self for the type for each parameter
      # This is not how you define parameter types
      # {
      #   hostname = string;
      #   device = {
      #     type = "laptop";
      #     features = {
      #       tablet = bool;
      #     };
      #     emacsScale = number;
      #     scale = number;
      #     presentation = bool;
      #     monitors = {
      #       x = number;
      #       y = number;
      #     }[];
      #   } | {
      #     type = "server";
      #   } | {
      #     type = "desktop";
      #     features = {
      #       tablet = bool;
      #     };
      #     scale = number;
      #     emacsScale = number;
      #     presentation = bool;
      #     monitors = {
      #       x = number;
      #       y = number;
      #     }[];
      #   };
      # }

      # This is the definition of my device named `laptop2`
      # To load config for this device, I would type `sudo nixos-rebuild --flake path:///home/main/Sync/NixConfig#laptop2 switch` if I didn't write a script for this
      nixosConfigurations.laptop2 = nixpkgs.lib.nixosSystem (genSystem {
        hostname = "laptop2";
        device = {
          type = "laptop";
          emacsScale = 1;
          scale = 1;
          presentation = false;
          monitors = [
            {
              x = 1920;
              y = 1200;
            }
          ];
        };
      });
      nixosConfigurations.laptop2Presentation = nixpkgs.lib.nixosSystem (genSystem {
        hostname = "laptop2";
        device = {
          type = "laptop";
          emacsScale = 1;
          scale = 1;
          presentation = true;
          monitors = [
            {
              x = 1920;
              y = 1200;
            }
          ];
        };
      });
      nixosConfigurations.laptop = nixpkgs.lib.nixosSystem (genSystem {
        hostname = "laptop";
        device = {
          type = "laptop";
          emacsScale = 1;
          scale = 1;
          presentation = false;
          monitors = [
            {
              x = 1920;
              y = 1080;
            }
          ];
        };
      });
      nixosConfigurations.laptopPresentation = nixpkgs.lib.nixosSystem (genSystem {
        hostname = "laptop";
        device = {
          type = "laptop";
          emacsScale = 1;
          scale = 1;
          presentation = true;
          monitors = [
            {
              x = 1920;
              y = 1080;
            }
          ];
        };
      });
      nixosConfigurations.main = nixpkgs.lib.nixosSystem (genSystem {
        hostname = "main";
        device = {
          type = "desktop";
          emacsScale = 1;
          scale = 1;
          presentation = false;
          monitors = [
            {
              x = 1920;
              y = 1080;
            }
          ];
        };
      });
      nixosConfigurations.work = nixpkgs.lib.nixosSystem (genSystem {
        hostname = "work";
        device = {
          type = "desktop";
          emacsScale = 1;
          scale = 1.5;
          presentation = false;
          monitors = [
            {
              x = 3840;
              y = 2160;
            }
            {
              x = 3840;
              y = 2160;
            }
          ];
        };
      });
      nixosConfigurations.workPresentation = nixpkgs.lib.nixosSystem (genSystem {
        hostname = "work";
        device = {
          type = "desktop";
          emacsScale = 1;
          scale = 1.5;
          presentation = true;
          monitors = [
            {
              x = 3840;
              y = 2160;
            }
            {
              x = 3840;
              y = 2160;
            }
          ];
        };
      });
      nixosConfigurations.server-main = nixpkgs.lib.nixosSystem (genSystem {
        hostname = "server-main";
        device.type = "server";
      });
      nixosConfigurations.server-network = nixpkgs.lib.nixosSystem (genSystem {
        hostname = "server-network";
        device.type = "server";
      });
      nixosConfigurations.server-media = nixpkgs.lib.nixosSystem (genSystem {
        hostname = "server-media";
        device.type = "server";
      });
      nixosConfigurations.build-qcow2 = nixpkgs.lib.nixosSystem (genImage {
        hostname = "PLACEHOLDER";
        device.type = "server";
      });
    };
}
