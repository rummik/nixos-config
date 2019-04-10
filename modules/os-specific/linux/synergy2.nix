{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.synergy2;
  pkg = pkgs.synergy2;
in
  {
    options = {
      services.synergy2 = {
        enable = mkOption {
          default = false;
          description = "
            Whether to enable the Synergy2 service. 
          ";
        };
      };
    };

    config = mkIf cfg.enable {
      systemd.services."synergy2" = {
        after = [ "network.target" ];
        description = "Synergy 2 service";
        wantedBy = [ "multi-user.target" ];
        path = [ pkg ];

        serviceConfig.User = "rummik";
        serviceConfig.ExecStart = "${pkg}/bin/synergy-service";
        serviceConfig.Restart = "always";
      };
    };
  }
