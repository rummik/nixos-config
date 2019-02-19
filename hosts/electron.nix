{ config, pkgs, ... }:

{
  imports = [
    ../cfgs/networkmanager.nix
    ../cfgs/sc-controller.nix
    ../cfgs/virtualbox.nix
    ../cfgs/wireshark.nix
    ../hardware-configuration.nix
    ../presets/common.nix
    ../presets/games.nix
    ../presets/haskell.nix
    ../presets/thinkpad.nix
    ../presets/workstation.nix
  ];

  networking.hostName = "electron";

  programs.tmux.theme.secondaryColor = "cyan";

  networking.firewall.allowedTCPPortRanges = [
    { from = 4100; to = 4105; }
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

  networking.networkmanager.dispatcherScripts = [{
    type = "basic";

    source = pkgs.writeText "disable-wireless-when-wired" ''
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
  }];
}
