{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ weechat ];

  nixpkgs.config.packageOverrides = pkgs: {
    weechat = (pkgs.weechat.override {
        configure = { availablePlugins, ... }: {
          plugins = with availablePlugins; [
            perl tcl ruby guile lua

            (python.withPackages (ps: with ps; [
              websocket_client
              dbus-python
            ]))
          ];
        };
      });
  };
} 
