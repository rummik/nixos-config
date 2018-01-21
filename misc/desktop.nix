{ config, pkgs, ... }:

{
  imports = [
    ../cfgs/chromium.nix
    ../cfgs/keybase.nix
    ../cfgs/networkmanager.nix
    ../cfgs/steam.nix
  ];

  environment.systemPackages = with pkgs; [
    vlc
    youtube-dl
    electrum

    redshift-plasma-applet

    partition-manager
    filelight

    kdeApplications.kdenlive
    frei0r
    ffmpeg
    gifsicle

    kdeFrameworks.kdesu

    p7zip
  ];

  hardware.bluetooth.enable = true;
  hardware.pulseaudio.enable = true;

  networking.firewall.enable = false;

  services.avahi.enable = true;
  services.geoclue2.enable = true;
  services.printing.enable = true;

  services.xserver = {
    enable = true;
    layout = "us";
    xkbOptions = "caps:swapescape";
    displayManager.sddm.enable = true;
    desktopManager.plasma5.enable = true;
  };

  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_interface", \
      ATTRS{idVendor}=="0403", ATTRS{idProduct}=="a6d0", \
      DRIVER=="", RUN+="/sbin/modprobe -b ftdi_sio"

    ACTION=="add", SUBSYSTEM=="drivers", \
      ENV{DEVPATH}=="/bus/usb-serial/drivers/ftdi_sio", \
      ATTR{new_id}="0403 a6d0"

    ACTION=="add", KERNEL=="ttyUSB*", \
      ATTRS{interface}=="BeagleBone", \
      ATTRS{bInterfaceNumber}=="00", \
      SYMLINK+="beaglebone-jtag"

    ACTION=="add", KERNEL=="ttyUSB*", \
      ATTRS{interface}=="BeagleBone", \
      ATTRS{bInterfaceNumber}=="01", \
      SYMLINK+="beaglebone-serial"
  '';
}
