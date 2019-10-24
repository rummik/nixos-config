{ pkgs, ... }:

{
  services.gnome3.evolution-data-server.enable = true;

  environment.systemPackages = with pkgs; [
    gnome3.evolution
  ];
}
