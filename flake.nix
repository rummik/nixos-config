{
  description = "A highly structured configuration database.";

  nixConfig.extra-experimental-features = "nix-command flakes";
  nixConfig.extra-substituters = "https://nrdxp.cachix.org https://nix-community.cachix.org";
  nixConfig.extra-trusted-public-keys = "nrdxp.cachix.org-1:Fc5PSqY2Jm1TrWfm88l6cvGWwz3s93c6IOifQWnhNW4= nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=";

  inputs = {
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };

    # Track channels with commits tested and built by hydra
    nixos.url = "github:nixos/nixpkgs/nixos-22.11";
    latest.url = "github:nixos/nixpkgs/nixos-unstable";
    # For darwin hosts: it can be helpful to track this darwin-specific stable
    # channel equivalent to the `nixos-*` channels for NixOS. For one, these
    # channels are more likely to provide cached binaries for darwin systems.
    # But, perhaps even more usefully, it provides a place for adding
    # darwin-specific overlays and packages which could otherwise cause build
    # failures on Linux systems.
    nixpkgs-darwin-stable.url = "github:NixOS/nixpkgs/nixpkgs-22.11-darwin";

    digga.url = "github:divnix/digga";
    digga.inputs.nixpkgs.follows = "nixos";
    digga.inputs.nixlib.follows = "nixos";
    digga.inputs.home-manager.follows = "home";
    digga.inputs.deploy.follows = "deploy";

    home.url = "github:nix-community/home-manager/release-22.11";
    home.inputs.nixpkgs.follows = "nixos";

    darwin.url = "github:LnL7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs-darwin-stable";

    deploy.url = "github:serokell/deploy-rs";
    deploy.inputs.nixpkgs.follows = "nixos";

    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixos";

    nvfetcher.url = "github:berberman/nvfetcher";
    nvfetcher.inputs.nixpkgs.follows = "nixos";

    naersk.url = "github:nmattia/naersk";
    naersk.inputs.nixpkgs.follows = "nixos";

    nixos-hardware.url = "github:nixos/nixos-hardware";

    # Use a specific commit ref until nix-community/nixos-generators#184 is merged
    nixos-generators.url = "github:nix-community/nixos-generators?rev=e2f624e7c5a292bf4e04b34d628afa0a29a587a3";

    # nil.url = "github:oxalica/nil";

    # nix-colors.url = "github:misterio77/nix-colors";

    # neovim.url = "github:neovim/neovim/v0.8.1?dir=contrib";
    # neovim.inputs.nixpkgs.follows = "nixpkgs";
    # neovim.inputs.flake-utils.follows = "flake-utils";

    # Personal fork of github:pta2002/nixvim
    nixvim.url = "github:rummik/nixvim/rmk-patched";
    nixvim.inputs.nixpkgs.follows = "nixpkgs";
    # nixvim.inputs.flake-utils.follows = "flake-utils";
  };

  outputs = {
    self,
    digga,
    nixos,
    home,
    nixos-hardware,
    nur,
    agenix,
    nvfetcher,
    deploy,
    nixpkgs,
    nixvim,
    ...
  } @ inputs:
    digga.lib.mkFlake
    {
      inherit self inputs;

      channelsConfig = {allowUnfree = true;};

      channels = {
        nixos = {
          imports = [(digga.lib.importOverlays ./overlays)];
          overlays = [];
        };
        nixpkgs-darwin-stable = {
          imports = [(digga.lib.importOverlays ./overlays)];
          overlays = [
            # TODO: restructure overlays directory for per-channel overrides
            # `importOverlays` will import everything under the path given
            (channels: final: prev:
              {
                inherit (channels.latest) mas;
              }
              // prev.lib.optionalAttrs true {})
          ];
        };
        latest = {};
      };

      lib = import ./lib {lib = digga.lib // nixos.lib;};

      sharedOverlays = [
        (final: prev: {
          __dontExport = true;
          lib = prev.lib.extend (lfinal: lprev: {
            our = self.lib;
          });
        })

        nur.overlay
        agenix.overlay
        nvfetcher.overlay

        (import ./pkgs)
      ];

      nixos = {
        hostDefaults = {
          system = "x86_64-linux";
          channelName = "nixos";
          imports = [(digga.lib.importExportableModules ./modules)];
          modules = [
            {lib.our = self.lib;}
            digga.nixosModules.bootstrapIso
            digga.nixosModules.nixConfig
            home.nixosModules.home-manager
            agenix.nixosModules.age
            { system.stateVersion = "21.05"; }
          ];
        };

        imports = [(digga.lib.importHosts ./hosts/nixos)];
        hosts = {
          /*
          set host-specific properties here
          */
          NixOS = {};
        };
        importables = rec {
          profiles =
            digga.lib.rakeLeaves ./profiles
            // {
              users = digga.lib.rakeLeaves ./users;
            };
          suites = with profiles; {
            base = [hosts core.nixos users.rummik users.root];
            graphical = [graphical games];
          };
        };
      };

      darwin = {
        hostDefaults = {
          system = "x86_64-darwin";
          channelName = "nixpkgs-darwin-stable";
          imports = [(digga.lib.importExportableModules ./modules)];
          modules = [
            {lib.our = self.lib;}
            digga.darwinModules.nixConfig
            home.darwinModules.home-manager
            agenix.nixosModules.age
          ];
        };

        imports = [(digga.lib.importHosts ./hosts/darwin)];
        hosts = {
          /*
          set host-specific properties here
          */
          Mac = {};
        };
        importables = rec {
          profiles =
            digga.lib.rakeLeaves ./profiles
            // {
              users = digga.lib.rakeLeaves ./users;
            };
          suites = with profiles; {
            base = [core.darwin users.darwin];
          };
        };
      };

      home = {
        imports = [(digga.lib.importExportableModules ./users/modules)];
        modules = [
          nixvim.homeManagerModules.nixvim
          # nix-colors.homeManagerModule
          { home.stateVersion = "21.05"; }
        ];
        importables = rec {
          profiles = digga.lib.rakeLeaves ./users/profiles;
          suites = with profiles; let
            inherit (profiles) nixvim;
          in rec {
            base = [direnv fzf git htop ssh tmux zsh starship neovim];
            graphical = [alacritty firefox kitty obs-studio vscode wallpaper watson];
            neovim = [
              nixvim.conf
              nixvim.lang.cxx
              nixvim.lang.go
              nixvim.lang.nix
              nixvim.lang.python
              nixvim.lang.web
            ];
          };
        };
        users = {
          # TODO: does this naming convention still make sense with darwin support?
          #
          # - it doesn't make sense to make a 'nixos' user available on
          #   darwin, and vice versa
          #
          # - the 'nixos' user might have special significance as the default
          #   user for fresh systems
          #
          # - perhaps a system-agnostic home-manager user is more appropriate?
          #   something like 'primaryuser'?
          #
          # all that said, these only exist within the `hmUsers` attrset, so
          # it could just be left to the developer to determine what's
          # appropriate. after all, configuring these hm users is one of the
          # first steps in customizing the template.
          nixos = {suites, ...}: {imports = suites.base;};
          darwin = {suites, ...}: {imports = suites.base;};
          rummik = {
            suites,
            profiles,
            hostName,
            ...
          }: {
            imports = suites.base ++ suites.graphical ++ [profiles.git-users.rummik];
          };
        }; # digga.lib.importers.rakeLeaves ./users/hm;
      };

      devshell = ./shell;

      # TODO: similar to the above note: does it make sense to make all of
      # these users available on all systems?
      homeConfigurations =
        digga.lib.mergeAny
        (digga.lib.mkHomeConfigurations self.darwinConfigurations)
        (digga.lib.mkHomeConfigurations self.nixosConfigurations);

      deploy.nodes = digga.lib.mkDeployNodes self.nixosConfigurations {};

      outputsBuilder = channels: {formatter = channels.latest.treefmt;};
    };
}
