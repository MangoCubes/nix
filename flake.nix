{
  nixConfig = {
    substituters = [
      "https://nix-community.cachix.org"
      "https://cache.nixos.org/"
      "https://hyprland.cachix.org"
    ];
    trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
    ];
  };
  inputs = {
    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim";
      # If using a stable channel you can use `url = "github:nix-community/nixvim/nixos-<version>"`
      inputs.nixpkgs.follows = "unstablePkg";
    };
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    unstablePkg.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "unstablePkg";
    };
    ags.url = "github:aylur/ags";
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
    in
    # unfree = import nixpkgs {
    #   inherit system;
    #   config.allowUnfree = true;
    # };
    let
      sysBase =
        { hostname, headless }:
        {
          # This particular line is equivalent to system = "x86_64-linux"
          inherit system;
          # This adds additional arguments to configuration.nix and other stuffs
          # Unstable packages can be accessed through 'unstable' and 'unfreeUnstable' argument
          specialArgs = {
            inherit
              inputs
              unstable
              unfreeUnstable
              hostname
              headless
              ;
            username = "main";
          };
        };
      baseModules =
        {
          hostname,
          headless,
          presentation ? false,
          # presentation,
          # isLaptop,
          scale ? 1,
          monitors ? 1,
          emacsScale ? 1,
        }:
        [
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
                  headless
                  scale
                  monitors
                  presentation
                  system
                  emacsScale
                  ;
                username = "main";
              };
            };
          }
          sops-nix.nixosModules.sops
          #  (
          #    { config, lib, ... }:
          #    {
          #      options = {
          #        domains = lib.mkOption {
          #          type = (with lib.types; listOf (submodule {
          #            options = {
          #              scope = (mkOption {
          #                type = (enum ["device" "global"]);
          #              });
          #              name = (mkOption {
          #                type = str;
          #              });
          #            };
          #          }));
          #          default = [];
          #        };
          #      };
          #    }
          #  )
        ];
    in
    let
      genHome =
        {
          hostname,
        }:
        {
          modules = [
            ./desktop/${hostname}/home.nix
          ];
        };
      genDesktop =
        {
          hostname,
          presentation,
          monitors ? 1,
          scale ? 1,
          emacsScale ? 1,
        }:
        (sysBase {
          inherit hostname;
          headless = false;
        })
        // {
          modules =
            [
              ./desktop/base/configuration.nix
              # This includes per-machine config based on the flake name
              ./desktop/${hostname}/configuration.nix
            ]
            ++ (baseModules {
              inherit
                hostname
                scale
                monitors
                presentation
                emacsScale
                ;
              headless = false;
            });
        };
      genServer =
        { hostname }:
        (sysBase {
          inherit hostname;
          headless = true;
        })
        // {
          modules =
            [
              ./server/base/configuration.nix
              # This includes per-machine config based on the flake name
              ./server/${hostname}/configuration.nix
            ]
            ++ (baseModules {
              inherit hostname;
              headless = true;
            });
        };
      genImage =
        { hostname, headless }:
        (sysBase { inherit hostname headless; })
        // {
          modules = [
            ./server/image/qcow.nix
            ./server/base/configuration.nix
            # This includes per-machine config based on the flake name
            ./server/${hostname}/configuration.nix
          ] ++ (baseModules { inherit hostname headless; });
        };
    in
    {
      # Generate config for each machine I have
      homeConfigurations.portable = inputs.home-manager.lib.homeManagerConfiguration (
        ({
          pkgs = unstable;
        })
        // (genHome {
          hostname = "portable";
        })
      );
      # nixosConfigurations.laptop2 = nixpkgs.lib.nixosSystem ({
      #   modules = [
      #
      #     ./common/environment.nix
      #     ./common/networking.nix
      #     ./common/security.nix
      #     ./common/time.nix
      #     ./common/users.nix
      #
      #     ./desktop/laptop2/configuration.nix
      #     ./desktop/base/networking.nix
      #     ./desktop/base/home.nix
      #     ./desktop/base/boot.nix
      #   ];
      # });
      nixosConfigurations.laptop2 = nixpkgs.lib.nixosSystem (genDesktop {
        hostname = "laptop2";
        presentation = false;
      });
      nixosConfigurations.laptop2Presentation = nixpkgs.lib.nixosSystem (genDesktop {
        hostname = "laptop2";
        presentation = true;
      });
      nixosConfigurations.laptop = nixpkgs.lib.nixosSystem (genDesktop {
        hostname = "laptop";
        presentation = false;
      });
      nixosConfigurations.laptopPresentation = nixpkgs.lib.nixosSystem (genDesktop {
        hostname = "laptop";
        presentation = true;
      });
      nixosConfigurations.main = nixpkgs.lib.nixosSystem (genDesktop {
        hostname = "main";
        presentation = false;
      });
      nixosConfigurations.work = nixpkgs.lib.nixosSystem (genDesktop {
        emacsScale = 2;
        hostname = "work";
        presentation = false;
        monitors = 2;
        scale = 2;
      });
      nixosConfigurations.workPresentation = nixpkgs.lib.nixosSystem (genDesktop {
        emacsScale = 2;
        hostname = "work";
        presentation = true;
        monitors = 2;
        scale = 2;
      });
      nixosConfigurations.server-main = nixpkgs.lib.nixosSystem (genServer {
        hostname = "server-main";
      });
      nixosConfigurations.server-network = nixpkgs.lib.nixosSystem (genServer {
        hostname = "server-network";
      });
      nixosConfigurations.server-media = nixpkgs.lib.nixosSystem (genServer {
        hostname = "server-media";
      });
      nixosConfigurations.build-qcow2 = nixpkgs.lib.nixosSystem (genImage {
        hostname = "PLACEHOLDER";
        headless = true;
      });
    };
}
