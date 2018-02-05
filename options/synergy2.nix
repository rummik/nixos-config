{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.synergy2;
  pkg = (callPackage ../pkgs/synergy2/default.nix);
in
  {
    options = {
      services.synergy2 = {
        enable = mkOption {
          default = false;
          description = "
            Whether to enable the Synergy client (receive keyboard and mouse events from a Synergy server).
          ";
        };
        screenName = mkOption {
          default = "";
          description = ''
            Use the given name instead of the hostname to identify
            ourselves to the server.
          '';
        };
        serverAddress = mkOption {
          description = ''
            The server address is of the form: [hostname][:port].  The
            hostname must be the address or hostname of the server.  The
            port overrides the default port, 24800.
          '';
        };
        autoStart = mkOption {
          default = true;
          type = types.bool;
          description = "Whether the Synergy client should be started automatically.";
        };
      };
    };

    config = mkIf cfg.enable {
      systemd.services."synergy2" = {
        after = [ "network.target" ];
        description = "Synergy 2";
        wantedBy = optional cfg.autoStart "multi-user.target";
        path = [ pkg ];

        serviceConfig.ExecStart = ''
          ${pkgs.synergy2}/bin/synergyc -f ${optionalString (cfg.screenName != "") "-n ${cfg.screenName}"} ${cfg.serverAddress}
        '';

        serviceConfig.Restart = "on-failure";
      };
    };
  }
