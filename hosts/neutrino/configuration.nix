{ config, pkgs, ... }:

{
  imports = [
    ../../config/fonts.nix
    ../../config/nodejs.nix
  ];

  environment.systemPackages = with pkgs; [
    #tpkb
    folderify
  ];

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  nix.package = pkgs.nix;

  # Create /etc/bashrc that loads the nix-darwin environment.
  programs.bash.enable = true;
}
