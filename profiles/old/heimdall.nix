{pkgs, ...}: {
  services.udev.packages = [
    pkgs.heimdall
  ];
}
