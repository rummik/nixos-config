{pkgs, ...}: {
  services.apcupsd = {
    enable = true;
  };
}
