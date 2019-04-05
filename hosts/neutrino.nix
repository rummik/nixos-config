{ config, pkgs, ... }:

{
  imports = [
    ../hardware-configuration.nix
  ];

  programs.tmux.theme.secondaryColor = "cyan";

  environment.systemPackages = with pkgs; [];

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  nix.package = pkgs.nix;

  # Create /etc/bashrc that loads the nix-darwin environment.
  programs.bash.enable = true;
}
