{
  config,
  pkgs,
  ...
}: {
  environment.systemPackages = [pkgs.keybase-gui];
  services.kbfs.enable = true;
  services.keybase.enable = true;
}
