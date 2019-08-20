{ config, pkgs, ... }:

{
  imports = [
    <nixpkgs/nixos/modules/installer/scan/not-detected.nix>
  ];

  hardware.enableAllFirmware = true;
  hardware.enableRedistributableFirmware = true;

  boot.loader.grub = {
    enable = true;
    version = 2;
    device = "/dev/disk/by-id/wwn-0x5002538e40b257d1";
    enableCryptodisk = true;
    extraInitrd = /boot/initrd.keys.gz;
  };

  boot.initrd.luks.devices.pv-electron = {
    device = "/dev/disk/by-id/wwn-0x5002538e40b257d1-part2";
    allowDiscards = true;
    fallbackToPassword = true;
    keyFile = "/pv-electron.key.bin";
  };

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/796e3b3a-7189-4ea4-b39a-5b26d8fb47e1";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/8b35a14f-6c0d-4c97-a4c4-cd594936f789";
    fsType = "ext2";
  };
}
