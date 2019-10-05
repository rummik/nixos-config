{config, pkgs, lib, ...}:

let

  inherit (lib) mkForce substring filterAttrs pathExists mapAttrs;
  inherit (builtins) readDir;
  inherit (import ../channels) __nixPath nixPath;

in

{
  imports = [
    <nixpkgs/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix>

    # Provide an initial copy of the NixOS channel so that the user
    # doesn't need to run "nix-channel --update" first.
    #<nixpkgs/nixos/modules/installer/cd-dvd/channel.nix>

    ../modules
    ./nix-path.nix
    ../profiles/common.nix
    ../config/networkmanager.nix
  ];


  installer.cloneConfig = false;

  environment.etc =
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

    /*//

    (
      mapAttrs (name: v: {
        enable = true;
        source = fetchGit (../channels + "/${name}");
        target = "nixos/channels/${name}";
      })

      (filterAttrs (n: v: v == "directory" && pathExists (../channels + "/${n}/.git")) (readDir ../channels))
    );*/


  # Force disabling networking.wireless, since networkmanager overrides it
  networking.wireless.enable = mkForce false;

  isoImage = {
    isoBaseName = "rmk-nixos";
    volumeID = mkForce (substring 0 11 "RMK_ISO");
  };
}
