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
    yubikey-manager
    yubikey-manager-qt
    yubioath-desktop
    yubikey-personalization
    yubikey-personalization-gui
  ];
}
