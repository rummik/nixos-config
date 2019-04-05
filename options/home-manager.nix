{ lib, ... }:

let
  inherit (lib) optional optionalAttrs;
  inherit (lib.systems.elaborate { system = __currentSystem; }) isLinux isDarwin;

  home-manager = 
    let ref = "995fa3af"; in fetchTarball {
      url = "https://github.com/rycee/home-manager/archive/${ref}.tar.gz";
      sha256 = "0b7aa863hjl60ccg61750i9qgzbgh1p5a8rcdbn54lz5d5r0r252";
    };
in
  optionalAttrs isDarwin {
    imports = [ "${home-manager}/nix-darwin" ];
  }

  // optionalAttrs isLinux {
    imports = [ "${home-manager}/nixos" ];
    home-manager.useUserPackages = true;
  }
