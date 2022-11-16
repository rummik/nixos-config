{pkgs, ...}: {
  boot.blacklistedKernelModules = [
    "dvb_usb_rtl28xxu"
  ];

  services.udev.packages = with pkgs; [
    rtl-sdr
  ];
}
