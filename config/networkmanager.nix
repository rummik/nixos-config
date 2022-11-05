{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    openvpn
    dnsmasq
    networkmanager-openvpn
  ];

  services.hostapd.enable = true;

  networking.networkmanager = {
    enable = true;
    plugins = with pkgs; [ networkmanager-openvpn ];

    unmanaged = [
      "interface-name:veth*"
    ];
  };
}
