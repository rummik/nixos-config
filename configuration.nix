{ config, lib, ... }:

let

  inherit (import ./channels) __nixPath;
  inherit (builtins) currentSystem pathExists;
  inherit (lib) maybeEnv fileContents flatten;
  inherit (lib.systems.elaborate { system = currentSystem; }) isLinux isDarwin;

  optionalPath = file: if (pathExists file) then [ file ] else [ ];

  hostName = maybeEnv "HOST" (fileContents (
    if !isDarwin then
      /etc/hostname
    else
      derivation {
        name = "hostname";
        system = currentSystem;
        builder = "/bin/sh";
        args = [ "-c" "/usr/sbin/scutil --get LocalHostName > $out" ];
      }
  ));

in

{
  networking.hostName = hostName;

  nixpkgs.overlays = [ (import <nixpkgs-overlays>) ];
  nixpkgs.pkgs = import <nixpkgs> {
    inherit (config.nixpkgs) config overlays localSystem crossSystem;
  };

  _module.args.ft = import <ft>;

  imports = flatten [
    ./modules
    ./profiles/common.nix
    (./. + "/hosts/${hostName}/configuration.nix")
    (optionalPath ./hardware-configuration.nix)
    (optionalPath (./. + "/hosts/${hostName}/hardware-configuration.nix"))
  ];
}
