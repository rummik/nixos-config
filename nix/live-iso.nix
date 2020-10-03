{ config, pkgs, pkgs-unstable, lib, ... }:

let

  inherit (lib) mkForce substring;
  inherit (import ../channels) __nixPath nixPath;

in

{
  imports = [
    <nixpkgs/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix>

    ../modules
    ./nix-path.nix
    ../profiles/common.nix
    ../config/networkmanager.nix
  ];

  services.mingetty.autologinUser = mkForce "rummik";

  boot.kernelPackages = pkgs.linuxPackages_latest;

  hardware.firmware = with pkgs; [
    firmwareLinuxNonfree
  ];

  # Disable the builtin configuration cloning helper, since we'll do that ourselves
  installer.cloneConfig = false;

  # Include our configs and pinned channels
  # TODO: Use fetchgit + path to reduce the resulting image size and build times
  environment.etc = {
    nixos = {
      enable = true;
      source = builtins.path {
        name = "nixos-configuration";
        path = ../.;
        filter = path: type: path != ../result;
      };
    };
  };

  /*environment.etc =
    {
      nixos = {
        enable = true;
        source = builtins.path {
          name = "nixos-configuration";
          path = ../.;
        };

        #source = fetchGit ../.;
      };
    };

    //

    (
      mapAttrs (name: v: {
        enable = true;
        source = fetchGit (../channels + "/${name}");
        target = "nixos/channels/${name}";
      })

      (filterAttrs (n: v: v == "directory" && pathExists (../channels + "/${n}/.git")) (readDir ../channels))
    );*/

  # Force disabling networking.wireless, since otherwise the iso builder will
  # create a conflict with our networkmanager config
  networking.wireless.enable = mkForce false;

  isoImage = {
    isoBaseName = "rmk-nixos";
    volumeID = mkForce (substring 0 11 "RMK_ISO");
  };
}
