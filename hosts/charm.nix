{ config, pkgs, ... }:

{
  imports = [
    <nixpkgs/nixos/modules/profiles/qemu-guest.nix>
    ../misc/general.nix
    ../misc/server.nix
  ];

  boot.loader.grub.device = "/dev/vda";
  fileSystems."/" = { device = "/dev/vda1"; fsType = "ext4"; };

  programs.tmux.theme.secondaryColor = "magenta";

  services.udev.extraRules = ''
    ATTR{address}=="82:dc:8e:11:53:9c", NAME="eth0"
  '';

  networking = {
    hostName = "charm";

    nameservers = [
      "8.8.8.8"
      "8.8.4.4"
    ];

    defaultGateway = "104.131.128.1";
    defaultGateway6 = "";

    interfaces = {
      eth0 = {
        ip4 = [
          { address = "104.131.133.191"; prefixLength = 20; }
          { address = "10.12.0.6"; prefixLength = 16; }
        ];

        ip6 = [
          { address = "fe80::80dc:8eff:fe11:539c"; prefixLength = 64; }
        ];
      };
    };
  };
}
