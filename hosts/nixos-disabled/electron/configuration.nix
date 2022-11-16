{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ../../config/docker.nix
    ../../config/networkmanager.nix
    ../../config/sc-controller.nix
    #../../config/virtualbox.nix
    ../../config/wireshark.nix
    ../../profiles/games.nix
    ../../profiles/haskell.nix
    ../../profiles/workstation.nix
  ];

  environment.variables.themePrimaryColor = "cyan";

  boot.kernelPackages = pkgs.linuxPackages_5_2;

  networking.firewall.allowedTCPPortRanges = [
    {
      from = 4100;
      to = 4105;
    }
  ];

  networking.firewall.allowedUDPPorts = [
    5353
  ];

  networking.firewall.allowedTCPPorts = [
    3000
    4000
    5000
    9001
    1337
  ];

  environment.systemPackages = with pkgs; [
    parted
  ];

  services.openssh = {
    enable = true;
    passwordAuthentication = false;
  };

  networking.networkmanager.dispatcherScripts = [
    {
      type = "basic";

      source =
        pkgs.writeText "disable-wireless-when-wired"
        /*
        sh
        */
        ''
          IFACE=$1
          ACTION=$2
          nmcli=${pkgs.networkmanager}/bin/nmcli

          case ''${IFACE} in
              eth*|en*)
                  case ''${ACTION} in
                      up)
                          logger "disabling wifi radio"
                          $nmcli radio wifi off
                          ;;
                      down)
                          logger "enabling wifi radio"
                          $nmcli radio wifi on
                          ;;
                  esac
                  ;;
          esac
        '';
    }
  ];
}
