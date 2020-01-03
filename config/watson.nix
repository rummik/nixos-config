{ config, pkgs, lib, ... }:

{
  environment.systemPackages = with pkgs; [ watson watson-zsh-completion ];

  nixpkgs.config.packageOverrides = pkgs: {
    watson-zsh-completion = pkgs.watson.overrideAttrs(old: rec {
      installPhase = /* sh */ ''
        mkdir -p $out/share/zsh/site-functions/
        cp watson.zsh-completion $out/share/zsh/site-functions/_watson
      '';
    });
  };
}
