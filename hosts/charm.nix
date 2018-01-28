{ config, pkgs, ... }:

{
  imports = [
    <nixpkgs/nixos/modules/profiles/qemu-guest.nix>
    ../cfgs/bitlbee.nix
    ../cfgs/nginx.nix
    ../cfgs/nginx/rummik.com.nix
    ../cfgs/weechat.nix
    ../misc/common.nix
    ../misc/server.nix
  ];

  boot.loader.grub.device = "/dev/vda";
  fileSystems."/" = {
    device = "/dev/vda1";
    fsType = "ext4";
    options = [ "defaults" "acl" ];
  };

  programs.tmux.theme.secondaryColor = "magenta";

  services.udev.extraRules = ''
    ATTR{address}=="3e:18:30:44:0f:e2", NAME="eth0"
  '';

  networking = {
    hostName = "charm";

    nameservers = [
      "8.8.8.8"
      "8.8.4.4"
    ];

    defaultGateway = "198.199.104.1";
    defaultGateway6 = "2604:a880:1:20::1";

    interfaces = {
      eth0 = {
        ip4 = [
          { address = "198.199.104.142"; prefixLength = 20; }
        ];

        ip6 = [
          { address = "fe80::80dc:8eff:fe44:0fe2"; prefixLength = 64; }
          { address = "2604:a880:1:20::26c:d001"; prefixLength = 64; }
        ];
      };
    };
  };
}
