{
  nixConfig = {
    substituters = [
      "https://nix-community.cachix.org"
      "https://cache.nixos.org/"
    ];
    trusted-substituters = [ ];
    trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    ];
  };
  inputs = {
    mikuboot.url = "gitlab:evysgarden/mikuboot";
    nixvim = {
      url = "github:nix-community/nixvim";
      # If using a stable channel you can use `url = "github:nix-community/nixvim/nixos-<version>"`
      inputs.nixpkgs.follows = "unstablePkg";
    };
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    unstablePkg.url = "github:nixos/nixpkgs/nixos-unstable";
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
    winapps = {
      url = "github:winapps-org/winapps";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-alien.url = "github:thiagokokada/nix-alien";
    secrets = {
      url = "path:/home/main/Sync/NixConfig/secrets";
      # flake = false;
      # inputs
    };
  };

  # This @ sign binds inputs to the value that comes after it
  # let inputs = { self, nixpkgs, home-manager, unstable, ... }; in
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
      colours = {
        primary = "#47c8c0";
        lightBg = "#5a676b";
        highlight = "#ff629d";
        darkBg = "#24292b";
      };
    in
    let
      # Define unstable packages
      unstable = import unstablePkg { inherit system; };
      # I can only download unfree via this argument
      unfreeUnstable = import unstablePkg {
        inherit system;
        config.allowUnfree = true;
      };
      unfree = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      pkgs = import nixpkgs {
        inherit system;
      };
      username = "main";
      homeDir = "/home/${username}";
    in
    let
      # This sets the base system arguments
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
            # This includes home manager module
            # This is not a function
            (home-manager.nixosModules.home-manager)
            {
              home-manager = {
                backupFileExtension = "backup";
                # Home manager function has a special argument "unstable", which allows me to access unstable repo
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
            sops-nix.nixosModules.sops
          ] ++ extraModules;
        };
    in
    let
      # genHome =
      #   {
      #     hostname,
      #   }:
      #   {
      #     modules = [
      #       ./desktop/${hostname}/home.nix
      #     ];
      #   };
      genSystem =
        {
          hostname,
          device,
        }:
        let
          extraOptions = (
            { config, lib, ... }:
            {
              options = {
                custom = lib.mkOption {
                  type = lib.types.submodule {
                    options = {
                      networking = lib.mkOption {
                        type = lib.types.submodule {
                          options = {
                            primary = lib.mkOption {
                              type = lib.types.str;
                              default = "";
                            };
                            secondary = lib.mkOption {
                              type = lib.types.str;
                            };
                          };
                        };
                        default = {
                          primary = "";
                        };
                      };
                      features = lib.mkOption {
                        type = lib.types.submodule {
                          options = {
                            tablet = lib.mkOption {
                              type = lib.types.bool;
                              default = false;
                            };
                          };
                        };
                        default = {
                          tablet = false;
                        };
                      };
                    };
                  };
                  default = {
                    features.tablet = false;
                  };
                };
              };
            }
          );
        in
        (sysBase {
          inherit hostname device;
          extraModules = (
            if device.type == "desktop" || device.type == "laptop" then
              [
                ./desktop/base/configuration.nix
                # This includes per-machine config based on the flake name
                ./desktop/${hostname}/configuration.nix
                extraOptions
              ]
            else if device.type == "server" then
              [
                ./server/base/configuration.nix
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
      devShell.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.mkShell {
        packages = [ pkgs.bash ];
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
          scale = 2;
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
          scale = 2;
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
