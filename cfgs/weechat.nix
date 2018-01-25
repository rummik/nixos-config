{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    weechat
  ];

  nixpkgs.config.packageOverrides = pkgs: {
    weechat = pkgs.weechat.overrideAttrs (oldAttrs: rec {
      version = "2.0.1";
      name = "weechat-${version}";

      src = pkgs.fetchurl {
        url = "http://weechat.org/files/src/weechat-${version}.tar.bz2";
        sha256 = "0jvvlyz1hnf8kqargvvq253vh6vispqq0hsm203agclwzil34ps2";
      };
    });
  };

  environment.etc."weechat.conf".text = ''
  '';
} 
