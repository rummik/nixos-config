{
  config,
  profiles,
  pkgs,
  ...
}: {
  imports = [
    #../config/barrier.nix
    #../config/docker.nix
    #../config/heimdall.nix
    #../config/yubikey.nix

    profiles.virtualisation.binfmt
    profiles.virtualisation.docker
    # profiles.virtualisation.virtualbox
  ];

  environment.systemPackages = with pkgs; [
    #kicad
    libreoffice
    #minipro
    #nixops
    morph
    tio

    android-udev-rules

    #inboxer
    #mailpile
    #sylpheed
    #trojita
  ];

  services.udev.packages = [
    #minipro
  ];

  programs.adb.enable = true;

  services.udev.extraRules =
    # udevrules
    ''
      ACTION=="add", SUBSYSTEM=="usb", \
        ENV{DEVTYPE}=="usb_interface", \
        ATTRS{idVendor}=="0403", \
        ATTRS{idProduct}=="a6d0", \
        DRIVER=="", \
        RUN+="/sbin/modprobe -b ftdi_sio"

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

      ACTION=="add", SUBSYSTEM=="tty", \
        ATTRS{idVendor}=="10c4", \
        ATTRS{idProduct}=="8a2a", \
        ENV{ID_USB_INTERFACE_NUM}=="00", \
        GROUP="100", \
        RUN+="${pkgs.coreutils}/bin/ln -sf %N /dev/iot/zwave", \
        SYMLINK+="iot/zwave"

      ACTION=="add", SUBSYSTEM=="tty", \
        ATTRS{idVendor}=="10c4", \
        ATTRS{idProduct}=="8a2a", \
        ENV{ID_USB_INTERFACE_NUM}=="01", \
        GROUP="100", \
        RUN+="${pkgs.coreutils}/bin/ln -sf %N /dev/iot/zigbee", \
        SYMLINK+="iot/zigbee"

      # Longan Nano
      ATTRS{idVendor}=="28e9", ATTRS{idProduct}=="0189", MODE="0666"

      # Switch Joy-con (L) (Bluetooth only)
      KERNEL=="hidraw*", SUBSYSTEM=="hidraw", KERNELS=="0005:057E:2006.*", MODE="0666"

      # Switch Joy-con (R) (Bluetooth only)
      KERNEL=="hidraw*", SUBSYSTEM=="hidraw", KERNELS=="0005:057E:2007.*", MODE="0666"

      # Switch Pro controller (USB and Bluetooth)
      KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="057e", ATTRS{idProduct}=="2009", MODE="0666"
      KERNEL=="hidraw*", SUBSYSTEM=="hidraw", KERNELS=="0005:057E:2009.*", MODE="0666"

      # Switch Joy-con charging grip (USB only)
      KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="057e", ATTRS{idProduct}=="200e", MODE="0666"
    '';
}
