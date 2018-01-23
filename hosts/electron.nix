{ config, pkgs, ... }:

{
  imports = [
    <nixpkgs/nixos/modules/installer/scan/not-detected.nix>
    ../cfgs/networkmanager.nix
    ../misc/desktop.nix
    ../misc/general.nix
    ../misc/thinkpad.nix
  ];

  networking.hostName = "electron";

  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.enableCryptodisk = true;
  boot.initrd.luks.devices.crypted.device = "/dev/disk/by-uuid/df9fc797-7e1d-4400-94b1-462d063bc0c4";

  programs.tmux.theme.secondaryColor = "cyan";

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/796e3b3a-7189-4ea4-b39a-5b26d8fb47e1";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/8b35a14f-6c0d-4c97-a4c4-cd594936f789";
    fsType = "ext2";
  };

  environment.systemPackages = with pkgs; [
    parted
    pv
    debootstrap
  ];
}
