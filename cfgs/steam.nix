{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    steam
  ];

  hardware.pulseaudio.support32Bit = true;

  # Required for Steam.
  hardware.opengl = {
    driSupport = true;
    driSupport32Bit = true;
  };

  services.udev.extraRules = ''
    SUBSYSTEM=="usb", ATTRS{idVendor}=="28de", MODE="0666"
    KERNEL=="uinput", MODE="0660", GROUP="wheel", OPTIONS+="static_node=uinput"
  '';

  networking.firewall = {
    allowedTCPPorts = [ 27036 27037 ];
    allowedUDPPorts = [ 27031 27036 ];
  };
}
