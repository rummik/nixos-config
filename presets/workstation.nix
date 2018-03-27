{ config, pkgs, ... }:

{
  imports = [
    ../cfgs/chromium.nix
    ../cfgs/google-play-music-desktop-player.nix
    ../cfgs/keybase.nix
    ../cfgs/networkmanager.nix
    ../cfgs/plasma5.nix
    ../cfgs/steam.nix
  ];

  environment.systemPackages = with pkgs; [
    vlc
    electrum
    sqlite
    speedtest-cli
    xclip
    mycli
  ];

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
