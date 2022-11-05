{ config, lib, ... }:

let

  inherit (import ./path.nix) __nixPath nixPath;
  
  inherit (builtins) currentSystem;
  inherit (lib) mkForce;
  inherit (lib.systems.elaborate { system = currentSystem; }) isLinux isDarwin;

  nixpkgs = {
    overlays = import <nixpkgs-overlays>;
    config.allowUnfree = true;
  };

  pkgsConf = {
    inherit (config.nixpkgs) localSystem crossSystem;
    overlays = config.nixpkgs.overlays ++ nixpkgs.overlays;
    config = config.nixpkgs.config // nixpkgs.config;
  };

  pkgs = import <nixpkgs> (
    if isLinux then {
      inherit (pkgsConf) overlays config localSystem crossSystem;
    } else {
      inherit (pkgsConf) overlays config;
    }
  );

  pkgs-unstable = import <nixpkgs-unstable> (
    let overlays = pkgsConf.overlays ++ (import <nixpkgs-unstable-overlays>); in
    if isLinux then {
      inherit (pkgsConf) config localSystem crossSystem;
      inherit overlays;
    } else {
      inherit (pkgsConf) config;
      inherit overlays;
    }
  );

in

rec {
  inherit nixpkgs;

  nix = {
    nixPath = mkForce nixPath;
    #package = pkgs.nixUnstable;
    extraOptions = /* ini */ ''
      experimental-features = nix-command flakes
    '';
  };

  _module.args = {
    #inherit pkgs pkgs-unstable;
    inherit pkgs-unstable;
    nur = pkgs.nur;
  };
}

