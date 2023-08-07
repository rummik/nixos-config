{ pkgs, ... }: {
  boot.extraModulePackages = [ pkgs.decklink ];
  systemd.packages = [ pkgs.blackmagic-desktop-video ];
}
