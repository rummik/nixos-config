{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ weechat ];

  nixpkgs.config.packageOverrides = pkgs: {
    weechat = pkgs.weechat.overrideAttrs (oldAttrs: rec {
      version = "2.1";
      name = "weechat-${version}";

      src = pkgs.fetchurl {
        url = "http://weechat.org/files/src/weechat-${version}.tar.bz2";
        sha256 = "0fq68wgynv2c3319gmzi0lz4ln4yrrk755y5mbrlr7fc1sx7ffd8";
      };

      buildInputs = with pkgs; oldAttrs.buildInputs ++ [
        python27Packages.websocket_client
        python27Packages.dbus-python
      ];
    });
  };
} 
