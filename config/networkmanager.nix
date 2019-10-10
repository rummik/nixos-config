{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    openvpn
    dnsmasq
    networkmanager_openvpn
  ];

  services.hostapd.enable = true;

  networking.networkmanager = {
    enable = true;
    packages = with pkgs; [ networkmanager_openvpn ];

    unmanaged = [
      "interface-name:veth*"
    ];
  };
}
