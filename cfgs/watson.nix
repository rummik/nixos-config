{ config, pkgs, lib, ft, ... }:

{
  environment.systemPackages = with pkgs; [ watson ];

  nixpkgs.config.packageOverrides = pkgs: {
    watson = pkgs.watson.overrideAttrs(old: rec {
      installPhase = old.installPhase + ''${ft.sh}
        mkdir -p $out/share/zsh/site-functions/
        cp watson.zsh-completion $out/share/zsh/site-functions/_watson
      '';
    });
  };
}
