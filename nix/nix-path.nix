{ config, lib, ... }:

let

  inherit (import ../channels) __nixPath nixPath;
  inherit (builtins) currentSystem;
  inherit (lib) mkForce;
  inherit (lib.systems.elaborate { system = currentSystem; }) isLinux isDarwin;

in

{
  nixpkgs.overlays = import <nixpkgs-overlays>;

  nix.nixPath = mkForce nixPath;

  _module.args.pkgs = import <nixpkgs> (
    if isLinux then {
      inherit (config.nixpkgs) config overlays localSystem crossSystem;
    } else {
      inherit (config.nixpkgs) config overlays;
    }
  );

  _module.args.pkgs-unstable = import <nixpkgs-unstable> (
    if isLinux then {
      inherit (config.nixpkgs) config localSystem crossSystem;
    } else {
      inherit (config.nixpkgs) config;
    }
  );
}
