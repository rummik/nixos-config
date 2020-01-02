{ config, pkgs, ... }:

{
  imports = [
    ./plasma5.nix
    ../config/barrier.nix
    ../config/keybase.nix
    ../config/networkmanager.nix
    ../config/nodejs.nix
    ../config/vlc.nix
    ../config/watson.nix
    ../config/yubikey.nix
  ];

  environment.systemPackages = with pkgs; [
    #kicad
    kubectl
    libreoffice
    minikube
    minipro
    nixops
    tio
    xclip
    xsel

    android-udev-rules

    #inboxer
    #mailpile
    #sylpheed
    #trojita
  ];

  services.udev.packages = with pkgs; [
    minipro
  ];

  programs.adb.enable = true;

  services.udev.extraRules = /* udevrules */ ''
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
