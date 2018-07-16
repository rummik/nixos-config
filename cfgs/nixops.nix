#{ config, pkgs, ... }:
#
#{
#  environment.systemPackages = with pkgs; [ nixops ];
#
#  nixpkgs.config.packageOverrides = pkgs: {
#    nixops =
#      pkgs.nixops.overrideAttrs (oldAttrs: rec {
#        version = "1.6-unstable";
#        name = "nixops-${version}";
#        ref = "ceaafbd9b725f4f0c51d85f0f086380069560bb2";
#
#        src = pkgs.fetchurl {
#          url = "https://github.com/NixOS/nixops/archive/${ref}.tar.gz";
#          sha256 = "1accfspp0cnvaw313y4iic007z8hfjya1krq19k4irhx1ib5v5cz";
#        };
#      });
#  };
#} 


{ config, pkgs, ... }:

let
  ref = "ceaafbd9b725f4f0c51d85f0f086380069560bb2";
in
  {
    environment.systemPackages = [
      (pkgs.callPackage <nixpkgs/pkgs/tools/package-management/nixops/generic.nix> (rec {
        version = "1.6-unstable";

        src = pkgs.fetchurl {
          url = "https://github.com/NixOS/nixops/archive/${ref}.tar.gz";
          sha256 = "1accfspp0cnvaw313y4iic007z8hfjya1krq19k4irhx1ib5v5cz";
        };
      }))
    ];
  }
