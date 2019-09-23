{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.mailspring;

in

{
  options = {
    services.mailspring = {

      enable = mkEnableOption ''
        mailspring - Open-source mail client built on the modern web with Electron, React, and Flux
      '';

      gnome3-keyring = mkOption {
        type = types.bool;
        default = true;
        description = "Enable gnome3 keyring for mailspring.";
      };
    };
  };


  config = mkIf cfg.enable {

    environment.systemPackages = [ pkgs.mailspring ];

    services.gnome3.gnome-keyring = mkIf cfg.gnome3-keyring {
      enable = true;
    };

  };
}
