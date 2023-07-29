{
  description = "A highly structured configuration database.";

  nixConfig.extra-experimental-features = "nix-command flakes";
  nixConfig.extra-substituters = "https://nrdxp.cachix.org https://nix-community.cachix.org";
  nixConfig.extra-trusted-public-keys = "nrdxp.cachix.org-1:Fc5PSqY2Jm1TrWfm88l6cvGWwz3s93c6IOifQWnhNW4= nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=";

  inputs = {
    flake-compat.url = "github:edolstra/flake-compat";
    flake-compat.flake = false;

    nix.url = "github:nixos/nix/2.17.0";
    nix.inputs.nixpkgs.follows = "nixos";

    # Track channels with commits tested and built by hydra
    nixos.url = "github:nixos/nixpkgs/nixos-23.05";

    latest.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-darwin-stable.url = "github:NixOS/nixpkgs/nixpkgs-23.05-darwin";

    # Cheap instantiation of just the NixPkgs lib
    nixlib.url = "github:nix-community/nixpkgs.lib";

    # Filesystem-based module system for Nix
    haumea.url = "github:nix-community/haumea/v0.2.2";
    haumea.inputs.nixpkgs.follows = "nixlib";

    flake-parts.url = "github:hercules-ci/flake-parts";

    # Deprecated.  Moving to flake.parts and/or haumea
    digga.url = "github:divnix/digga";
    digga.inputs.nixpkgs.follows = "nixos";
    digga.inputs.nixlib.follows = "nixos";
    digga.inputs.home-manager.follows = "home";
    digga.inputs.deploy.follows = "deploy";
    digga.inputs.flake-utils-plus.follows = "flake-utils-plus";

    flake-utils-plus.url = "github:ravensiris/flake-utils-plus/ravensiris/fix-devshell-legacy-packages";

    # Home Manager
    home.url = "github:nix-community/home-manager/release-23.05";
    home.inputs.nixpkgs.follows = "nixlib";

    # Nix-Darwin
    darwin.url = "github:LnL7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs-darwin-stable";

    deploy.url = "github:serokell/deploy-rs";
    deploy.inputs.nixpkgs.follows = "nixos";

    # Support for age-encrypted secrets
    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixlib";
    agenix.inputs.home-manager.follows = "home";

    # Local package updater
    nvfetcher.url = "github:berberman/nvfetcher";
    nvfetcher.inputs.nixpkgs.follows = "nixlib";

    # naersk.url = "github:nmattia/naersk";
    # naersk.inputs.nixpkgs.follows = "nixos";

    nixos-hardware.url = "github:nixos/nixos-hardware";

    nixos-generators.url = "github:nix-community/nixos-generators";

    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixos";

    nil.url = "github:oxalica/nil/59bcad0b13b5d77668c0c125fef71d7b41406d7a";
    nil.inputs.nixpkgs.follows = "nixos";

    # fork of github:kamadorueda/alejandra with container padding
    alejandra.url = "github:rummik/alejandra/pad-non-empty-containers";
    alejandra.inputs.nixpkgs.follows = "nixos";

    # nix-colors.url = "github:misterio77/nix-colors";

    nixvim.url = "github:nix-community/nixvim";
    nixvim.inputs.nixpkgs.follows = "nixos";

    # neovim-flake.url = "github:neovim/neovim?dir=contrib";
    # neovim-flake.inputs.nixpkgs.follows = "nixos";

    nix-alien.url = "github:thiagokokada/nix-alien";
    nix-alien.inputs.nixpkgs.follows = "nixos";

    nix-ld.url = "github:Mic92/nix-ld";
    nix-ld.inputs.nixpkgs.follows = "nixos";

    # Plasma configuration manager
    plasma-manager.url = "github:pjones/plasma-manager";
    plasma-manager.inputs.nixpkgs.follows = "nixos";
    plasma-manager.inputs.home-manager.follows = "home";
  };

  outputs = {
    self,
    nix,
    digga,
    haumea,
    nixos,
    home,
    nixos-hardware,
    nur,
    agenix,
    nvfetcher,
    deploy,
    nixpkgs,
    alejandra,
    nil,
    nix-alien,
    plasma-manager,
    ...
  } @ inputs:
    digga.lib.mkFlake
    {
      inherit self;

      # omit rust-overlay from nixpkgs inputs...
      inputs = builtins.removeAttrs inputs [ "nil" "rust-overlay" ];

      channelsConfig = { allowUnfree = true; };

      channels = {
        nixos = {
          imports = [ (digga.lib.importOverlays ./overlays) ];
          overlays = [];
        };
        nixpkgs-darwin-stable = {
          imports = [ (digga.lib.importOverlays ./overlays) ];
          overlays = [
            # TODO: restructure overlays directory for per-channel overrides
            # `importOverlays` will import everything under the path given
            (channels: final: prev: {
              inherit (channels.latest) mas;
            })
          ];
        };
        latest = {
          overlays = [ nil.overlays.nil ];
        };
      };

      lib = import ./lib { lib = digga.lib // nixos.lib; };

      sharedOverlays = [
        (final: prev: {
          __dontExport = true;
          lib = prev.lib.extend (lfinal: lprev: {
            our = self.lib;
          });
        })

        nix.overlays.default
        nur.overlay
        alejandra.overlay
        agenix.overlays.default
        nvfetcher.overlays.default
        nix-alien.overlays.default

        (import ./pkgs)
      ];

      nixos = {
        hostDefaults = {
          system = "x86_64-linux";
          channelName = "nixos";
          imports = [ (digga.lib.importExportableModules ./modules) ];
          modules = [
            { lib.our = self.lib; }
            digga.nixosModules.bootstrapIso
            digga.nixosModules.nixConfig
            home.nixosModules.home-manager
            agenix.nixosModules.age
            inputs.nix-ld.nixosModules.nix-ld
            { system.stateVersion = "21.05"; }
          ];
        };

        imports = [ (digga.lib.importHosts ./hosts/nixos) ];
        hosts = {
          # set host-specific properties here
          NixOS = {};
        };
        importables = rec {
          profiles =
            digga.lib.rakeLeaves ./profiles
            // {
              users = digga.lib.rakeLeaves ./users;
            };
          suites = with profiles; {
            base = [ hosts core.nixos users.rummik users.root ];
            graphical = [ graphical games ];
          };
        };
      };

      darwin = {
        hostDefaults = {
          system = "x86_64-darwin";
          channelName = "nixpkgs-darwin-stable";
          imports = [ (digga.lib.importExportableModules ./modules) ];
          modules = [
            { lib.our = self.lib; }
            digga.darwinModules.nixConfig
            home.darwinModules.home-manager
            agenix.nixosModules.age
          ];
        };

        imports = [ (digga.lib.importHosts ./hosts/darwin) ];
        hosts = {
          # set host-specific properties here
          Mac = {};
        };
        importables = rec {
          profiles =
            digga.lib.rakeLeaves ./profiles
            // {
              users = digga.lib.rakeLeaves ./users;
            };
          suites = with profiles; {
            base = [ core.darwin users.darwin ];
          };
        };
      };

      home = {
        imports = [ (digga.lib.importExportableModules ./users/modules) ];

        modules = [
          inputs.nixvim.homeManagerModules.nixvim
          # todo: only enable this on linux
          plasma-manager.homeManagerModules.plasma-manager
          # nix-colors.homeManagerModule
          { home.stateVersion = "21.05"; }
        ];

        importables = rec {
          profiles = digga.lib.rakeLeaves ./users/profiles;
          suites = with profiles; rec {
            base = [
              xdg
              direnv
              fzf
              git
              htop
              ssh
              tmux
              shells.zsh
              shells.starship
              shells.fish
              neovim
              watson
            ];

            graphical = [ alacritty firefox kitty obs-studio vscode wallpaper ];

            neovim = with profiles.nixvim; [
              conf
              lang.cxx
              # lang.dart
              lang.go
              lang.nix
              lang.python
              lang.web
            ];

            plasma-desktop = with plasma; [ bismuth ];
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
          nixos = { suites, ... }: { imports = suites.base; };
          darwin = { suites, ... }: { imports = suites.base; };
          root = { profiles, ... }: { imports = [ profiles.nixvim.conf profiles.nixvim.lang.nix ]; };
          rummik = {
            suites,
            profiles,
            hostName,
            ...
          }: {
            imports = suites.base ++ suites.graphical ++ [ profiles.git-users.rummik ];
          };
        }; # digga.lib.importers.rakeLeaves ./users/hm;
      };

      devshell = ./shell;

      # TODO: similar to the above note: does it make sense to make all of
      # these users available on all systems?
      homeConfigurations = builtins.foldl' digga.lib.mergeAny {} [
        # (builtins.mapAttrs (_: config: home.lib.homeManagerConfiguration config) home.users)
        (digga.lib.mkHomeConfigurations self.darwinConfigurations)
        (digga.lib.mkHomeConfigurations self.nixosConfigurations)
      ];

      deploy.nodes = digga.lib.mkDeployNodes self.nixosConfigurations {
        photon = {
          # fastConnection = true;
          magicRollback = false;
          autoRollback = false;
          # remoteBuild = true;
        };
        # photon = {
        #   hostname = "photon.astorisk.home.arpa";
        #   profilesOrder = [ "system" "rummik" ];
        #   profiles.system.sshUser = "root";
        #   profiles.rummik = {
        #     user = "rummik";
        #     sshUser = "rummik";
        #     path = deploy.lib.x86_64-linux.activate.home-manager self.homeConfigurationsPortable.x86_64-linux.rummik;
        #   };
        # };
      };

      outputsBuilder = channels: { formatter = channels.latest.treefmt; };
    };
}
