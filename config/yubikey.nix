{ pkgs, ... }:

{
  hardware.u2f.enable = true;
  security.pam.u2f.enable = true;
  services.pcscd.enable = true;

  services.udev.packages = with pkgs; [
    libu2f-host
    yubikey-personalization
  ];

  environment.systemPackages = with pkgs; [
    yubikey-personalization
    yubikey-personalization-gui
  ];
}
