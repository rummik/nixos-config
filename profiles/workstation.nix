{ config, pkgs, ... }:

{
  imports = [
    ./plasma5.nix
    ../config/chromium.nix
    ../config/firefox.nix
    ../config/keybase.nix
    ../config/networkmanager.nix
    ../config/nodejs.nix
    ../config/rust.nix
    ../config/vagrant.nix
    ../config/vlc.nix
    ../config/watson.nix
  ];

  environment.systemPackages = with pkgs; [
    #electrum
    sqlite
    speedtest-cli
    xclip
    mycli
    #kicad
    kubectl
    tio
    upwork
  ];

  programs.adb.enable = true;

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
